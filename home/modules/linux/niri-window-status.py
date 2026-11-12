"""Merge current-workspace windows with i3status-rust's i3bar stream."""

import json
import queue
import re
import signal
import socket
import subprocess
import sys
import threading
import time


# Nerd Font glyphs, rendered by the bar's existing font.
APP_ICONS = {
    "kitty": "\uf120",
    "alacritty": "\uf120",
    "org.wezfurlong.wezterm": "\uf120",
    "chromium-browser": "\uf268",
    "chromium": "\uf268",
    "google-chrome": "\uf268",
    "firefox": "\uf269",
    "org.mozilla.firefox": "\uf269",
    "code": "\ue70c",
    "code-oss": "\ue70c",
    "vesktop": "\uf392",
    "discord": "\uf392",
    "dev.vencord.vesktop": "\uf392",
    "md.obsidian": "\uf249",
    "obsidian": "\uf249",
    ".virt-manager-wrapped": "\uf108",
    "virt-manager": "\uf108",
    "kazumi": "\uf144",
    "halloy": "\uf086",
    "org.kde.dolphin": "\uf07b",
    "org.gnome.nautilus": "\uf07b",
}


TERMINALS = {"kitty", "alacritty", "org.wezfurlong.wezterm"}
LOCAL_HOST = socket.gethostname().split(".", 1)[0].lower()


def compact_text(text, limit=10):
    """Limit detail text to ten characters, including the ellipsis."""
    text = " ".join(text.split())
    return text if len(text) <= limit else text[:limit - 1] + "…"


def focused_context(app, title):
    title = " ".join((title or "").split())
    if app in TERMINALS:
        # Fish's remote-shell title starts with [hostname]. Other shells often
        # use user@hostname:path. These are title hints, not a process probe.
        remote = re.match(r"^(?:\[([^\]]+)\]|[^\s@]+@([^\s:]+):)(.*)$", title)
        if remote:
            host = remote[1] or remote[2]
            if host.split(".", 1)[0].lower() not in {LOCAL_HOST, "localhost"}:
                title = f"远程 {host} {remote[3].strip()}"
        # An explicit ssh command in the title is already useful as-is.
        return compact_text(title)
    for suffix in (" - Chromium", " - Google Chrome", " — Mozilla Firefox",
                   " - Mozilla Firefox", " - Visual Studio Code"):
        if title.endswith(suffix):
            title = title[:-len(suffix)]
            break
    return compact_text(title)


def window_blocks(windows, workspaces):
    workspace = next((w["id"] for w in workspaces if w["is_focused"]), None)
    if workspace is None:
        return []
    visible = [w for w in windows if w.get("workspace_id") == workspace]
    visible.sort(key=lambda w: (
        w.get("layout", {}).get("pos_in_scrolling_layout") or [999999, 999999],
        w["id"],
    ))
    blocks = []
    for window in visible:
        app = window.get("app_id") or ""
        name = app.rsplit(".", 1)[-1] or window.get("title") or "Window"
        label = APP_ICONS.get(app.lower(), (" ".join(name.split()) or "Window")[:3])
        focused = window.get("is_focused", False)
        context = focused_context(app.lower(), window.get("title")) if focused else ""
        blocks.append({
            "name": "niri_windows",
            "instance": str(window["id"]),
            "full_text": " " + label + (" " + context if context else "") + " ",
            "short_text": " " + label + " ",
            "color": "#3c4841" if focused else "#d3c6aa",
            "background": "#a7c080" if focused else "#3c4841",
            "separator": False,
            "separator_block_width": 0,
        })
    return blocks


def main():
    updates = queue.Queue()
    stopped = threading.Event()
    event_processes = []
    def stop(signum, frame):
        raise SystemExit(0)
    signal.signal(signal.SIGTERM, stop)
    status = subprocess.Popen(
        ["i3status-rs", sys.argv[1]], stdin=subprocess.PIPE,
        stdout=subprocess.PIPE, text=True, bufsize=1,
    )

    def read_status():
        for line in status.stdout:
            try:
                value = json.loads(line.strip().strip(","))
            except json.JSONDecodeError:
                continue
            if isinstance(value, list):
                updates.put(("status", value))
        updates.put(("exit", status.wait()))

    def read_windows():
        # The initial event-stream snapshot also triggers a refresh after restart.
        while not stopped.is_set():
            events = subprocess.Popen(
                ["niri", "msg", "--json", "event-stream"],
                stdout=subprocess.PIPE, text=True,
            )
            event_processes.append(events)
            try:
                for line in events.stdout:
                    updates.put(("windows", None))
            finally:
                events.stdout.close()
                events.wait()
                event_processes.remove(events)
            updates.put(("clear", None))
            stopped.wait(1)

    def clicks():
        for line in sys.stdin:
            try:
                event = json.loads(line.strip().strip(","))
            except json.JSONDecodeError:
                continue
            if event.get("name") == "niri_windows":
                if event.get("button") == 1:
                    subprocess.run([
                        "niri", "msg", "action", "focus-window", "--id",
                        str(int(event["instance"])),
                    ], stdout=subprocess.DEVNULL, check=False)
            else:
                try:
                    status.stdin.write(json.dumps(event) + "\n")
                    status.stdin.flush()
                except (BrokenPipeError, ValueError):
                    return

    for target in (read_status, read_windows, clicks):
        threading.Thread(target=target, daemon=True).start()
    print(json.dumps({"version": 1, "click_events": True}), flush=True)
    print("[", flush=True)
    right, left = [], []
    first = True
    try:
        while True:
            pending = [updates.get()]
            # Coalesce bursts of Niri events into a single snapshot.
            time.sleep(0.03)
            while not updates.empty():
                pending.append(updates.get_nowait())
            refresh = False
            for kind, value in pending:
                if kind == "exit":
                    return value
                if kind == "status":
                    right = value
                elif kind == "clear":
                    left = []
                elif kind == "windows":
                    refresh = True
            if refresh:
                try:
                    def query(command):
                        return json.loads(subprocess.check_output(
                            ["niri", "msg", "--json", command], text=True, timeout=2,
                        ))
                    left = window_blocks(query("windows"), query("workspaces"))
                except (subprocess.SubprocessError, ValueError):
                    left = []
            print(("" if first else ",") + json.dumps(left + right), flush=True)
            first = False
    finally:
        stopped.set()
        for process in event_processes[:]:
            process.terminate()
        status.terminate()
        status.wait()


if __name__ == "__main__":
    try:
        sys.exit(main())
    except BrokenPipeError:
        pass
