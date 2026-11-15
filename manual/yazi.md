# Yazi

Yazi 26.9.1 · Default layout. `h j k l` = parent/down/up/enter; these are **not** the Helix directions. C/A/S in key labels mean Ctrl/Alt/Shift.

## On this page

[Select files](#select-files) · [Open, copy and manage files](#open-copy-and-manage-files) · [Tabs](#tabs) · [Move through directories](#move-through-directories)

[Preview and inspect](#preview-and-inspect) · [Change listing and sorting](#change-listing-and-sorting) · [Find files](#find-files) · [Manage running tasks](#manage-running-tasks)

[Inspect file details](#inspect-file-details) · [Choose an opener](#choose-an-opener) · [Edit names and paths](#edit-names-and-paths) · [Confirm an operation](#confirm-an-operation)

[Complete names](#complete-names) · [Find help](#find-help) · [Useful sequences](#useful-sequences)

## Select files

| Shortcut | Use |
| --- | --- |
| `<Esc>` / `<C-[>` | Exit visual mode, clear selection, or cancel search |
| `<Space>` | Toggle the current selection state |
| `<C-a>` | Select all files |
| `<C-r>` | Invert selection of all files |
| `v` | Enter visual mode (selection mode) |
| `V` | Enter visual mode (unset mode) |
| `<C-s>` | Cancel the ongoing search |

## Open, copy and manage files

| Shortcut | Use |
| --- | --- |
| `q` | Quit the process |
| `Q` | Quit without outputting cwd-file |
| `<C-z>` | Suspend the process |
| `o` / `<Enter>` | Open selected files |
| `O` / `<S-Enter>` | Open selected files interactively |
| `y` | Yank selected files (copy) |
| `x` | Yank selected files (cut) |
| `p` | Paste yanked files |
| `P` | Paste yanked files (overwrite if the destination exists) |
| `-`; `_` | Create absolute / relative symlinks to copied files |
| `<C-->` | Hardlink yanked files |
| `Y` / `X` | Cancel the yank status |
| `d` | Trash selected files |
| `D` | Permanently delete selected files |
| `a` | Create a file (ends with / for directories) |
| `A` | Bulk create files |
| `r` | Rename selected file(s) |
| `;` | Run a shell command |
| `:` | Run a shell command (block until finishes) |
| `c → c`; `c → C` | Copy file path / URL |
| `c → d`; `c → D` | Copy directory path / URL |
| `c → f`; `c → n` | Copy filename with / without extension |
| `g → t` | Go to trash bin |
| `g → f` | Follow hovered symlink |
| `w` | Show task manager |
| `~` / `<F1>` | Open help |

## Tabs

| Shortcut | Use |
| --- | --- |
| `<C-c>` | Close the current tab, or quit if it's last |
| `t → t` | Create a new tab in CWD |
| `t → r` | Rename current tab |
| `1…9` | Switch to tab 1–9 |
| `[`; `]` | Switch to previous / next tab |
| `{`; `}` | Swap current tab with previous / next tab |

## Move through directories

| Shortcut | Use |
| --- | --- |
| `k` / `<Up>`; `j` / `<Down>` | Previous / next file |
| `g → g` / `<Home>`; `G` / `<End>` | Go to top / bottom |
| `<C-u>` / `<S-PageUp>`; `<C-d>` / `<S-PageDown>` | Move cursor up / down half page |
| `<C-b>` / `<PageUp>`; `<C-f>` / `<PageDown>` | Move cursor up / down one page |
| `h` / `<Left>`; `l` / `<Right>` | Parent / child directory |
| `H`; `L` | Back / forward in directory history |
| `g → h` | Go home |
| `g → c` | Go to ~/.config |
| `g → d` | Go to ~/Downloads |
| `g → <Space>` | Jump interactively |

## Preview and inspect

| Shortcut | Use |
| --- | --- |
| `K`; `J` | Seek up / down 5 units in the preview |
| `<Tab>` | Spot hovered file |

## Change listing and sorting

| Shortcut | Use |
| --- | --- |
| `.` | Toggle the visibility of hidden files |
| `m → s` | Linemode: size |
| `m → p` | Linemode: permissions |
| `m → b` | Linemode: btime |
| `m → m` | Linemode: mtime |
| `m → o` | Linemode: owner |
| `m → n` | Linemode: none |
| `, → m`; `, → M` | Sort by modified time: normal / reverse |
| `, → b`; `, → B` | Sort by birth time: normal / reverse |
| `, → e`; `, → E` | Sort by extension: normal / reverse |
| `, → a`; `, → A` | Sort alphabetically: normal / reverse |
| `, → n`; `, → N` | Sort naturally: normal / reverse |
| `, → s`; `, → S` | Sort by size: normal / reverse |
| `, → r` | Sort randomly |

## Find files

| Shortcut | Use |
| --- | --- |
| `s` | Search files by name via fd |
| `S` | Search files by content via ripgrep |
| `z` | Jump to a file/directory via fzf |
| `Z` | Jump to a directory via zoxide |
| `f` | Filter files |
| `?`; `/` | Find previous / next file |
| `N`; `n` | Previous / next found |

## Manage running tasks

| Shortcut | Use |
| --- | --- |
| `<Esc>` / `<C-[>` / `<C-c>` / `w` | Close task manager |
| `k` / `<Up>`; `j` / `<Down>` | Previous / next task |
| `<Enter>` | Inspect the task |
| `x` | Cancel the task |
| `~` / `<F1>` | Open help |

## Inspect file details

| Shortcut | Use |
| --- | --- |
| `<Esc>` / `<C-[>` / `<C-c>` / `<Tab>` | Close the spot |
| `k` / `<Up>`; `j` / `<Down>` | Previous / next line |
| `h` / `<Left>`; `l` / `<Right>` | Swipe to previous / next file |
| `c → c` | Copy selected cell |
| `~` / `<F1>` | Open help |

## Choose an opener

| Shortcut | Use |
| --- | --- |
| `<Esc>` / `<C-[>` / `<C-c>` | Cancel pick |
| `<Enter>` | Submit the pick |
| `k` / `<Up>`; `j` / `<Down>` | Previous / next option |
| `~` / `<F1>` | Open help |

## Edit names and paths

| Shortcut | Use |
| --- | --- |
| `<C-c>` | Cancel input |
| `<Enter>` | Submit input |
| `<Esc>` / `<C-[>` | Back to normal mode, or cancel input |
| `i` | Enter insert mode |
| `I`; `A` | Insert at line start / end |
| `a` | Enter append mode |
| `v` | Enter visual mode |
| `r` | Replace a single character |
| `V` / `<C-E>` | Select from BOL to EOL |
| `<C-A>` | Select from EOL to BOL |
| `h` / `<Left>` / `<C-b>`; `l` / `<Right>` / `<C-f>` | Move left / right one character |
| `b` / `<A-b>` / `<C-Left>` | Move back to the start of the current or previous word |
| `B` | Move back to the start of the current or previous WORD |
| `w` | Move forward to the start of the next word |
| `W` | Move forward to the start of the next WORD |
| `e` / `<A-f>` / `<C-Right>` | Move forward to the end of the current or next word |
| `E` | Move forward to the end of the current or next WORD |
| `0` / `<C-a>` / `<Home>`; `$` / `<C-e>` / `<End>` | Line start / end |
| `_` / `^` | Move to the first non-whitespace character |
| `<Backspace>` / `<C-h>`; `<Delete>` / `<C-d>` | Delete character before / at cursor |
| `<C-u>`; `<C-k>` | Delete to line start / end |
| `<C-w>` / `<C-Backspace>`; `<A-d>` / `<C-Delete>` | Delete to word start / end |
| `d` | Cut selected characters |
| `D` | Cut until EOL |
| `c` | Cut selected characters, and enter insert mode |
| `C` | Cut until EOL, and enter insert mode |
| `s` | Cut current character, and enter insert mode |
| `S` | Cut from BOL until EOL, and enter insert mode |
| `x` | Cut current character |
| `y` | Copy selected characters |
| `P`; `p` | Paste copied characters before / after the cursor |
| `u` | Undo, or lowercase if in visual mode |
| `U` | Uppercase |
| `<C-r>` | Redo the last operation |
| `k` / `<Up>` / `<C-p>`; `j` / `<Down>` / `<C-n>` | Recall previous / next input |
| `~` / `<F1>` | Open help |

## Confirm an operation

| Shortcut | Use |
| --- | --- |
| `<Esc>` / `<C-[>` / `<C-c>` / `n` | Cancel the confirm |
| `<Enter>` / `y` | Submit the confirm |
| `k` / `<Up>`; `j` / `<Down>` | Previous / next line |
| `~` / `<F1>` | Open help |

## Complete names

| Shortcut | Use |
| --- | --- |
| `<C-c>` | Cancel completion |
| `<Tab>` | Submit the completion |
| `<Enter>` | Complete and submit the input |
| `<A-k>` / `<Up>` / `<C-p>`; `<A-j>` / `<Down>` / `<C-n>` | Previous / next item |
| `~` / `<F1>` | Open help |

## Find help

| Shortcut | Use |
| --- | --- |
| `<Esc>` / `<C-[>` | Enter normal mode, or hide help menu |
| `<C-c>` | Close help menu |
| `<Enter>` | Close help menu and run selected action(s) |
| `k` / `<Up>` / `<C-p>`; `j` / `<Down>` / `<C-n>` | Previous / next line |

## Useful sequences

| Shortcut | Use |
| --- | --- |
| `y` in Fish → navigate → `q` | Finish with Fish in the chosen directory; Q leaves Fish where it was |
| `Space → move → Space → y → destination → p` | Copy selected files |
| `select files → x → destination → p` | Move selected files |
| `Y` | Cancel the pending copy/cut selection |
| `r → edit name → Enter` | Rename the highlighted file |
| `O → program → Enter` | Choose how to open a file |
| `t → destination → 1 / 2` | Work between directory tabs |
| `f → text` | Filter the current directory |
| `s / S → text` | Search filenames / file contents |
| `d / D` | Trash / permanently delete selected files |

---

[Theme](../home/yazi/theme.toml) · [Fish wrapper](../home/modules/common/fish.nix) · [Versioned defaults](https://github.com/sxyazi/yazi/blob/v26.9.1/yazi-config/preset/keymap-default.toml) · Checked 2026-11-15 · [Index](shortcuts.md) · [Find by task](task-index.md)
