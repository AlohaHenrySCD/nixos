# Niri

`Mod` = Super. `J K L ;` = left/down/up/right. On the internal keyboard hold `s` or `l` for Super; physical Left Meta is Esc. See [keyd](keyd.md) for physical keys.

## On this page

| Task | 用途检索 |
| --- | --- |
| [Open apps and find help](#open-apps-and-find-help) | 启动应用、剪贴板历史、帮助 |
| [Screenshots and session](#screenshots-and-session) | 截图、锁屏、注销 |
| [Arrange and resize](#arrange-and-resize) | 布局、宽高 |
| [Focus and move windows](#focus-and-move-windows) | 聚焦、移动窗口 |
| [Audio and brightness](#audio-and-brightness) | 音量、亮度 |
| [Workspaces and monitors](#workspaces-and-monitors) | 工作区、显示器 |
| [Useful sequences](#useful-sequences) | 组合用法 |

## Open apps and find help

| Shortcut | Use |
| --- | --- |
| `Mod+Shift+/` | Show Niri's shortcut overlay |
| `Mod+T` | Launch Kitty |
| `Mod+D` | Launch Fuzzel |
| `Mod+Y` | Open clipboard history in Fuzzel and copy a saved text or image entry from cliphist |
| `Mod+Ctrl+D` | Look up primary selected text in GoldenDict; fall back to clipboard text |
| `Mod+B` | Launch Chromium |
| `Mod+G` | Launch Kazumi |

## Screenshots and session

| Shortcut | Use |
| --- | --- |
| `Super+Alt+L` | Lock with swaylock |
| `Super+Alt+S` | Toggle Orca |
| `F2`, `F1` | Screenshot selector / screen screenshot |
| `Mod+Escape` | Toggle application inhibition of Niri shortcuts; this shortcut still works while inhibition is active |
| `Mod+Shift+E`, `Ctrl+Alt+Delete` | Open the confirmation menu to save Kitty sessions and log out |
| `Mod+Shift+P` | Power off monitors; input wakes them |

Screenshots are saved under `~/Pictures/Screenshots/` as `Screenshot from YYYY-MM-DD HH-MM-SS.png`.

## Arrange and resize

| Shortcut | Use |
| --- | --- |
| `Mod+O` | Toggle overview |
| `Mod+.` | Expel the bottom window into a column to the right |
| `Mod+R` / `Mod+Shift+R` | Next / previous preset column width |
| `Mod+Ctrl+Shift+R` | Cycle preset window heights |
| `Mod+Ctrl+R` | Reset window height |
| `Mod+F` | Maximize column |
| `Mod+Shift+F` | Toggle window fullscreen |
| `Mod+M` | Maximize window to screen edges |
| `Mod+Ctrl+F` | Expand column into available width |
| `Mod+Ctrl+C` | Center visible columns |
| `Mod+-` / `Mod+=` | Decrease / increase column width by 10 percentage points |
| `Mod+Shift+-` / `Mod+Shift+=` | Decrease / increase window height by 10 percentage points |
| `Mod+W` | Toggle tabbed display for the column |

## Focus and move windows

| Shortcut | Use |
| --- | --- |
| `Mod+Q` | Close the focused window |
| `Mod+Shift+Q` | Quit the focused application ; may bypass save prompts |
| `Mod+J` / `Mod+;` | Focus the column left / right |
| `Mod+Ctrl+J` / `Mod+Ctrl+;` | Move column left / right |
| `Mod+Home` / `Mod+End` | Focus first / last column |
| `Mod+Ctrl+Home` / `Mod+Ctrl+End` | Move column to first / last position |
| `Mod+wheel right/left` / `Mod+Shift+wheel down/up` | Focus column right / left |
| `Mod+Ctrl+wheel right/left` / `Mod+Ctrl+Shift+wheel down/up` | Move column right / left |
| `Mod+[` / `Mod+]` | Consume or expel the focused window toward the left / right column |
| `Mod+,` | Consume a window from the right into the focused column |
| `Mod+C` | Center focused column |
| `Mod+V` | Toggle focused window between floating and tiling |
| `Mod+Shift+V` | Switch focus between floating and tiling |

## Audio and brightness

| Shortcut | Use |
| --- | --- |
| Volume up / down | Adjust default output by 10%; raising is capped at 100% |
| Brightness up / down | Adjust brightness by 5 |
| Audio mute / microphone mute | Toggle default output / input mute |
| Media play / stop / previous / next | Control playback through playerctl |

## Workspaces and monitors

| Shortcut | Use |
| --- | --- |
| `Mod+K` / `Mod+L` | Focus window down / up, crossing to the adjacent workspace at the boundary |
| `Mod+Ctrl+K` / `Mod+Ctrl+L` | Move window down / up, crossing workspace at the boundary |
| `Mod+Shift+J/K/L/;` | Focus monitor in that direction |
| `Mod+Ctrl+Shift+J/K/L/;` | Move column to monitor in that direction |
| `Mod+Shift+U` / `Mod+Shift+I` | Move the workspace down / up |
| `Mod+1…9` | Focus workspace 1–9 |
| `Mod+Ctrl+1…9` | Move column to workspace 1–9 |
| `Mod+wheel down/up` | Focus workspace down / up |
| `Mod+Ctrl+wheel down/up` | Move column to workspace down / up |

For launcher input, bar clicks, notification recovery and dictionary lookup, see [desktop helpers](desktop-tools.md).

## Useful sequences

| Shortcut | Use |
| --- | --- |
| `Mod+T` twice → `Mod+R → Mod+C` | Open two terminals, choose width, center the focused column |
| `Mod+, → Mod+W` | Bring a window from the right into the column and show it as tabs |
| `Mod+Ctrl+3 → Mod+3` | Move the column to workspace 3, then follow it |
| `Mod+V → Mod+Shift+V` | Float a window, then switch focus between floating and tiled windows |
| `select text → Mod+Ctrl+D` | Look up in GoldenDict; clipboard is used only if primary selection is empty |
| `Mod+Shift+E → Save Kitty and log out` | Save terminal sessions and confirm logout |

Media/brightness keys and Orca work while locked. Logout opens a confirmation menu; Cancel is the default.

---

[Configuration](../home/niri.kdl) · [Logout helper](../home/modules/linux/kitty-session.py) · Checked 2026-11-15 · [Index](shortcuts.md) · [Find by task](task-index.md)
