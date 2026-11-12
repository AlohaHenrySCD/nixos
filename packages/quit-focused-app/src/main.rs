mod x11 {
    use crate::Result;
    use x11rb::{
        connection::Connection,
        protocol::xproto::{AtomEnum, ConnectionExt, GetPropertyReply},
        rust_connection::RustConnection,
    };
    #[derive(Debug, PartialEq)]
    pub struct X11Window {
        pub id: u32,
        pub pid: i32,
        pub classes: Vec<String>,
        pub title: String,
    }
    fn property(c: &RustConnection, window: u32, name: &[u8]) -> Result<GetPropertyReply> {
        let atom = c.intern_atom(true, name)?.reply()?.atom;
        if atom == 0 {
            return Err(format!("Missing X11 property {}", String::from_utf8_lossy(name)).into());
        }
        Ok(c.get_property(false, window, atom, AtomEnum::ANY, 0, 4096)?
            .reply()?)
    }
    fn number(p: GetPropertyReply) -> Result<u32> {
        let mut values = p.value32().ok_or("Invalid X11 numeric property")?;
        let value = values.next().ok_or("Empty X11 numeric property")?;
        if values.next().is_some() || p.bytes_after != 0 {
            return Err("Ambiguous X11 numeric property".into());
        }
        Ok(value)
    }
    fn text(p: GetPropertyReply) -> Result<String> {
        if p.format != 8 || p.bytes_after != 0 {
            return Err("Invalid X11 text property".into());
        }
        Ok(String::from_utf8(p.value)?
            .trim_end_matches('\0')
            .to_owned())
    }
    pub fn active_window() -> Result<X11Window> {
        let (c, screen) = x11rb::connect(None)?;
        let root = c.setup().roots[screen].root;
        let active = || number(property(&c, root, b"_NET_ACTIVE_WINDOW")?);
        let id = active()?;
        if id == 0 {
            return Err("No active X11 window".into());
        }
        let pid = i32::try_from(number(property(&c, id, b"_NET_WM_PID")?)?)?;
        if pid <= 1 {
            return Err("Invalid X11 application PID".into());
        }
        let classes = text(property(&c, id, b"WM_CLASS")?)?
            .split('\0')
            .filter(|s| !s.is_empty())
            .map(str::to_owned)
            .collect();
        let title = property(&c, id, b"_NET_WM_NAME")
            .and_then(text)
            .or_else(|_| text(property(&c, id, b"WM_NAME")?))?;
        if active()? != id {
            return Err("The active X11 window changed during inspection".into());
        }
        Ok(X11Window {
            id,
            pid,
            classes,
            title,
        })
    }
}

use serde_json::{Value, json};
use std::os::{
    fd::{AsRawFd, FromRawFd, OwnedFd},
    unix::fs::MetadataExt,
};
use std::{
    collections::BTreeMap,
    env, fs, io,
    path::PathBuf,
    process::{Command, ExitCode},
    thread,
    time::Duration,
};

type Result<T> = std::result::Result<T, Box<dyn std::error::Error>>;

#[derive(Clone, Debug)]
struct Process {
    pid: i32,
    parent: i32,
    start: u64,
    executable: PathBuf,
}

