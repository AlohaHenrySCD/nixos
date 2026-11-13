"""Trigger Kitty 0.50's native logout snapshots under Niri."""

import argparse
from concurrent.futures import ThreadPoolExecutor
import json
import os
from pathlib import Path
import subprocess
import sys
import time


def kitty_pids():
    pids = []
    for process in Path("/proc").glob("[0-9]*"):
        try:
            if process.stat().st_uid == os.getuid() and (process / "comm").read_text().strip() in ("kitty", ".kitty-wrapped"):
                pids.append(int(process.name))
        except (FileNotFoundError, ProcessLookupError, PermissionError):
            continue
    return pids


def snapshot_operation(pid, operation):
    socket = Path(os.environ["XDG_RUNTIME_DIR"]) / f"kitty-session-{pid}.sock"
    if not socket.exists():
        raise RuntimeError(f"Kitty {pid} predates the session setup. Press Ctrl+Shift+F5 in that instance, then close and reopen it once.")
    started = time.time()
    result = subprocess.run(
        ["kitten", "@", "--to", f"unix:{socket}", "kitten", os.environ["KITTY_SESSION_KITTEN"], operation],
        check=True, capture_output=True, text=True, timeout=3,
    )
    if operation == "cancel":
        return
    # The action logs save errors internally; verify that it actually wrote a fresh snapshot.
    snapshot = Path(result.stdout.strip())
    metadata = json.loads((snapshot / "process.json").read_text())
    if metadata["saved_at"] < started or not (snapshot / "session.kitty-session").is_file():
        raise RuntimeError(f"Kitty {pid} did not write a fresh logout snapshot")


def snapshots(operation="save"):
    pids = kitty_pids()
    errors = []
    if pids:
        with ThreadPoolExecutor(max_workers=len(pids)) as executor:
            results = [(pid, executor.submit(snapshot_operation, pid, operation)) for pid in pids]
            for pid, result in results:
                try:
                    result.result()
                except Exception as error:
                    # A terminal closed while the snapshot was requested needs no restoration.
                    if Path(f"/proc/{pid}").exists():
                        errors.append(str(error))
    if errors:
        raise RuntimeError("\n".join(errors))
    print(f"{operation}: {len(pids)} native Kitty instance(s)", flush=True)


def logout():
    result = subprocess.run(
        ["fuzzel", "--dmenu", "--prompt=Log out? ", "--lines=2"],
        input="Cancel\nSave Kitty and log out\n", text=True, capture_output=True,
    )
    if result.returncode != 0 or result.stdout.strip() != "Save Kitty and log out":
        return
    try:
        snapshots()
        subprocess.run(["niri", "msg", "action", "quit", "--skip-confirmation"], check=True)
    except Exception:
        try:
            snapshots("cancel")
        except Exception:
            pass
        raise


def watch_shutdown():
    import dbus
    from dbus.mainloop.glib import DBusGMainLoop
    from gi.repository import GLib

    DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()
    manager = dbus.Interface(bus.get_object("org.freedesktop.login1", "/org/freedesktop/login1"), "org.freedesktop.login1.Manager")
    inhibitor = None

    def inhibit():
        nonlocal inhibitor
        inhibitor = manager.Inhibit("shutdown", "Kitty session restore", "Save terminal windows and scrollback", "delay").take()

    def prepare_for_shutdown(active):
        nonlocal inhibitor
        if active:
            try:
                snapshots()
            except Exception as error:
                print(f"Failed to save Kitty sessions: {error}", file=sys.stderr, flush=True)
            finally:
                if inhibitor is not None:
                    os.close(inhibitor)
                    inhibitor = None
        elif inhibitor is None:
            inhibit()
            try:
                snapshots("cancel")
            except Exception as error:
                print(f"Failed to cancel Kitty snapshots: {error}", file=sys.stderr, flush=True)

    manager.connect_to_signal("PrepareForShutdown", prepare_for_shutdown)
    inhibit()
    print("Listening for shutdown; delay inhibitor acquired", flush=True)
    try:
        GLib.MainLoop().run()
    finally:
        if inhibitor is not None:
            os.close(inhibitor)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("save", "logout", "watch-shutdown"))
    args = parser.parse_args()
    try:
        {"save": snapshots, "logout": logout, "watch-shutdown": watch_shutdown}[args.command]()
    except Exception as error:
        print(str(error), file=sys.stderr)
        if args.command == "logout":
            subprocess.run(["notify-send", "--urgency=critical", "Kitty session was not saved", str(error)], check=False)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
