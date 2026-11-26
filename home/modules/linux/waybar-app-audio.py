"""Waybar controls for application playback streams on Niri."""
import json
import os
import re
import subprocess
import sys
import threading
from dataclasses import dataclass
from functools import cache
from pathlib import Path
from tempfile import NamedTemporaryFile


def output(*args):
    result = subprocess.run(args, capture_output=True, text=True)
    return result.stdout.strip() if result.returncode == 0 else ""


def niri(query):
    try:
        return json.loads(output("niri", "msg", "--json", query))
    except (OSError, ValueError):
        return None


def normalize(name):
    name = (name or "").casefold().removeprefix(".").removesuffix("-wrapped").removesuffix(".desktop")
    short = re.sub(r"gtk\d*$", "", name.rsplit(".", 1)[-1])
    return re.sub(r"[-_ ]", "", short)


@dataclass
class Stream:
    id: int
    key: list
    name: str
    media: str
    aliases: set
    flatpak_id: str
    pid: int
    running: bool


def playback(graph):
    clients = {obj["id"]: obj["info"]["props"] for obj in graph
               if obj["type"] == "PipeWire:Interface:Client"}
    cookie = next((obj["info"]["cookie"] for obj in graph
                   if obj["type"] == "PipeWire:Interface:Core"), 0)
    streams = []
    for obj in graph:
        if obj["type"] != "PipeWire:Interface:Node":
            continue
        info = obj["info"]
        props = info["props"]
        owner = clients.get(props.get("client.id"), {})
        if (props.get("media.class") != "Stream/Output/Audio"
                or "node.link-group" in props
                or str(props.get("node.virtual")).lower() == "true"
                or props.get("node.name", "").startswith(("effect_output.", "effect_input."))
                or owner.get("application.process.binary") == "wireplumber"):
            continue
        # pipewire-pulse can host multiple apps. Only its node has the app identity.
        identity = {} if owner.get("application.process.binary") == "pipewire-pulse" else owner.copy()
        identity.update(props)
        flatpak_id = identity.get("pipewire.access.portal.app_id") or ""
        names = [identity.get("application.name"), flatpak_id, identity.get("application.id"),
                 identity.get("application.process.binary")]
        aliases = {normalize(name) for name in names if name}
        if not aliases or aliases.intersection({"pipewire", "pipewirepulse", "wireplumber"}):
            continue
        pid = str(identity.get("application.process.id", ""))
        streams.append(Stream(
            obj["id"], [cookie, props["object.serial"]], next(name for name in names if name),
            props.get("media.name", ""), aliases, flatpak_id,
            int(pid) if pid.isdecimal() else 0, info["state"] == "running",
        ))
    return streams


@cache
def ancestry(pid):
    chain = {}
    while pid > 1 and pid not in chain:
        try:
            proc = Path("/proc") / str(pid)
            if proc.stat().st_uid != os.getuid():
                break
            comm, fields = (proc / "stat").read_text().rsplit(") ", 1)
            name = comm.split(" (", 1)[1]
            if name in {"systemd", "niri", "init", "bwrap", "flatpak", "fish", "bash", "sh", "zsh"}:
                break
            chain[pid] = name
            pid = int(fields.split()[1])
        except (OSError, ValueError, IndexError):
            break
    return chain


def match(stream, window):
    pid = window.get("pid") or 0
    window_id = window.get("app_id") or ""
    app = normalize(window_id)
    if stream.flatpak_id:
        # application.process.id can be local to the sandbox's PID namespace.
        if window_id.casefold() == stream.flatpak_id.casefold():
            return 5
        return int(bool(app and app == normalize(stream.flatpak_id)))
    if pid and pid == stream.pid:
        return 4
    audio, gui = ancestry(stream.pid), ancestry(pid)
    if pid in audio or stream.pid in gui:
        return 3
    # A shared app process can own sibling GUI and audio processes. Exclude
    # generic launchers by requiring that ancestor to carry the app's identity.
    if any(normalize(gui[p]) in stream.aliases | {app} for p in gui.keys() & audio.keys()):
        return 2
    return int(bool(app and app in stream.aliases))


def title_match(stream, window):
    return bool(stream.media and stream.media.casefold() in (window.get("title") or "").casefold())


def select(streams, focused, pinned):
    for stream in streams:
        if stream.key == pinned:
            return stream, "已锁定"
    if not streams:
        return None, "自动"
    def priority(stream):
        score = match(stream, focused)
        return score, score > 0 and title_match(stream, focused), stream.running, stream.key[1]
    target = max(streams, key=priority)
    return target, "焦点窗口" if match(target, focused) else "活跃流回退"


def level(stream):
    data = output("wpctl", "get-volume", str(stream.id))
    found = re.fullmatch(r"Volume: ([\d.]+)( \[MUTED\])?", data)
    if not found:
        return "?", False
    return f"{round(float(found[1]) * 100)}%", bool(found[2])


def description(stream, windows, volume, muted):
    matches = [w for w in windows if match(stream, w)]
    matches.sort(key=lambda w: (match(stream, w), title_match(stream, w)), reverse=True)
    # A shared browser process alone cannot identify a particular tab/window.
    title = ""
    if matches and (len(matches) == 1 or
                    (match(stream, matches[0]), title_match(stream, matches[0])) >
                    (match(stream, matches[1]), title_match(stream, matches[1]))):
        title = matches[0].get("title")
    parts = dict.fromkeys(filter(None, (stream.name, stream.media, title)))
    return " · ".join(" ".join(p.split()) for p in parts) + f"  {volume}" + (" 静音" if muted else "")


