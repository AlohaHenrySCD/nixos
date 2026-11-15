# Euporie

The saved notebook settings use `l/k` for previous/next cell and `j` for line numbers. Cell navigation keys apply outside ordinary text entry; Enter enters a cell, Esc leaves it.

**Version note:** no Euporie executable was found on PATH. Defaults below come from upstream **2.10.4**, merged with your saved settings. That release supports micro/vi/emacs and falls back to micro for the saved `helix` value; these are not Helix editor keys.

## On this page

[Console input](#console-input) · [Files, menus and other panels](#files-menus-and-other-panels) · [Search and completion](#search-and-completion) · [Edit cell text — typing and changes](#edit-cell-text--typing-and-changes)

[Edit cell text — movement](#edit-cell-text--movement) · [Edit cell text — selection and clipboard](#edit-cell-text--selection-and-clipboard) · [Read output and web views](#read-output-and-web-views) · [Navigate and select cells](#navigate-and-select-cells)

[Run cells and control the kernel](#run-cells-and-control-the-kernel) · [Create, edit and organize cells](#create-edit-and-organize-cells) · [Useful sequences](#useful-sequences)

## Console input

| Shortcut | Use |
| --- | --- |
| `Ctrl+c` | Clear the console input (without a selection) (console) |
| `Ctrl+c` | Interrupt the notebook's kernel (console) |
| `Ctrl+Enter` / `Ctrl+e` | Run the console input (console) |
| `Ctrl+d` | Exit when Control-D has been pressed (console) |
| `Ctrl+l` | Clear the screen (console) |

## Files, menus and other panels

| Shortcut | Use |
| --- | --- |
| `Ctrl+q` | Quit euporie |
| `Ctrl+w` | Close the current tab |
| `Ctrl+PageUp`; `Ctrl+PageDown` | Switch to the previous / next tab |
| `Shift+Tab`; `Tab` | Focus the previous / next control |
| `Ctrl+l` | Clear the screen |
| `Ctrl+o` | Open a file |
| `Alt+s` | Save the current file at a new location |
| `:` | Enter command mode (vi editing context) |
| `Alt+:` | Enter command mode |
| `!` / `Alt+!` | Open a shell-command prompt |
| `Ctrl+@` | Show the command palette |
| `Esc` / `Ctrl+c` | Exit command mode |
| `PageUp` | Scroll page up (prefer the cursor at the bottom of the page, after scrolling) |
| `PageDown` | Scroll page down (prefer the cursor at the top of the page, after scrolling) |
| `Ctrl+s` | Save the current file |
| `F5` | Reload the tab contents and reset the tab |
| `Shift+Tab` | Display contextual help (without a selection) |
| `Ctrl+Alt+Up`; `Ctrl+Alt+Down` | Get the previous / next history entry |
| `Esc` / `q` | Close the pager |
| `Ctrl+n` | Create a new notebook file |
| `Alt+m` | Toggle show top bar |
| `Ctrl+b` | Open or close the current side-bar pane |
| `Ctrl+c` / `Ctrl+q` | Quit euporie (preview app) |

## Search and completion

| Shortcut | Use |
| --- | --- |
| `Ctrl+f` / `F3` / `F7` | Enter search mode |
| `Ctrl+p`; `Ctrl+g` | Find the previous / next search match |
| `Shift+Tab`; `Ctrl+i` | Previous / next completion |
| `Esc` | Cancel a completion |
| `Enter` | Accept a selected completion |
| `Enter` | Accept the search input |
| `Esc` | Abort the search |

## Edit cell text — typing and changes

| Shortcut | Use |
| --- | --- |
| Typing | Enter a key |
| `(`; `[`; `{` | Insert paired parentheses / square brackets / braces |
| `)`; `]`; `}` | Close parentheses / square brackets / braces |
| `Enter` | Insert a newline with indentation (multiline input) |
| `Enter` | Accept input (single-line prompt) |
| `Backspace` / `Ctrl+h` | Backspace |
| `Home` / `Alt+Left` / `Alt+a`; `End` / `Alt+Right` / `Alt+e` | Move the cursor to the start / end of the line |
| `Tab` | Indent the current or selected lines (with a selection) |
| `Backspace` | Unindent the current or selected lines (without a selection) |
| `Shift+Tab` | Unindent the current or selected lines (with a selection) |
| `Ctrl+z`; `Ctrl+y` | Undo / redo the last edit |
| `Ctrl+d` | Duplicate the current line (without a selection) |
| `Delete` | Delete |
| `F4` | Toggle the case of the current word or selection |
| `Insert` | Toggle overwrite when using micro editing mode |
| `Ctrl+u` | Start/stop recording a macro |
| `Ctrl+j` | Re-execute the last keyboard macro defined |
| `Right` / `Ctrl+f` | Accept suggestion |
| `Alt+f` | Fill partial suggestion |
| `Ctrl+_` | Comment or uncomment the current or selected lines |
| `Alt+(` / `Alt+)` | Go to matching bracket if the cursor is on a paired bracket |

## Edit cell text — movement

Up/Down move between text lines; PageUp/PageDown scroll the text view.

| Shortcut | Use |
| --- | --- |
| `Left`; `Right` | Move one character left / right, crossing line boundaries |
| `Ctrl+Backspace` / `Alt+Backspace` / `Ctrl+Alt+h` / `Esc` → `Ctrl+h` | Delete the word behind the cursor, using whitespace as a word boundary |
| `Ctrl+Left` / `Alt+b`; `Ctrl+Right` / `Alt+f` | Backward / forward word |
| `Alt+Up`; `Alt+Down` | Move the current or selected lines up / down by one line |
| `Ctrl+Up` / `Ctrl+Home`; `Ctrl+Down` / `Ctrl+End` | Beginning / end of buffer |
| `Alt+{`; `Alt+}` | Move the cursor to the start / end of the current paragraph |

## Edit cell text — selection and clipboard

| Shortcut | Use |
| --- | --- |
| `Shift+Up` / `Shift+Down` / `Shift+Right` / `Shift+Left` / `Alt+Shift+Left` / `Alt+Shift+Right` / `Ctrl+Shift+Left` / `Ctrl+Shift+Right` / `Shift+Home` / `Shift+End` / `Ctrl+Shift+Home` / `Ctrl+Shift+End` | Start or extend selection |
| `Up` / `Down` / `Right` / `Left` / `Alt+Left` / `Alt+Right` / `Ctrl+Left` / `Ctrl+Right` / `Home` / `End` / `Ctrl+Home` / `Ctrl+End` | Cancel the selection |
| Typing | Replace selection by what is typed (with a selection) |
| `Delete` / `Backspace` / `Ctrl+h` | Delete the contents of the current selection (with a selection) |
| `Ctrl+c` | Add the current selection to the clipboard (with a selection) |
| `Ctrl+x` / `Shift+Delete` | Remove the current selection and add it to the clipboard (with a selection) |
| `Ctrl+k` | Cut the current line and add it to the clipboard |
| `Ctrl+d` | Duplicate the current selection (with a selection) |
| `Ctrl+v` | Paste the clipboard contents, replacing any current selection |
| `Ctrl+a` | Select all text |
| `"` | Wrap selection "" |
| `'` | Wrap selection '' |
| `(` / `)` | Wrap selection () |
| `{` / `}` | Wrap selection {} |
| `[` / `]` | Wrap selection [] |
| `` ` `` | Wrap selection `` |
| `*` | Wrap selection ** |
| `_` | Wrap selection __ |

## Read output and web views

| Shortcut | Use |
| --- | --- |
| `Left`; `Right` | Scroll left / right (output / web view) |
| `l`; `k` | Scroll the display up / down one line (output / web view) |
| `PageUp`; `PageDown` | Scroll the display up / down one page (output / web view) |
| `Home`; `End` | Scroll to top / bottom (output / web view) |
| `Alt+Left`; `Alt+Right` | Navigate backwards / forwards in the browser history (web view) |

## Navigate and select cells

| Shortcut | Use |
| --- | --- |
| `Enter` | Enter cell edit mode |
| `Esc` | Exit cell edit mode |
| `[` / wheel up; `]` / wheel down | Scroll the page up / down a line |
| `{`; `}` | Scroll the page up / down 5 lines |
| `Home` / `Ctrl+Up`; `End` / `Ctrl+Down` | Select the first / last cell in the notebook |
| `PageUp`; `PageDown` | Go up / down 5 cells |
| `l`; `k` | Previous / next cell |
| `Ctrl+a` | Select all cells in the notebook |
| `Shift+Home`; `Shift+End` | Extend the cell selection to the top / bottom of the notebook |
| `L`; `K` | Extend the cell selection up / down a cell |
| `Up`; `Down` | Previous / next cell |
| `l`; `k` | Previous / next cell (vi editing context) |
| `Left`; `Right` | Scroll the cell output to the left / right |

## Run cells and control the kernel

| Shortcut | Use |
| --- | --- |
| `Ctrl+Enter` / `Ctrl+e` / `Ctrl+Shift+F8` | Run or render the current cells |
| `Shift+Enter` / `Ctrl+r` / `Shift+F9` | Run or render the current cells and select the next cell |
| `Alt+Enter` | Run or render the current cells and insert a new cell below |
| `i` → `i` | Interrupt the notebook's kernel |
| `0` → `0` | Restart the notebook's kernel |

## Create, edit and organize cells

| Shortcut | Use |
| --- | --- |
| `a`; `b` | Add a new cell above / below the current |
| `d` → `d` | Delete the current cells |
| `z` | Undelete the last deleted cells |
| `x` | Cut the current cells |
| `c` | Copy the current cells |
| `Alt+c` | Copy the cell's output to the clipboard |
| `v` | Pate the previously copied cells |
| `Alt+Up`; `Alt+Down` | Move selected cells up / down |
| `m`; `y`; `r` | Convert selected cells to Markdown / code / raw text |
| `f` | Format the selected code cells |
| `F` | Automatically reformat all code cells in the notebook |
| `e` | Edit cell in $EDITOR |
| `M` | Merge the selected cells |
| `Ctrl+\` | Split the current cell at the cursor position |
| `w` | Toggle expand |
| `W` | Toggle wrap cell outputs |
| `j` | Toggle line numbers when a buffer does not have focus |

## Useful sequences

| Shortcut | Use |
| --- | --- |
| `Esc → k/l → Enter` | Choose a cell and edit it |
| `Esc → K/L` | Extend cell selection down/up |
| `Esc → b → Enter → code → Shift+Enter` | Add a cell below, edit it, run and select the next |
| `Ctrl+Enter` | Run selected cells without the next-cell action |
| `Esc → d → d → z` | Delete selected cells, then undelete |
| `Esc → m / y` | Convert selected cells to Markdown / code |
| `Esc → i → i` | Interrupt the kernel |
| `Esc → 0 → 0` | Restart the kernel; in-memory variables are lost |
| `Esc → j` | Toggle notebook line numbers |

---

[Saved settings](../home/euporie.json) · [Home Manager copy](../home/home.nix) · [Euporie 2.10.4 source](https://pypi.org/project/euporie/2.10.4/) · Checked 2026-11-15 · [Index](shortcuts.md) · [Find by task](task-index.md)
