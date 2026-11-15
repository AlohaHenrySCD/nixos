# Helix

Helix 25.07.1 · Your current layout

`j k l ;` = left/down/up/right. `→` = press in sequence. Uppercase letters include Shift. Unless marked, keys work in normal and select modes; `v` enters selection mode and Esc leaves it. Prefix a number to repeat, e.g. `10k`.

**Watch:** normal `Space → w` saves and `Space → c` closes a buffer. Select mode keeps the window menu/comment action on those keys. Use `Ctrl+w` for splits and `Ctrl+c` for comments in either mode. `k/l` follow document lines; arrows follow wrapped lines.

## On this page

[Movement](#movement) · [Selection and text objects](#selection-and-text-objects) · [Search and matching](#search-and-matching) · [Editing](#editing)

[Clipboard, registers and macros](#clipboard-registers-and-macros) · [Files and tools](#files-and-tools) · [Splits and view](#splits-and-view) · [Code, diagnostics and Git](#code-diagnostics-and-git)

[Debugging](#debugging) · [Shell and external tools](#shell-and-external-tools) · [Typing and deleting in insert mode](#typing-and-deleting-in-insert-mode) · [Reusable editing sequences](#reusable-editing-sequences)

[Picking files and results](#picking-files-and-results)

## Movement

In select mode, movements extend the selection. `f/F/t/T` wait for a target character. They can cross lines. Custom normal `w` selects an inner word then extends to the next word start; select-mode `w` extends normally.

| Shortcut | Use |
| --- | --- |
| `j` `k` `l` `;` | Left / down / up / right; vertical movement follows document lines |
| `Left` `Down` `Up` `Right` | Left / down / up / right; vertical movement follows wrapped screen lines |
| `g → j`; `g → k` | Down / up a document line |
| `T`; `t` | Move till previous / next occurrence of char |
| `F`; `f` | Move to previous / next occurrence of char |
| `Home` / `g → h`; `End` / `g → l` | Go to line start / end |
| `b` | Move to start of previous word |
| `e` | Move to end of next word |
| `W`; `E` | Move to start / end of next long word |
| `B` | Move to start of previous long word |
| `G` | Go to line |
| `g → g` | Go to line number N else file start |
| `g → \|` | Go to column |
| `g → e` | Go to last line |
| `g → f` | Go to files/URLs in selections |
| `g → s` | Go to first non-blank in line |
| `g → t`; `g → c`; `g → b` | Jump to view top / center / bottom |
| `g → a` | Go to last accessed file |
| `g → m` | Go to last modified file |
| `g → .` | Go to last modification |
| `g → w` | Jump to a two-character label |
| `Alt+b`; `Alt+e` | Move to beginning / end of the parent node |
| `[ → p`; `] → p` | Go to previous / next paragraph |
| `Ctrl+o`; `Ctrl+i` / `Tab` | Jump backward / forward on jumplist |
| `Ctrl+s` | Save current selection to jumplist |

## Selection and text objects

Select first, then edit. `mi` = inside; `ma` = around. Follow with `w/W` word, `p` paragraph, a bracket/quote, or `m` nearest surround. Syntax objects: `f` function, `t` type, `a` argument, `c` comment, `T` test, `e` entry, `g` change.

| Shortcut | Use |
| --- | --- |
| `h` | Collapse selection into single cursor |
| `v` | Enter selection extend mode; select: enter normal mode |
| `Alt+d` | Delete selection without yanking |
| `Alt+c` | Replace selected text without copying it; enter insert mode |
| `Alt+C`; `C` | Copy selection on previous / next line |
| `Alt+-` | Merge selections |
| `Alt+_` | Merge consecutive selections |
| `Alt+;` / `Alt+h` | Flip selection cursor and anchor |
| `Alt+o` / `Alt+Up` | Expand selection to parent syntax node |
| `Alt+i` / `Alt+Down` | Shrink selection to previously expanded syntax node |
| `Alt+I` / `Alt+Shift+Down` | Select all children of the current node |
| `Alt+p` / `Alt+Left`; `Alt+n` / `Alt+Right` | Select previous / next sibling in the syntax tree |
| `Alt+a` | Select all siblings of the current node |
| `%` | Select whole document |
| `x`; `X` | Select line; repeat to extend/shrink downward / upward |
| `m → m` | Go to matching bracket |
| `m → s` | Add surrounding brackets or quotes |
| `m → r` | Replace surrounding brackets or quotes |
| `m → d` | Remove surrounding brackets or quotes |
| `m → a`; `m → i` | Select around / inside a text object |
| `,` | Keep primary selection |
| `Alt+,` | Remove primary selection |
| `&` | Align selections in column |
| `_` | Trim whitespace from selections |
| `(`; `)` | Rotate selections backward / forward |
| `Alt+(`; `Alt+)` | Rotate selection contents backward / forward |
| `Alt+:` | Ensure all selections face forward |
| `Esc` | Enter normal mode; select: exit selection mode |

## Search and matching

| Shortcut | Use |
| --- | --- |
| `s` | Select all regex matches inside selections |
| `/` / `z → /` / `Z → /`; `?` / `z → ?` / `Z → ?` | Search regex forward / backward |
| `N` / `z → N` / `Z → N`; `n` / `z → n` / `Z → n` | Select previous / next search match |
| `*` | Use current selection as search pattern |
| `Alt+*` | Use current selection as the search pattern, automatically wrapping with `\\b` on word boundaries |
| `K`; `Alt+K` | Keep / remove selections matching regex |
| `Space → '` | Open last picker |
| `Space → /` | Global search in workspace folder |

## Editing

| Shortcut | Use |
| --- | --- |
| `r` | Replace with new char |
| `Alt+.` | Repeat last motion |
| `~` | Switch (toggle) case |
| `` ` `` | Switch to lowercase |
| `` Alt+` `` | Switch to uppercase |
| `w` | Select inner word and extend to the next word start; select: extend to start of next word |
| `i`; `a` | Insert before / after selection |
| `I`; `A` | Insert at start / end of line |
| `O`; `o` | Open new line above / below selection |
| `d` | Delete selection |
| `c` | Replace selected text and enter insert mode |
| `Alt+x` | Shrink selection to line bounds |
| `[ → Space`; `] → Space` | Add newline above / below |
| `u`; `U` | Undo / redo change |
| `Alt+u`; `Alt+U` | Move backward / forward in history |
| `>`; `<` | Indent / unindent selection |
| `=` | Format selection |
| `J` | Join lines inside selection |
| `Alt+J` | Join lines inside selection and select spaces |
| `Ctrl+a`; `Ctrl+x` | Increment / decrement item under cursor |

## Clipboard, registers and macros

`y/p` use editor registers; `Space → y/p` use the system clipboard. After `"`, type a register letter.

| Shortcut | Use |
| --- | --- |
| `R` | Replace with yanked text |
| `y` | Yank selection |
| `P`; `p` | Paste before / after selection |
| `Q` | Record macro |
| `q` | Replay macro |
| `Space → y` | Yank selections to clipboard |
| `Space → Y` | Yank main selection to clipboard |
| `Space → P`; `Space → p` | Paste clipboard before / after selections |
| `Space → R` | Replace selections by clipboard content |
| `"` | Select register |

## Files and tools

| Shortcut | Use |
| --- | --- |
| `g → p`; `g → n` | Go to previous / next buffer |
| `:` | Enter command mode |
| `Space → f` | Open file picker |
| `Space → F` | Open file picker at current working directory |
| `Space → e` | Open file explorer in workspace root |
| `Space → E` | Open file explorer at current buffer's directory |
| `Space → b` | Open buffer picker |
| `Space → j` | Open jumplist picker |
| `Space → g` | Open changed file picker |
| `Space → c` | Close current buffer; select: comment/uncomment selections |
| `Space → ?` | Open command palette |
| `Space → Q` | Force quit; may discard unsaved edits (normal only) |
| `Space → W` | Save all files (normal only) |
| `Space → q` | Quit; refuse unsaved edits (normal only) |
| `Space → x` | Save and quit (normal only) |

## Splits and view

`Ctrl+w → …` is sequential. `z` performs one view action; `Z` stays in the view menu until Esc. Nested directions keep their own keys.

| Shortcut | Use |
| --- | --- |
| `Alt+s` | Split selection on newlines |
| `S` | Split selections on regex matches |
| `Ctrl+b` / `PageUp` / `z → Ctrl+b` / `z → PageUp` / `Z → Ctrl+b` / `Z → PageUp`; `Ctrl+f` / `PageDown` / `z → Ctrl+f` / `z → PageDown` / `Z → Ctrl+f` / `Z → PageDown` | Move page up / down |
| `Ctrl+u` / `z → Ctrl+u` / `z → Backspace` / `Z → Ctrl+u` / `Z → Backspace`; `Ctrl+d` / `z → Ctrl+d` / `z → Space` / `Z → Ctrl+d` / `Z → Space` | Move page and cursor half up / down |
| `Ctrl+w → Ctrl+w` / `Ctrl+w → w` | Go to next window |
| `Ctrl+w → Ctrl+s` / `Ctrl+w → s`; `Ctrl+w → Ctrl+v` / `Ctrl+w → v` | Split below / right |
| `Ctrl+w → Ctrl+t` / `Ctrl+w → t` | Transpose splits |
| `Ctrl+w → f`; `Ctrl+w → F` | Open selected file paths in a split below / right |
| `Ctrl+w → Ctrl+q` / `Ctrl+w → q` | Close window |
| `Ctrl+w → Ctrl+o` / `Ctrl+w → o` | Close windows except current |
| `Ctrl+w → Ctrl+h` / `Ctrl+w → h` / `Ctrl+w → Left`; `Ctrl+w → Ctrl+l` / `Ctrl+w → l` / `Ctrl+w → Right` | Jump to left / right split |
| `Ctrl+w → Ctrl+k` / `Ctrl+w → k` / `Ctrl+w → Up`; `Ctrl+w → Ctrl+j` / `Ctrl+w → j` / `Ctrl+w → Down` | Jump to split above / below |
| `Ctrl+w → H`; `Ctrl+w → L` | Swap with left / right split |
| `Ctrl+w → K`; `Ctrl+w → J` | Swap with split above / below |
| `Ctrl+w → n → Ctrl+s` / `Ctrl+w → n → s`; `Ctrl+w → n → Ctrl+v` / `Ctrl+w → n → v` | New scratch buffer in a split below / right |
| `Space → w` | Save current file (normal only) |
| `z → z` / `z → c` / `Z → z` / `Z → c` | Align view center |
| `z → t` / `Z → t`; `z → b` / `Z → b` | Align view top / bottom |
| `z → m` / `Z → m` | Align view middle |
| `z → k` / `z → Up` / `Z → k` / `Z → Up`; `z → j` / `z → Down` / `Z → j` / `Z → Down` | Scroll view up / down |
| `Ctrl+j`; `Ctrl+k`; `Ctrl+l`; `Ctrl+;` | Focus split left / down / up / right (normal only) |
| `Space → w → Ctrl+w` / `Space → w → w` | Go to next window (select only) |
| `Space → w → Ctrl+s` / `Space → w → s`; `Space → w → Ctrl+v` / `Space → w → v` | Split below / right (select only) |
| `Space → w → Ctrl+t` / `Space → w → t` | Transpose splits (select only) |
| `Space → w → f`; `Space → w → F` | Open selected file paths in a split below / right (select only) |
| `Space → w → Ctrl+q` / `Space → w → q` | Close window (select only) |
| `Space → w → Ctrl+o` / `Space → w → o` | Close windows except current (select only) |
| `Space → w → Ctrl+h` / `Space → w → h` / `Space → w → Left`; `Space → w → Ctrl+l` / `Space → w → l` / `Space → w → Right` | Jump to left / right split (select only) |
| `Space → w → Ctrl+k` / `Space → w → k` / `Space → w → Up`; `Space → w → Ctrl+j` / `Space → w → j` / `Space → w → Down` | Jump to split above / below (select only) |
| `Space → w → H`; `Space → w → L` | Swap with left / right split (select only) |
| `Space → w → K`; `Space → w → J` | Swap with split above / below (select only) |
| `Space → w → n → Ctrl+s` / `Space → w → n → s`; `Space → w → n → Ctrl+v` / `Space → w → n → v` | New scratch buffer in a split below / right (select only) |

## Code, diagnostics and Git

Language-server and syntax actions need support for the current file type.

| Shortcut | Use |
| --- | --- |
| `g → d` | Go to definition |
| `g → D` | Go to declaration |
| `g → y` | Go to type definition |
| `g → r` | Go to references |
| `g → i` | Go to implementation |
| `[ → d`; `] → d` | Go to previous / next diagnostic |
| `[ → D`; `] → D` | Go to first / last diagnostic |
| `[ → g`; `] → g` | Go to previous / next change |
| `[ → G`; `] → G` | Go to first / last change |
| `[ → f`; `] → f` | Go to previous / next function |
| `[ → t`; `] → t` | Go to previous / next type definition |
| `[ → a`; `] → a` | Go to previous / next parameter |
| `[ → c`; `] → c` | Go to previous / next comment |
| `[ → e`; `] → e` | Go to previous / next pairing |
| `[ → T`; `] → T` | Go to previous / next test |
| `Ctrl+c` | Comment/uncomment selections |
| `Space → s` | Open symbol picker |
| `Space → S` | Open workspace symbol picker |
| `Space → d` | Open diagnostic picker |
| `Space → D` | Open workspace diagnostic picker |
| `Space → a` | Perform code action |
| `Space → k` | Show docs for item under cursor |
| `Space → r` | Rename symbol |
| `Space → h` | Select symbol references |
| `Space → C` | Block comment/uncomment selections |
| `Space → Alt+c` | Line comment/uncomment selections |

## Debugging

Requires a configured debug adapter. `Space → G` stays in the debug menu until Esc.

| Shortcut | Use |
| --- | --- |
| `Space → G → l` | Launch debug target |
| `Space → G → r` | Restart debugging session |
| `Space → G → b` | Toggle breakpoint |
| `Space → G → c` | Continue program execution |
| `Space → G → h` | Pause program execution |
| `Space → G → i` | Step in |
| `Space → G → o` | Step out |
| `Space → G → n` | Step to next |
| `Space → G → v` | List variables |
| `Space → G → t` | End debug session |
| `Space → G → Ctrl+c` | Edit breakpoint condition on current line |
| `Space → G → Ctrl+l` | Edit breakpoint log message on current line |
| `Space → G → s → t` | Switch current thread |
| `Space → G → s → f` | Switch stack frame |
| `Space → G → e`; `Space → G → E` | Enable / disable exception breakpoints |

## Shell and external tools

Pipe actions run shell commands; the replacing pipe overwrites selected text.

| Shortcut | Use |
| --- | --- |
| `\|` | Pipe selections through shell command |
| `Alt+\|` | Pipe selections into shell command ignoring output |
| `!`; `Alt+!` | Insert shell output before / after selections |
| `$` | Filter selections with shell predicate |
| `Ctrl+z` | Suspend and return to shell |

## Typing and deleting in insert mode

Enter with `i/a/o`; Esc returns to normal. Ordinary text inserts at every cursor. These keys apply while typing, independently of normal-mode remappings.

| Shortcut | Use |
| --- | --- |
| `Esc` | Enter normal mode |
| `Ctrl+s` | Commit changes to new checkpoint |
| `Ctrl+x` | Invoke completion popup |
| `Ctrl+r` | Insert register |
| `Ctrl+w` / `Alt+Backspace`; `Alt+d` / `Alt+Delete` | Delete previous / next word |
| `Ctrl+u`; `Ctrl+k` | Delete till start / end of line |
| `Ctrl+h` / `Backspace` / `Shift+Backspace`; `Ctrl+d` / `Delete` | Delete previous / next char |
| `Ctrl+j` / `Enter` | Insert newline char |
| `Tab` | Insert tab if all cursors have all whitespace to their left; otherwise, run a separate command. |
| `Shift+Tab` | Insert tab char |
| `Up`; `Down`; `Left`; `Right` | Up / down / left / right; vertical movement follows wrapped screen lines |
| `PageUp`; `PageDown` | Move page up / down |
| `Home`; `End` | Line start / newline at line end |

## Reusable editing sequences

| Shortcut | Use |
| --- | --- |
| `miw → c → text → Esc` | Replace the current word |
| `mi" → c → text → Esc` | Replace text inside quotes |
| `% → s → pattern → Enter → c → text → Esc` | Replace all matching selections in this file |
| `miw → * → v → n` | Keep adding matching occurrences |
| `x → x → Ctrl+c` | Select two lines and toggle comments |
| `C → C → i → text → Esc` | Insert at corresponding positions on three lines |
| `selection → ms → (` | Wrap selection in parentheses |
| `mr → ( → [` | Change surrounding parentheses to brackets |
| `md → (` | Remove surrounding parentheses |
| `gd → Ctrl+o` | Visit definition, then return |
| `Space → f → filename → Ctrl+v` | Open a file in a vertical split |
| `selection → Space → y` | Copy selected text to another application |
| `selection → \| → sort → Enter` | Replace selected lines with sorted output |
| `" → a → Q → edit → Q → q` | Record into register a, stop and replay |
| `Esc → Space → W` | Save all buffers |
| `.` | Repeat the last insert |

## Picking files and results


### Choose a result

| Shortcut | Use |
| --- | --- |
| `Shift-Tab`, `Up`, `Ctrl-p`; `Tab`, `Down`, `Ctrl-n` | Previous / next entry |
| `PageUp`, `Ctrl-u`; `PageDown`, `Ctrl-d` | Page up / down |
| `Home`; `End` | Go to first / last entry |
| `Enter` | Open selected |
| `Alt-Enter` | Open selected in the background without closing the picker |
| `Ctrl-s` | Open horizontally |
| `Ctrl-v` | Open vertically |
| `Ctrl-t` | Toggle preview |
| `Escape`, `Ctrl-c` | Close picker |

### Edit search / command text

| Shortcut | Use |
| --- | --- |
| `Escape`, `Ctrl-c` | Close prompt |
| `Alt-b`, `Ctrl-Left`; `Alt-f`, `Ctrl-Right` | Backward / forward a word |
| `Ctrl-b`, `Left`; `Ctrl-f`, `Right` | Backward / forward a char |
| `Ctrl-a`, `Home`; `Ctrl-e`, `End` | Move prompt start / end |
| `Ctrl-w`, `Alt-Backspace`, `Ctrl-Backspace`; `Alt-d`, `Alt-Delete`, `Ctrl-Delete` | Delete previous / next word |
| `Ctrl-u`; `Ctrl-k` | Delete to start / end of line |
| `Backspace`, `Ctrl-h`, `Shift-Backspace`; `Delete`, `Ctrl-d` | Delete previous / next char |
| `Ctrl-s` | Insert a word under doc cursor, may be changed to Ctrl-r Ctrl-w later |
| `Ctrl-p`, `Up`; `Ctrl-n`, `Down` | Select previous / next history |
| `Ctrl-r` | Insert the content of the register selected by following input char |
| `BackTab`; `Tab` | Select previous / next completion item |
| `Enter` | Open selected |

### Accept completions

| Shortcut | Use |
| --- | --- |
| `Shift-Tab`, `Ctrl-p`, `Up`; `Tab`, `Ctrl-n`, `Down` | Previous / next entry |
| `Enter` | Close menu and accept completion |
| `Ctrl-c` | Close menu and reject completion |

### Read popups

| Shortcut | Use |
| --- | --- |
| `Ctrl-u`; `Ctrl-d` | Scroll up / down |

### Browse signatures

| Shortcut | Use |
| --- | --- |
| `Alt-p`; `Alt-n` | Previous / next signature |

---

[Configuration](../home/modules/common/helix.nix) · [Versioned source](https://github.com/helix-editor/helix/blob/25.07.1/helix-term/src/keymap/default.rs) · Checked 2026-11-15 · [Index](shortcuts.md) · [Find by task](task-index.md)
