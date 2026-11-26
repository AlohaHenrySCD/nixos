# fzf — choose from a list

fzf 0.75.0 · Search words: fuzzy, chooser, picker, filter / 模糊查找、选择、筛选。

## On this page

[Start a search](#start-a-search) · [Match exactly what you want](#match-exactly-what-you-want) · [Choose results](#choose-results) · [Edit the query](#edit-the-query)

[Useful sequences](#useful-sequences)

## Start a search

| Entry | Use |
| --- | --- |
| Fish `Ctrl+R` | Search the shell history and recall a command |
| Fish `Ctrl+T` / `Alt+C` | Insert selected paths / change to the selected directory |
| `fzf` | Find a file below the current directory |
| `rg --files \| fzf` | Choose from ripgrep's file list |
| `fd -t d \| fzf` | Choose a directory |
| `command \| fzf` | Filter any list of lines |
| `fzf --multi` | Allow selection of several entries |
| `fzf --preview 'bat --color=always -- {}'` | Preview the file under the cursor |

Choosing normally prints the selected line; it does not automatically open it. The program that launched fzf may use the result.

## Match exactly what you want

| Query | Match |
| --- | --- |
| `term` | Fuzzy match |
| `foo bar` | Both terms |
| `'term` | Exact substring |
| `^term` | Starts with term |
| `term$` | Ends with term |
| `!term` | Exclude term |
| `^start end$` | Starts and ends with these terms |
| `foo \| bar` | Either term |

## Choose results

| Shortcut | Use |
| --- | --- |
| Up / Down, Ctrl+K / Ctrl+J | Move through rows |
| Ctrl+P / Ctrl+N, Alt+Up / Alt+Down | Previous / next matching row; with `--history`, Ctrl+P/N browse query history |
| PageUp / PageDown | Page through results |
| Enter / double-click | Accept |
| Esc / Ctrl+C / Ctrl+G / Ctrl+Q | Cancel |
| Tab / Ctrl+I | Toggle selection and move down; multi-selection needs `--multi` |
| Shift+Tab | Toggle selection and move up |
| Right-click | Toggle selection |
| Shift+Up / Shift+Down | Scroll the preview, when enabled |
| Ctrl+/ / Alt+/ | Toggle word wrapping |
| Ctrl+L | Redraw |

## Edit the query

| Shortcut | Use |
| --- | --- |
| Left / Ctrl+B; Right / Ctrl+F | Move one character |
| Alt+B / Shift+Left / Alt+Left | Move back a word |
| Alt+F / Shift+Right / Alt+Right | Move forward a word |
| Home / Ctrl+A; End / Ctrl+E | Start / end of query |
| Backspace / Ctrl+H / Ctrl+Backspace | Delete previous character |
| Delete | Delete at cursor |
| Ctrl+D | Delete at cursor; abort if query is empty |
| Alt+Backspace; Alt+D | Delete previous / next word |
| Ctrl+U | Delete to query start |
| Ctrl+W | Delete previous whitespace-separated word |
| Ctrl+Y | Restore killed text |

## Useful sequences

| Task | Sequence |
| --- | --- |
| Find this manual | `rg --files /etc/nixos/manual \| fzf` → type `kitty` |
| Exclude a directory | Type the desired term followed by `!node_modules` |
| Choose several files | Start with `--multi` → type → Tab on each result → Enter |
| Find a command snippet | Use [navi](utilities.md#command-examples) and these same picker controls |


---

Sources: installed `man fzf` (default keys and extended-search sections); [Fish integration](../home/modules/common/fish.nix) · Checked 2026-11-15 · [Index](shortcuts.md) · [Find by task](task-index.md)