fn executable_name(p: &Process) -> String {
    p.executable
        .file_name()
        .unwrap_or_default()
        .to_string_lossy()
        .trim_start_matches('.')
        .trim_end_matches("-wrapped")
        .to_lowercase()
}
fn is_satellite(p: &Process) -> bool {
    executable_name(p) == "xwayland-satellite"
}
fn reject_shared(p: &Process) -> Result<()> {
    if matches!(
        executable_name(p).as_str(),
        "niri" | "xwayland" | "xwayland-satellite"
    ) {
        return Err(format!(
            "Refusing to target shared desktop process {}",
            p.executable.display()
        )
        .into());
    }
    Ok(())
}
#[derive(Debug, PartialEq)]
struct FocusedWindow {
    id: u64,
    pid: i32,
    app_id: Option<String>,
    title: Option<String>,
}
fn focused_window() -> Result<Option<FocusedWindow>> {
    let output = Command::new("niri")
        .args(["msg", "-j", "focused-window"])
        .output()?;
    if !output.status.success() {
        return Err(String::from_utf8_lossy(&output.stderr)
            .trim()
            .to_owned()
            .into());
    }
    let w: Value = serde_json::from_slice(&output.stdout)?;
    if w.is_null() {
        return Ok(None);
    }
    Ok(Some(FocusedWindow {
        id: w["id"].as_u64().ok_or("Missing focused window ID")?,
        pid: i32::try_from(w["pid"].as_i64().ok_or("Missing focused window PID")?)?,
        app_id: w["app_id"].as_str().map(str::to_owned),
        title: w["title"].as_str().map(str::to_owned),
    }))
}
fn focused_target(f: &FocusedWindow, p: &Process, x: Option<&x11::X11Window>) -> Result<i32> {
    if !is_satellite(p) {
        reject_shared(p)?;
        return Ok(p.pid);
    }
    let x = x.ok_or("Cannot identify the focused X11 application")?;
    let app_id = f
        .app_id
        .as_deref()
        .filter(|s| !s.is_empty())
        .ok_or("Missing focused X11 app ID")?;
    let title = f
        .title
        .as_deref()
        .filter(|s| !s.is_empty())
        .ok_or("Missing focused X11 title")?;
    if !x.classes.iter().any(|class| class == app_id) || x.title != title {
        return Err("The active X11 window does not match the focused Niri window".into());
    }
    Ok(x.pid)
}
fn confirm_focus(f: &FocusedWindow, x: Option<&x11::X11Window>) -> Result<()> {
    if focused_window()?.as_ref() != Some(f) {
        return Err("Niri focus changed; no quit request was sent".into());
    }
    if let Some(expected) = x
        && x11::active_window()? != *expected
    {
        return Err("X11 focus changed; no quit request was sent".into());
    }
    Ok(())
}

fn process(pid: i32) -> Option<Process> {
    if pid <= 1 {
        return None;
    }
    let dir = PathBuf::from(format!("/proc/{pid}"));
    // SAFETY: geteuid has no preconditions or pointer arguments.
    if fs::metadata(&dir).ok()?.uid() != unsafe { libc::geteuid() } {
        return None;
    }
    let stat = fs::read_to_string(dir.join("stat")).ok()?;
    let fields: Vec<_> = stat.rsplit_once(')')?.1.split_whitespace().collect();
    Some(Process {
        pid,
        parent: fields.get(1)?.parse().ok()?,
        start: fields.get(19)?.parse().ok()?,
        executable: fs::read_link(dir.join("exe")).ok()?,
    })
}

fn application_processes(pid: i32) -> Result<(Process, BTreeMap<i32, Process>)> {
    let mut root = process(pid).ok_or("The focused application's process is unavailable")?;
    reject_shared(&root)?;
    // Electron can report a renderer PID instead of the main process.
    while let Some(parent) = process(root.parent) {
        if parent.executable != root.executable {
            break;
        }
        root = parent;
    }
    let candidates: Vec<_> = fs::read_dir("/proc")?
        .filter_map(|entry| entry.ok()?.file_name().to_str()?.parse().ok())
        .filter_map(process)
        .collect();
    let mut selected = BTreeMap::from([(root.pid, root.clone())]);
    loop {
        let children: Vec<_> = candidates
            .iter()
            .filter(|p| {
                selected.contains_key(&p.parent)
                    && !selected.contains_key(&p.pid)
                    && reject_shared(p).is_ok()
            })
            .cloned()
            .collect();
        if children.is_empty() {
            return Ok((root, selected));
        }
        selected.extend(children.into_iter().map(|p| (p.pid, p)));
    }
}

