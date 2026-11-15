# ov — read logs and long output

ov 0.55.0 · Search words: pager, scroll, log, filter, wrap / 日志、翻页、过滤、换行。

| Entry | Use |
| --- | --- |
| `ov FILE` | Read a file |
| `command \| ov` | Browse command output |
| `ove command` in Fish | Expand to `ov --exec -- command` |
| `ov -f FILE` | Follow a growing log |
| `ov -H 1 -c -d ',' FILE` | Keep one header line and read comma-separated columns |

Arrows move through text. Unlike many pagers, **h opens help**, while **j sets the jump target**.

## On this page

[Open, leave and follow output](#open-leave-and-follow-output) · [Move through output](#move-through-output) · [Use sidebars](#use-sidebars) · [Switch documents](#switch-documents)

[Mark and revisit lines](#mark-and-revisit-lines) · [Find and filter](#find-and-filter) · [Change wrapping and display](#change-wrapping-and-display) · [Set columns, headers and highlighting](#set-columns-headers-and-highlighting)

[Read columns](#read-columns) · [Navigate sections](#navigate-sections) · [Reload and watch files](#reload-and-watch-files) · [Edit a search or filter](#edit-a-search-or-filter)

[Useful sequences](#useful-sequences)

## Open, leave and follow output

| Shortcut | Use |
| --- | --- |
| `Escape` / `q` | Quit |
| `Ctrl+c` | Cancel |
| `Q` | Output screen and quit |
| `Ctrl+q` | Set before/after range for output and quit |
| `Alt+Shift+F8` | Toggle writing original content (instead of current screen) on exit |
| `Ctrl+z` | Suspend |
| `Alt+v` | Edit current document |
| `h` / `Ctrl+F1` / `Ctrl+Alt+c` | Display help screen |
| `Ctrl+F2` / `Ctrl+Alt+e` | Display log screen |
| `Ctrl+l` | Redraw the screen |
| `Ctrl+f` | Follow mode toggle |
| `Ctrl+a` | Follow all mode toggle |
| `Ctrl+F8` / `Ctrl+Alt+r` | Enable/disable mouse |
| `S` | Save buffer to file |

## Move through output

| Shortcut | Use |
| --- | --- |
| `Up` / `Ctrl+p`; `Enter` / `Down` / `Ctrl+n` | Backward / forward by one line |
| `Home`; `End` | Document start / end |
| `PageUp` / `Ctrl+b`; `PageDown` / `Ctrl+v` | Backward / forward by page |
| `Ctrl+u`; `Ctrl+d` | Backward / forward a half page |
| `Left`; `Right` | Scroll left / right |
| `Ctrl+Left`; `Ctrl+Right` | Scroll left / right half screen |
| `Alt+Left`; `Alt+Right` | Scroll left / right specified width |
| `Shift+Home`; `Shift+End` | Go to beginning / end of line |
| `g` | Go to line (number, `.n`, or `n%`) |
| `,` | Go to mark number |

## Use sidebars

| Shortcut | Use |
| --- | --- |
| `Alt+h` | Toggle help in sidebar |
| `Alt+m` | Toggle mark list in sidebar |
| `Alt+l` | Toggle document list in sidebar |
| `Alt+u` | Toggle section list in sidebar |
| `Alt+y` | Toggle style usage list in sidebar |
| `Shift+Up`; `Shift+Down`; `Shift+Left`; `Shift+Right` | Scroll sidebar up / down / left / right |

## Switch documents

| Shortcut | Use |
| --- | --- |
| `[`; `]` | Previous / next document |
| `Ctrl+k` | Close current document |
| `K` | Close all filtered documents |

## Mark and revisit lines

| Shortcut | Use |
| --- | --- |
| `m` | Mark current position |
| `M` | Remove mark at current position |
| `Ctrl+Delete` | Remove all marks |
| `<`; `>` | Move to previous / next marked position |
| `*` | Mark all lines matching a pattern |

## Find and filter

| Shortcut | Use |
| --- | --- |
| `?`; `/` | Backward / forward search mode |
| `N`; `n` | Repeat backward / forward search |
| `&` | Filter lines by pattern |

## Change wrapping and display

| Shortcut | Use |
| --- | --- |
| `w` / `W` | Wrap toggle (character based) |
| `Alt+w` | Word wrap toggle |
| `c` | Column mode toggle |
| `Alt+o` | Column width toggle |
| `Ctrl+r` | Column rainbow toggle |
| `C` | Toggle alternating row highlight |
| `G` | Line number toggle |
| `Ctrl+e` | Toggle plain mode (strip ansi styles) |
| `Alt+f` | Align columns |
| `Alt+r` | Toggle raw output mode |
| `Alt+Shift+F9` | Ruler toggle |
| `Ctrl+Alt+u` | Unhighlight search results until the next search |
| `Ctrl+F10` | Status line toggle |
| `o` | Suppress style highlight by number |

## Set columns, headers and highlighting

| Shortcut | Use |
| --- | --- |
| `p` / `P` | View mode selection |
| `d` | Column delimiter string |
| `H` | Number of header lines |
| `Ctrl+s` | Number of skip lines |
| `t` | Tab width |
| `Ctrl+Alt+n` | Indent width for wrapped lines |
| `Ctrl+Alt+m` | Display marker bitmask |
| `.` | Highlight words in distinct colors |
| `j` | Jump target (`.n`, `n%`, or `section`) |
| `Alt+t` | Select content processing mode |
| `y` | Number of vertical header characters |
| `Y` | Number of header columns |

## Read columns

| Shortcut | Use |
| --- | --- |
| `F` | Toggle fixed header column |
| `s` | Shrink column toggle (align mode only) |
| `Alt+a` | Right align column toggle (align mode only) |

## Navigate sections

| Shortcut | Use |
| --- | --- |
| `Alt+d` | Section delimiter regular expression |
| `Ctrl+F3` / `Alt+s` | Section start position |
| `^`; `Space` | Previous / next section |
| `9` | Last section |
| `F2` | Toggle follow-section mode |
| `F7` | Number of section header lines |
| `Alt+-` | Hide "other" section toggle |

## Reload and watch files

| Shortcut | Use |
| --- | --- |
| `Ctrl+F9` / `Ctrl+Alt+s` | Close file |
| `F5` / `Ctrl+Alt+l` | Reload file |
| `F4` / `Ctrl+Alt+w` | Toggle watch mode |
| `Ctrl+w` | Set watch interval |

## Edit a search or filter

| Shortcut | Use |
| --- | --- |
| `Alt+c` | Case-sensitive toggle |
| `Alt+s` | Smart case-sensitive toggle |
| `Alt+r` | Regular expression search toggle |
| `Alt+i` | Incremental search toggle |
| `!` | Toggle non-match filter |
| `Up`; `Down` | Previous / next candidate |
| `Ctrl+c` | Copy to clipboard |
| `Ctrl+v` | Paste from clipboard |

## Useful sequences

| Task | Sequence |
| --- | --- |
| Find an error | `/ → error → Enter → n / N` |
| Keep only matching lines | `& → pattern → Enter`; `!` while entering the filter inverts matching |
| Stop chasing new output | `Ctrl+f`, inspect older lines, then `Ctrl+f` to follow again |
| Revisit several locations | `m` at each location → `>` / `<` |
| Read a wide table | `c → d → delimiter → Enter`, then Left/Right |
| Compare files | `ov first.log second.log` → `]` / `[` |

Kitty intercepts **Alt+r** (scrollback); Niri intercepts **F2** (screenshot). Other ov keys remain distinct from [Kitty's terminal scrolling](kitty.md#review-terminal-output).

---

Source: installed `ov --help-key` and `ov --help`; [Fish abbreviation](../home/modules/common/fish.nix) · Checked 2026-11-15 · [Index](shortcuts.md) · [Find by task](task-index.md)
