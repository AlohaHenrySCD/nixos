# Kitty

Kitty 0.50.0 · Linux

A **pane** is a terminal inside a tab; an **OS window** is a separate desktop window. `→` means release the prefix, then press the next key.

## On this page

| Task | 用途检索 |
| --- | --- |
| [Copy and paste](#copy-and-paste) | 复制粘贴 |
| [Review terminal output](#review-terminal-output) | 滚屏、上一条输出 |
| [Tools and sessions](#tools-and-sessions) | 帮助、会话 |
| [Panes and layout](#panes-and-layout) | 分屏、布局 |
| [Tabs](#tabs) | 标签页 |
| [Appearance](#appearance) | 字体、外观 |
| [Links, paths and visible text](#links-paths-and-visible-text) | 链接、路径 |
| [Quick workflows](#quick-workflows) | 组合用法 |
| [Mouse selection](#mouse-selection) | 鼠标选区 |

## Copy and paste

| Shortcut | Use |
| --- | --- |
| `Ctrl+Shift+c` | Copy to clipboard |
| `Ctrl+Shift+v` | Paste from clipboard |
| `Ctrl+Shift+s` / `Shift+Insert` | Paste from selection |
| `Ctrl+Shift+o` | Pass selection to program |

## Review terminal output

| Shortcut | Use |
| --- | --- |
| `Ctrl+Shift+Up` / `Ctrl+Shift+k`; `Ctrl+Shift+Down` / `Ctrl+Shift+j` | Scroll line up / down |
| `Ctrl+Shift+PageUp`; `Ctrl+Shift+PageDown` | Scroll page up / down |
| `Ctrl+Shift+Home`; `Ctrl+Shift+End` | Scroll to top / bottom |
| `Ctrl+Shift+z`; `Ctrl+Shift+x` | Jump to the previous / next shell prompt |
| `Ctrl+Shift+h` / `Alt+r` | Open scrollback in the configured Mitos pager |
| `Ctrl+Shift+g` | Show last command output |
| `Ctrl+Shift+u`; `Ctrl+Shift+d` | Scroll terminal history up / down half a page |

## Tools and sessions

| Shortcut | Use |
| --- | --- |
| `Ctrl+Shift+Enter` / `Ctrl+Shift+q` | Disabled; no action |
| `Ctrl+Shift+F1` | Show documentation |
| `Ctrl+Shift+F3` | Command palette |
| `Ctrl+Shift+F2` | Edit config file |
| `Ctrl+Shift+Delete` | Reset the terminal |
| `Ctrl+Shift+F5` | Save a native logout snapshot of this Kitty instance |
| `Ctrl+Shift+F6` | Debug kitty configuration |
| `Esc` | Send Esc and deactivate Fcitx5 |

**Restore after logout:** start Kitty normally to restore the saved layout and scrollback once. Programs other than shells are not restarted. `Ctrl+Shift+F5` saves this instance; Niri’s logout menu saves all instances.

## Panes and layout

| Shortcut | Use |
| --- | --- |
| `Ctrl+Shift+n` | Open a separate desktop terminal window |
| `Ctrl+Shift+w` | Close the focused terminal pane |
| `Ctrl+Shift+[`; `Ctrl+Shift+]` | Focus the previous / next pane |
| `Ctrl+Shift+b`; `Ctrl+Shift+f` | Move the pane backward / forward in the layout |
| `` Ctrl+Shift+` `` | Move the pane to the first position |
| `Ctrl+Shift+r` | Resize the focused pane |
| `Ctrl+Shift+1…9`; `Ctrl+Shift+0` | Focus pane 1–9; 0 selects pane 10 |
| `Ctrl+Shift+F7` | Show pane labels and choose which pane to focus |
| `Ctrl+Shift+F8` | Show pane labels and choose a pane to swap with |
| `Ctrl+Shift+l` | Next layout |
| `Ctrl+Shift+Esc` | Open the kitty command shell |

## Tabs

| Shortcut | Use |
| --- | --- |
| `Ctrl+Shift+Left` / `Ctrl+Shift+Tab`; `Ctrl+Shift+Right` / `Ctrl+Tab` | Previous / next tab |
| `Ctrl+Shift+t` | New tab |
| `Ctrl+Shift+,`; `Ctrl+Shift+.` | Move tab backward / forward |
| `Ctrl+Shift+Alt+t` | Set tab title |

## Appearance

| Shortcut | Use |
| --- | --- |
| `Ctrl+Shift+=` / `Ctrl+Shift++` / `Ctrl+Shift+kp_add`; `Ctrl+Shift+-` / `Ctrl+Shift+kp_subtract` | Increase / decrease font size |
| `Ctrl+Shift+Backspace` | Reset font size |
| `Ctrl+Shift+F11` | Toggle fullscreen |
| `Ctrl+Shift+F10` | Toggle maximized |
| `Ctrl+Shift+a → m`; `Ctrl+Shift+a → l` | Increase / decrease opacity by 0.1 |
| `Ctrl+Shift+a → 1`; `Ctrl+Shift+a → d` | Set full / default opacity |

## Links, paths and visible text

| Shortcut | Use |
| --- | --- |
| `Ctrl+Shift+e` | Label visible URLs; type a label to open its link |
| `Ctrl+Shift+p → f` | Choose a visible path and insert it at the prompt |
| `Ctrl+Shift+p → Shift+f` | Choose a visible path and open it with its default application |
| `Ctrl+Shift+p → c`; `Ctrl+Shift+p → d` | Choose a file / directory and insert its path |
| `Ctrl+Shift+p → l` | Choose a visible line and insert it at the prompt |
| `Ctrl+Shift+p → w` | Choose a visible word and insert it at the prompt |
| `Ctrl+Shift+p → h` | Choose a visible hash and insert it at the prompt |
| `Ctrl+Shift+p → n` | Choose a file:line reference to open in the editor |
| `Ctrl+Shift+p → y` | Choose and open an embedded hyperlink |

## Quick workflows

| Shortcut | Use |
| --- | --- |
| `Ctrl+Shift+T → Ctrl+Shift+Alt+T` | Create and name a tab |
| `Ctrl+Tab / Ctrl+Shift+Tab` | Switch tabs |
| `Ctrl+Shift+F3 → new window` | Create a pane through the command palette; Ctrl+Shift+Enter is disabled |
| `Ctrl+Shift+L → Ctrl+Shift+]` | Choose layout, then focus the next pane |
| `Ctrl+Shift+Z/X → Alt+R` | Jump between prompts, then inspect scrollback in Mitos |
| `Ctrl+Shift+P → f → hint` | Insert a path shown in terminal output |
| `Ctrl+Shift+E → hint` | Open a URL shown in terminal output |
| `Ctrl+Shift+R` | Resize; use the on-screen keys. 1/2 selects strategy, M modifier, F fraction, R resets |
| `Ctrl+Shift+F5` | Save this instance; Niri logout saves all instances |

For log files and live output, see [ov](ov.md).

`Ctrl+Shift+Q` and `Ctrl+Shift+Enter` are disabled. `Ctrl+Shift+U` scrolls rather than opening Unicode input; `Ctrl+Shift+F5` saves rather than reloading settings. Other actions remain available in the command palette. Opacity controls need dynamic opacity enabled, which this configuration does not enable.


## Mouse selection

| Shortcut | Use |
| --- | --- |
| Left drag | Select text |
| Left click | Follow a link, or place the cursor at the shell prompt; an existing selection takes precedence |
| Ctrl+Shift+Left click | Open the link directly |
| Left double click | Select a word |
| Left triple click | Select a line |
| Alt+Left triple click | Select from line beginning |
| Ctrl+Alt+Left triple click | Select from the clicked point to line end |
| Ctrl+Alt+Left drag | Rectangular selection |
| Right press / Shift+Left press | Extend the selection |
| Middle click | Paste primary selection |
| Ctrl+Shift+Right press | Show output of the command under the pointer |

When an application captures the mouse, add Shift to use Kitty selection/paste. Shift+Left click can still follow a link or position the shell cursor.

---

[Configuration](../home/modules/common/kitty.nix) · [Linux sessions](../home/modules/linux/kitty-session.nix) · [Kitty reference](https://sw.kovidgoyal.net/kitty/conf/) · Checked 2026-11-15 · [Index](shortcuts.md) · [Find by task](task-index.md)