fn bus(arguments: &[&str]) -> Result<Value> {
    let output = Command::new("busctl")
        .args(["--user", "--timeout=1", "--json=short", "--"])
        .args(arguments)
        .output()?;
    if !output.status.success() {
        return Err(String::from_utf8_lossy(&output.stderr)
            .trim()
            .to_owned()
            .into());
    }
    if output.stdout.is_empty() {
        return Ok(Value::Null);
    }
    let mut value: Value = serde_json::from_slice(&output.stdout)?;
    Ok(value["data"].take())
}

fn quit_item(layout: &Value) -> Option<i64> {
    let props = &layout[1];
    if props["enabled"]["data"] == false || props["visible"]["data"] == false {
        return None;
    }
    let label = props["label"]["data"]
        .as_str()
        .unwrap_or_default()
        .replace(['&', '_'], "")
        .trim()
        .to_lowercase();
    if matches!(
        label.as_str(),
        "quit"
            | "quit completely"
            | "quit application"
            | "exit"
            | "exit application"
            | "退出"
            | "完全退出"
            | "退出应用"
            | "退出程序"
    ) {
        return layout[0].as_i64();
    }
    layout[2]
        .as_array()?
        .iter()
        .find_map(|child| quit_item(&child["data"]))
}

#[derive(Debug)]
struct NativeQuit {
    service: String,
    menu: String,
    item: i64,
}

fn tray_quit(item: &str, processes: &BTreeMap<i32, Process>) -> Result<Option<NativeQuit>> {
    let (service, path) = item.split_once('/').map_or(
        (item, "/StatusNotifierItem".to_owned()),
        |(service, path)| (service, format!("/{path}")),
    );
    // A unique connection prevents an app restart from receiving a stale menu action.
    let connection = bus(&[
        "call",
        "org.freedesktop.DBus",
        "/org/freedesktop/DBus",
        "org.freedesktop.DBus",
        "GetNameOwner",
        "s",
        service,
    ])?;
    let connection = connection[0]
        .as_str()
        .ok_or("Invalid D-Bus connection name")?;
    let owner = bus(&[
        "call",
        "org.freedesktop.DBus",
        "/org/freedesktop/DBus",
        "org.freedesktop.DBus",
        "GetConnectionUnixProcessID",
        "s",
        connection,
    ])?;
    let owner = owner[0].as_i64().and_then(|pid| i32::try_from(pid).ok());
    let Some(expected) = owner.and_then(|pid| processes.get(&pid)) else {
        return Ok(None);
    };
    if !process(expected.pid).is_some_and(|current| current.start == expected.start) {
        return Ok(None);
    }
    let menu = bus(&[
        "get-property",
        connection,
        &path,
        "org.kde.StatusNotifierItem",
        "Menu",
    ])?;
    let menu = menu.as_str().ok_or("Invalid tray menu path")?;
    let layout = bus(&[
        "call",
        connection,
        menu,
        "com.canonical.dbusmenu",
        "GetLayout",
        "iias",
        "0",
        "-1",
        "3",
        "label",
        "enabled",
        "visible",
    ])?;
    Ok(quit_item(&layout[1]).map(|item| NativeQuit {
        service: connection.to_owned(),
        menu: menu.to_owned(),
        item,
    }))
}

fn native_quit(processes: &BTreeMap<i32, Process>) -> Option<NativeQuit> {
    let items = bus(&[
        "get-property",
        "org.kde.StatusNotifierWatcher",
        "/StatusNotifierWatcher",
        "org.kde.StatusNotifierWatcher",
        "RegisteredStatusNotifierItems",
    ])
    .ok()?;
    items
        .as_array()?
        .iter()
        .filter_map(Value::as_str)
        .find_map(|item| tray_quit(item, processes).ok().flatten())
}

fn invoke_quit(action: &NativeQuit) -> Result<()> {
    bus(&[
        "call",
        &action.service,
        &action.menu,
        "com.canonical.dbusmenu",
        "Event",
        "isvu",
        &action.item.to_string(),
        "clicked",
        "i",
        "0",
        "0",
    ])?;
    Ok(())
}

