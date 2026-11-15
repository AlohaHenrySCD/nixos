# Broot

Broot 1.61.0 · Type to filter the tree. `:name` is a typed action followed by Enter. Single-letter shortcuts such as h/j/k apply in command mode; in input mode letters enter search text. Esc steps out of input/completion/current view.

## On this page

[Open, manage and leave](#open-manage-and-leave) · [Navigate and type](#navigate-and-type) · [Panels and previews](#panels-and-previews) · [Search and change the listing](#search-and-change-the-listing)

[Select and stage files](#select-and-stage-files) · [Edit search text](#edit-search-text) · [Useful sequences](#useful-sequences)

## Open, manage and leave

| Shortcut | Use |
| --- | --- |
| `esc` | Escape from edition, completion, page, etc. |
| `Alt+Enter` / `:ol` | Open file or directory according to os (quit broot) (file) |
| `Alt+Enter` / `:ol` | Change directory and leave broot (directory) |
| `:cp` | Copy to a new path |
| `Alt+c` | Copy selected line (in tree or preview) |
| `:ot` | Show the content of the trash |
| `:rt` | Restore a file which is in the trash |
| `:dt` | Irreversibly delete a file which is in the trash |
| `:et` | Irreversibly delete the trash's content |
| `:fs` | List mounted filesystems |
| `F1` / `:?` | Display broot's help |
| `:md` | Create a directory |
| `:mv` | Move to a new path |
| `F2` | Prepare to rename; enter confirms |
| `Enter` / `:os` | Open file or directory according to os (stay in broot) |
| `:osf` | Display the directory, keeping the current pattern |
| `:pp` | Print path and leaves broot |
| `:prp` | Print relative path and leaves broot |
| `:pt` | Print tree and leaves broot |
| `Ctrl+c` / `Ctrl+q` / `:q` | Quit broot |
| `F5` | Refresh tree and clear size cache |
| `:osa` | Open the staging area |
| `:csa` | Close the staging area panel |
| `:up` | Focus the parent of the current root |
| `Ctrl+E` / `:e` | Edit selected text files in ms |
| `Ctrl+B` | Prepare a versioned copy; enter version and confirm |
| `Ctrl+T` | Open a shell here; exiting returns to Broot |
| `:zip NAME` | Archive staged/selected files |
| `:create PATH` | Create/edit a text file in ms |
| `:gd` | Open the selected file in git difftool |

## Navigate and type

| Shortcut | Use |
| --- | --- |
| `Home`; `End` | Move the cursor to the start / end of input |
| `Up` / `k`; `Down` / `j` | Move one line up / down |
| `L` / `Ctrl+f` | Display the directory |
| `Ctrl+v` | Paste the clipboard content into the input |
| `Space` / `:` / `/` | Enter the input mode |
| `h` / `:p` | Move to the parent directory |
| `Ctrl+u` / `PageUp`; `Ctrl+d` / `PageDown` | Scroll one page up / down |
| `Ctrl+Up` / `Alt+Up`; `Ctrl+Down` / `Alt+Down` | Move tree root up / down |
| `Alt+PageUp`; `Alt+PageDown` | Scroll the rightmost panel up / down |

## Panels and previews

| Shortcut | Use |
| --- | --- |
| `:wrap` | Toggle line wrapping in previews |
| `:img`; `:txt`; `:hex`; `:tty` | Preview as image / text / binary / terminal recording |
| `Ctrl+w` | Close the panel, not using the selected path |
| `:cpp` | Copy to the other panel |
| `:mvp` | Move to the other panel |
| `Ctrl+p` | Either open or close an additional panel |
| `Ctrl+Left` / `Alt+Left` | Either focus panel on left or close right one |
| `Ctrl+Right` / `Alt+Right` | Focus or open panel on right |
| `Alt+>` / `Alt+<` | Move a panel divider |

## Search and change the listing

| Shortcut | Use |
| --- | --- |
| `Shift+Tab`; `Tab` | Select the previous / next match |
| `:ns` | Don't sort |
| `:tsa` | Open/close the staging area panel |
| `:tree` | Toggle showing more than one level of the tree |
| `Alt+w` / `:watch` | Toggle watching the current root for changes |
| `:sc`; `:sd`; `:ss`; `:st` | Sort by count / date / size / type |
| `:counts` | Toggle showing number of files in directories |
| `:dates` | Toggle showing last modified dates |
| `:dev` | Toggle showing device id |
| `:files` | Toggle showing files (or just folders) |
| `Alt+i` / `:gi` | Toggle use of .gitignore and .ignore |
| `:gf` | Toggle display of git file information |
| `Alt+g` / `:gs` | Toggle showing only files relevant for git status |
| `:rfs` | Toggle showing filesystem info on top |
| `Alt+h` / `:h` | Toggle showing hidden files |
| `:perm` | Toggle showing file permissions |
| `:sizes` | Toggle showing sizes |
| `Ctrl+s` | Either put back last search, or search deeper |

## Select and stage files

| Shortcut | Use |
| --- | --- |
| `:cls` | Empty the staging area |
| `+` | Add / remove selection from the staging area |
| `Ctrl+a` | Stage all matching files |
| `Ctrl+g` | Add or remove selection to staging area |

## Edit search text

| Shortcut | Use |
| --- | --- |
| `Left / Right` | Move the input cursor |
| `Home / End` | Go to start / end |
| `Shift+arrows / Shift+Home / Shift+End` | Extend text selection |
| `Backspace / Delete` | Delete before / at cursor, or delete selected text |
| `Enter` | Run the typed action; otherwise open/focus the selected entry |
| `?` | Open help when the input is empty or you are entering an action |

## Useful sequences

| Shortcut | Use |
| --- | --- |
| `filename → Enter` | Filter and open/focus a result |
| `filename → Ctrl+E` | Edit matching text files in ms |
| `Ctrl+Right → Alt+PageDown` | Open/move to the right panel, then scroll its contents |
| `Ctrl+G → move → Ctrl+G → :zip archive → Enter` | Stage several files, then archive them |
| `F2 → new name → Enter` | Rename selected entry |
| `Alt+H → Alt+I` | Show hidden files and toggle ignore filtering |
| `:ss → Enter` | Sort by size |
| `? → keyword` | Filter the built-in help |
| `Alt+Enter` on a directory | Leave Broot and change the parent shell directory when using shell integration |

F1/F2 are intercepted by Niri for screenshots. Use `?` for help and `:rename NEW_NAME` for renaming there. Broot `:rm` permanently removes files; `:trash` sends them to trash. Local `Ctrl+B` prepares a copy only when invoked.

---

[Configuration](../home/modules/common/broot.nix) · [Local imported verbs](/home/alohahenry/.config/broot/verbs.hjson) · [Versioned defaults](https://github.com/Canop/broot/blob/v1.61.0/src/verb/verb_store.rs) · Checked 2026-11-15 · [Index](shortcuts.md) · [Find by task](task-index.md)
