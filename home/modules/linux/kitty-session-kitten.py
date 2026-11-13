from kittens.tui.handler import result_handler


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    from kitty.logout_session import DESKTOP_SESSION_QUERY_END, DESKTOP_SESSION_RUNNING

    command = args[1]
    if command == "save":
        boss.on_desktop_session_state_changed(DESKTOP_SESSION_QUERY_END)
        if not boss.snapshot_saved_for_logout:
            raise RuntimeError("Kitty did not create a logout snapshot")
        return boss.snapshot_saved_for_logout
    if command == "cancel":
        boss.on_desktop_session_state_changed(DESKTOP_SESSION_RUNNING)
        return True
    raise ValueError(f"Unknown session operation: {command}")