fn terminate(expected: &Process) -> io::Result<()> {
    reject_shared(expected).map_err(|e| io::Error::other(e.to_string()))?;
    // SAFETY: pidfd_open takes a PID and flags, with no pointer arguments.
    let fd = unsafe { libc::syscall(libc::SYS_pidfd_open, expected.pid, 0u32) as libc::c_int };
    if fd < 0 {
        let err = io::Error::last_os_error();
        return if err.raw_os_error() == Some(libc::ESRCH) {
            Ok(())
        } else {
            Err(err)
        };
    }
    // SAFETY: pidfd_open returned a new descriptor owned by this function.
    let fd = unsafe { OwnedFd::from_raw_fd(fd) };
    let Some(current) = process(expected.pid) else {
        return Ok(());
    };
    if current.start != expected.start {
        return Ok(());
    }
    reject_shared(&current).map_err(|e| io::Error::other(e.to_string()))?;
    // SAFETY: fd is a valid pidfd; null siginfo requests normal signal delivery.
    let status = unsafe {
        libc::syscall(
            libc::SYS_pidfd_send_signal,
            fd.as_raw_fd(),
            libc::SIGTERM,
            std::ptr::null::<libc::siginfo_t>(),
            0u32,
        )
    };
    if status < 0 {
        let err = io::Error::last_os_error();
        if err.raw_os_error() != Some(libc::ESRCH) {
            return Err(err);
        }
    }
    Ok(())
}

#[derive(Default)]
struct Options {
    dry_run: bool,
    pid: Option<i32>,
    help: bool,
}

fn options(arguments: impl IntoIterator<Item = String>) -> Result<Options> {
    let mut opts = Options::default();
    let mut arguments = arguments.into_iter();
    while let Some(arg) = arguments.next() {
        match arg.as_str() {
            "--dry-run" => opts.dry_run = true,
            "--pid" => opts.pid = Some(arguments.next().ok_or("Missing PID")?.parse()?),
            "-h" | "--help" => opts.help = true,
            _ => return Err(format!("Unknown option: {arg}").into()),
        }
    }
    if opts.pid.is_some() && !opts.dry_run {
        return Err("--pid requires --dry-run".into());
    }
    Ok(opts)
}

fn run(opts: Options) -> Result<()> {
    if opts.help {
        println!(
            "Usage: quit-focused-app [--dry-run [--pid PID]]\n\nQuit the focused Niri application. Prefer its tray Quit action; otherwise\nsend SIGTERM to its process tree. --dry-run only reports the intended target."
        );
        return Ok(());
    }
    let focus = if opts.pid.is_none() {
        focused_window()?
    } else {
        None
    };
    let (pid, x11_window) = match opts.pid {
        Some(pid) => (pid, None),
        None => {
            let Some(focus) = focus.as_ref() else {
                return Ok(());
            };
            let reported = process(focus.pid).ok_or("The focused process is unavailable")?;
            let x11_window = if is_satellite(&reported) {
                Some(x11::active_window()?)
            } else {
                None
            };
            (
                focused_target(focus, &reported, x11_window.as_ref())?,
                x11_window,
            )
        }
    };
    let (root, processes) = application_processes(pid)?;
    let action = native_quit(&processes);
    if let Some(focus) = focus.as_ref() {
        confirm_focus(focus, x11_window.as_ref())?;
    }
    if opts.dry_run {
        let action = action.map(|a| json!({"service":a.service,"menu":a.menu,"item":a.item}));
        println!(
            "{}",
            json!({"main_pid":root.pid,"processes":processes.keys().collect::<Vec<_>>(),"native_quit":action})
        );
        return Ok(());
    }
    if let Some(action) = action {
        // A native request may show a save dialog; never override it with a signal.
        return invoke_quit(&action);
    }
    terminate(&root)?;
    thread::sleep(Duration::from_secs(1));
    for child in processes.values().rev().filter(|p| p.pid != root.pid) {
        terminate(child)?;
    }
    Ok(())
}

