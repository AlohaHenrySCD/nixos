# quit-focused-app

A Rust command for quitting the application behind the focused Niri window,
including tray/background processes. It resolves Electron renderer processes to
their main process and uses the application's existing tray Quit action when
available. A native Quit request can show a save dialog or be cancelled.

When no native tray Quit action is available, it sends SIGTERM to the main
process, waits one second, and signals its remaining owned descendants. This
fallback may bypass save prompts. It never sends SIGKILL and does not stop shared
system services. Processes that ignore SIGTERM can remain running.

The command uses `niri` and `busctl`; the Nix package supplies both on PATH.

```sh
cargo run -- --dry-run
cargo run -- --dry-run --pid 1234
cargo run -- --help
```

`--pid` is available only with `--dry-run`, so inspection cannot accidentally
terminate a PID supplied on the command line. Run `quit-focused-app` without
arguments to quit the currently focused application.

The Home Manager module in `/etc/nixos/home/modules/linux/quit-focused-app.nix`
builds this project. Its Niri binding is `Mod+Shift+Q`; `Mod+Q` still closes only
the focused window. Apply the NixOS configuration with the usual rebuild after
changing this project.

For X11 applications, Niri reports the shared xwayland-satellite PID. The command
resolves the active X11 window's _NET_WM_PID and requires its class and title to
match Niri's focused window. Missing or mismatched identity cancels the operation.
Niri, Xwayland, and xwayland-satellite are never valid termination targets.
