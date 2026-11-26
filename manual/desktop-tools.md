# Desktop helpers

Search words: launcher, notifications, tray, Wi-Fi, Bluetooth, volume, dictionary / 启动器、通知、托盘、网络、音量、词典。

## On this page

[Launch applications — Fuzzel](#launch-applications--fuzzel) · [Use the top bar — Waybar](#use-the-top-bar--waybar) · [Read and recover notifications — Mako](#read-and-recover-notifications--mako) · [Look up a word — GoldenDict](#look-up-a-word--goldendict)

## Launch applications — Fuzzel

Open with **Mod+D**. Fuzzel 1.15.0 lists desktop applications; executable names from PATH are not listed by default. Helix, btop and Yazi are deliberately hidden from the application list; run `hx`, `btop` or `y` in Kitty. Bazecor has a configured launcher entry.

| Shortcut | Use |
| --- | --- |
| Type an application name | Filter results |
| Enter / keypad Enter / Ctrl+Y | Launch selected entry |
| Tab | Next result; **launch immediately when only one result remains** |
| Shift+Tab | Previous result, wrapping around |
| Up / Ctrl+P; Down / Ctrl+N | Previous / next result without wrapping |
| PageUp / PageDown, keypad equivalents | Previous / next page |
| Ctrl+Home / Ctrl+End | First / last result |
| Esc / Ctrl+C / Ctrl+G / Ctrl+[ | Close without launching |
| Shift+Enter / Shift+keypad Enter | Run the typed input directly in app-launcher mode |
| Ctrl+Tab | Put the selected entry's launch text into the input |
| Shift+Delete | Remove the entry from launch-frequency history |
| Alt+1…9 | Alternative acceptance for menu callers; use Enter for normal launching |

### Edit launcher input

| Shortcut | Use |
| --- | --- |
| Left / Ctrl+B; Right / Ctrl+F | Move one character |
| Ctrl+Left / Alt+B; Ctrl+Right / Alt+F | Move one word |
| Home / Ctrl+A; End / Ctrl+E | Start / end of input |
| Ctrl+U / Ctrl+K | Delete before / after cursor |
| Ctrl+Shift+Backspace | Clear all input |
| Backspace / Ctrl+H | Delete previous character |
| Alt+Backspace / Ctrl+Backspace / Ctrl+W | Delete previous word |
| Delete / Ctrl+Delete / Alt+D | Delete next character / word / word |
| Ctrl+V / dedicated Paste key | Paste clipboard |
| Shift+Insert / Shift+keypad Insert / middle-click | Paste primary selection |

**Launch and return:** `Mod+D → app name → Enter`. For the logout menu, use [Niri's session keys](niri.md#screenshots-and-session); choose Cancel or Save Kitty and log out.

## Use the top bar — Waybar

| Target and gesture | Use |
| --- | --- |
| Window tile: left-click | Focus that window; middle/right clicks have no configured action |
| System icon: click | Reveal disk, memory and CPU indicators |
| Disk / memory / CPU: click | Open btop in Kitty |
| Tray arrow: hover | Reveal app tray icons |
| EN / 中 / あ: click | Toggle Fcitx5 |
| EN / 中 / あ: right-click | Open input-method settings |
| Clipboard: left-click or `Mod+Y` | Select a saved text or image entry in Fuzzel to copy it again, then paste in the destination app |
| Clipboard: right-click | Choose **删除单条记录** to delete one entry, or **清空全部历史** → **确认清空** to clear cliphist |
| Wi-Fi: click | Open nmtui in Kitty |
| Wi-Fi: right-click | Open graphical connection editor |
| Bluetooth: click | Open Bluetooth manager |
| App volume: hover | See the target and all playback streams. Auto follows focus, then falls back to a running stream or the newest available stream |
| App volume: click | Pin a playback stream or resume following focus |
| App volume: wheel / right-click | Adjust the target in 2% steps / toggle its mute |
| App volume: middle-click or Volume: click | Toggle floating wiremix (Playback tab; closes on blur) |
| Volume: middle-click | Open full audio settings in pavucontrol |
| Volume: right-click | Mute/unmute output |
| Volume: wheel | Adjust in 2% steps |
| Clock: hover | Show calendar |
| Network, battery, media title: hover | Show connection, battery or track details |

**Fix the wrong audio device:** middle-click Volume → select the desired output in pavucontrol. **Connect Wi-Fi:** click Wi-Fi → choose Activate a connection in nmtui; arrows/Tab move, Enter selects, Esc goes back.

## Read and recover notifications — Mako

Mako 1.11.0 · Notifications appear at top-right, up to five visible. Default timeout is five seconds; an application's supplied timeout is respected.

| Gesture / entry | Use |
| --- | --- |
| Left-click a notification | Invoke its default action, if supplied |
| Right-click / touch a notification | Dismiss it |
| Middle-click | No default action |
| `makoctl list` | Read visible notifications |
| `makoctl history` | Read notification history |
| `makoctl restore` | Restore the most recently expired/dismissed notification |
| `makoctl dismiss` | Dismiss the last notification |
| `makoctl dismiss -a` | Dismiss all |
| `makoctl dismiss -g` | Dismiss the last notification's group |
| `makoctl invoke` | Invoke the last notification's default action |
| `makoctl menu fuzzel --dmenu` | Choose an action on the last notification |

No global notification-dismiss shortcut is configured. Use the commands or pointer gestures above.

## Look up a word — GoldenDict

| Entry | Use |
| --- | --- |
| Select text → Mod+Ctrl+D | Look it up in GoldenDict |
| Copy text → Mod+Ctrl+D | Clipboard fallback when primary selection is empty |
| `goldendict -- 'word'` | Look up an explicit word |

An older primary selection takes precedence over newer clipboard text. For a precise lookup, select the intended word again or use the explicit command. The configured dictionary is ECDICT.


---

[Bar controls](../home/modules/linux/bar.nix) · [App volume helper](../home/modules/linux/waybar-app-audio.py) · [Notification settings](../home/linux.nix) · [Dictionary](../home/modules/linux/goldendict.nix) · [Launchers](../home/modules/linux/packages.nix) · defaults checked with installed `man fuzzel.ini`, `man mako`, `man makoctl` · Checked 2026-11-15 · [Index](shortcuts.md) · [Find by task](task-index.md)