fn main() -> ExitCode {
    match options(env::args().skip(1)).and_then(run) {
        Ok(()) => ExitCode::SUCCESS,
        Err(err) => {
            eprintln!("quit-focused-app: {err}");
            ExitCode::FAILURE
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn fixture_process(name: &str, pid: i32) -> Process {
        Process {
            pid,
            parent: 2,
            start: 1,
            executable: format!("/bin/{name}").into(),
        }
    }
    fn fixture_focus() -> FocusedWindow {
        FocusedWindow {
            id: 7,
            pid: 100,
            app_id: Some("Chatgpt".into()),
            title: Some("ChatGPT".into()),
        }
    }
    fn fixture_x11() -> x11::X11Window {
        x11::X11Window {
            id: 12,
            pid: 200,
            classes: vec!["Chatgpt".into()],
            title: "ChatGPT".into(),
        }
    }
    #[test]
    fn shared_desktop_processes_are_never_application_targets() {
        for name in [
            "niri",
            ".niri-wrapped",
            "Xwayland",
            "xwayland-satellite",
            ".xwayland-satellite-wrapped",
        ] {
            assert!(reject_shared(&fixture_process(name, 100)).is_err());
        }
        assert!(reject_shared(&fixture_process("ChatGPT", 200)).is_ok());
    }
    #[test]
    fn satellite_uses_the_matching_x11_client_pid() {
        let satellite = fixture_process(".xwayland-satellite-wrapped", 100);
        assert_eq!(
            focused_target(&fixture_focus(), &satellite, Some(&fixture_x11())).unwrap(),
            200
        );
        assert!(focused_target(&fixture_focus(), &satellite, None).is_err());
    }
    #[test]
    fn mismatched_or_missing_x11_identity_is_rejected() {
        let satellite = fixture_process("xwayland-satellite", 100);
        let mut x = fixture_x11();
        x.title = "Another window".into();
        assert!(focused_target(&fixture_focus(), &satellite, Some(&x)).is_err());
        let mut x = fixture_x11();
        x.classes = vec!["AnotherApp".into()];
        assert!(focused_target(&fixture_focus(), &satellite, Some(&x)).is_err());
        let mut f = fixture_focus();
        f.title = None;
        assert!(focused_target(&f, &satellite, Some(&fixture_x11())).is_err());
    }
    #[test]
    fn wayland_focus_does_not_use_a_stale_x11_active_window() {
        assert_eq!(
            focused_target(
                &fixture_focus(),
                &fixture_process("kitty", 300),
                Some(&fixture_x11())
            )
            .unwrap(),
            300
        );
    }

    #[test]
    fn finds_nested_quit_and_ignores_disabled_or_hidden_actions() {
        let layout = json!([0,{},[
            {"data":[1,{"label":{"data":"Quit completely"},"enabled":{"data":false}},[]]},
            {"data":[2,{"label":{"data":"Exit"},"visible":{"data":false}},[]]},
            {"data":[3,{},[{"data":[4,{"label":{"data":"&Quit"}},[]]}]]}
        ]]);
        assert_eq!(quit_item(&layout), Some(4));
        assert_eq!(quit_item(&json!([0, {}, []])), None);
        assert_eq!(
            quit_item(&json!([1,{"label":{"data":"Quit on window close"}},[]])),
            None
        );
    }
    #[test]
    fn pid_override_is_read_only() {
        assert!(options(["--pid".into(), "123".into()]).is_err());
        assert_eq!(
            options(["--dry-run".into(), "--pid".into(), "123".into()])
                .unwrap()
                .pid,
            Some(123)
        );
    }
    #[test]
    fn replaced_pid_is_not_signalled() {
        let mut current = process(std::process::id() as i32).unwrap();
        current.start += 1;
        terminate(&current).unwrap();
    }
    #[test]
    fn sigterm_reaches_only_the_owned_fixture() {
        let mut child = Command::new("sleep").arg("30").spawn().unwrap();
        let target = process(child.id() as i32).unwrap();
        terminate(&target).unwrap();
        use std::os::unix::process::ExitStatusExt;
        assert_eq!(child.wait().unwrap().signal(), Some(libc::SIGTERM));
    }
}