def close_window(window_id):
    subprocess.run(["niri", "msg", "action", "close-window", "--id", str(window_id)],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def mixer():
    windows = niri("windows") or []
    workspaces = niri("workspaces") or []
    active_ws = next((ws["id"] for ws in workspaces if ws.get("is_focused")), None)
    existing = [w for w in windows if w.get("app_id") == "wiremix-mixer"]
    if existing:
        on_active = any(w.get("workspace_id") == active_ws for w in existing) if active_ws is not None else True
        for window in existing:
            close_window(window["id"])
        if on_active:
            return

    events = subprocess.Popen(["niri", "msg", "--json", "event-stream"],
                              stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
    proc = subprocess.Popen(["kitty", "--class", "wiremix-mixer", "--title", "Audio Mixer",
                             "-e", "wiremix", "--tab", "playback"])

    def stop_on_exit():
        proc.wait()
        if events.poll() is None:
            events.terminate()

    threading.Thread(target=stop_on_exit, daemon=True).start()
    mixer_id = None
    mixer_ws = None
    seen_focus = False
    try:
        for line in events.stdout:
            try:
                event = json.loads(line)
            except ValueError:
                continue
            if "WindowOpenedOrChanged" in event:
                window = event["WindowOpenedOrChanged"].get("window") or {}
                if window.get("app_id") == "wiremix-mixer" and (mixer_id is None or window.get("id") == mixer_id):
                    mixer_id = window.get("id")
                    mixer_ws = window.get("workspace_id")
                    if window.get("is_focused"):
                        seen_focus = True
            elif "WindowFocusChanged" in event:
                focused_id = event["WindowFocusChanged"].get("id")
                if mixer_id is not None and focused_id == mixer_id:
                    seen_focus = True
                elif mixer_id is not None and seen_focus and focused_id != mixer_id:
                    close_window(mixer_id)
                    break
            elif "WorkspaceActivated" in event and seen_focus and mixer_id is not None:
                ws = event["WorkspaceActivated"]
                if ws.get("focused") and mixer_ws is not None and ws.get("id") != mixer_ws:
                    close_window(mixer_id)
                    break
            elif "WindowClosed" in event and mixer_id is not None:
                if event["WindowClosed"].get("id") == mixer_id:
                    break
    finally:
        if events.poll() is None:
            events.terminate()
        events.wait()


def refresh():
    subprocess.run(["pkill", "-RTMIN+8", "-x", r"(\.waybar-wrapped|waybar)"])


def save_pin(path, key):
    with NamedTemporaryFile(mode="w", dir=path.parent, delete=False) as temp:
        json.dump(key, temp)
    os.replace(temp.name, path)


def main(args):
    if args == ["mixer"]:
        return mixer()
    path = Path(os.environ["XDG_RUNTIME_DIR"]) / "waybar-app-audio.json"
    try:
        pin = json.loads(path.read_text())
    except (FileNotFoundError, ValueError):
        pin = None
    data = output("pw-dump")
    streams = playback(json.loads(data)) if data else []
    focused = niri("focused-window") or {}
    target, mode = select(streams, focused, pin)
    if args in (["volume", "up"], ["volume", "down"], ["mute"]):
        if target:
            node = str(target.id)
            command = (["set-mute", node, "toggle"] if args == ["mute"] else
                       ["set-volume", node, "2%+" if args[1] == "up" else "2%-", "-l", "1.5"])
            subprocess.run(["wpctl", *command], check=True)
            refresh()
        return
    windows = niri("windows") or []
    levels = {s.id: level(s) for s in streams}
    rows = [("● " if s == target else "  ") + description(s, windows, *levels[s.id]) for s in streams]
    if args == ["menu"]:
        auto = ("✓ " if mode != "已锁定" else "") + "跟随当前焦点窗口 (自动)"
        items = [auto, *rows, "打开应用混音器 (wiremix)", "打开完整音频设置 (pavucontrol)"]
        choice = subprocess.run(["fuzzel", "--dmenu", "--index"], input="\n".join(items),
                                text=True, stdout=subprocess.PIPE)
        if choice.returncode == 0 and choice.stdout.strip().isdecimal():
            index = int(choice.stdout)
            if index <= len(streams):
                save_pin(path, streams[index - 1].key if index else None)
                refresh()
            elif index == len(streams) + 1:
                mixer()
            elif index == len(streams) + 2:
                os.execlp("pavucontrol", "pavucontrol")
        return
    if args != ["status"]:
        raise SystemExit("usage: status | volume up/down | mute | menu | mixer")
    result = {"text": "", "class": "empty", "alt": "empty", "tooltip": "无应用播放流"}
    if target:
        volume, muted = levels[target.id]
        label = " ".join(target.name.split())
        if len(label) > 10:
            label = label[:9] + "…"
        icon = "󰝟" if muted else ""
        result = {"text": f"{icon} {label} {volume}", "class": "muted" if muted else "active",
                  "alt": mode, "tooltip": "\n".join([mode, *rows, "",
                    "滚轮调音量 · 右键静音 · 左键切换应用 · 中键混音器"])}
    print(json.dumps(result, ensure_ascii=False))


if __name__ == "__main__":
    main(sys.argv[1:])
