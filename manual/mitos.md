# Mitos

Mitos 0.1.2 · b3906d2ee · Your current layout

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
| `g → g` | Go to line number `N` else file start |
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
| `m → A` | Select all textobjects around selections |
| `m → I` | Select all textobjects inside selections |
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
| `Alt+*` | Use current selection as the search pattern, automatically wrapping with `\b` on word boundaries |
| `K`; `Alt+K` | Keep / remove selections matching regex |
| `Space → '` | Open last picker |
| `Space → /` | Global search in workspace folder |

## Editing

| Shortcut | Use |
| --- | --- |
| `r` | Replace each selected grapheme with a character |
| `Alt+r` | Replace selections with entered text |
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
| `Alt+q` | Add current location to quicklist |
| `[ → q`; `] → q` | Go to previous / next quicklist entry |
| `[ → l`; `] → l` | Go to previous / next quicklist entry in current file |
| `Space → f` | Open file picker |
| `Space → F` | Open file picker at current working directory |
| `Space → e` | Open file explorer in workspace root |
| `Space → E` | Open file explorer at current buffer's directory |
| `Space → b` | Open buffer picker |
| `Space → j` | Open jumplist picker |
| `Space → q` | Quit; refuse unsaved edits; select: open quicklist picker |
| `Space → g` | Open changed file picker in workspace |
| `Space → c` | Close current buffer; select: comment/uncomment selections |
| `Space → ?` | Open command palette |
| `Space → Q` | Force quit; may discard unsaved edits (normal only) |
| `Space → W` | Save all files (normal only) |
| `Space → x` | Save and quit (normal only) |

## Splits and view

`Ctrl+w → …` is sequential. `z` performs one view action; `Z` stays in the view menu until Esc. Nested directions keep their own keys.

| Shortcut | Use |
| --- | --- |
| `Alt+s` | Split selection on newlines |
| `S` | Split selections on regex matches |
| `Ctrl+b` / `PageUp` / `z → Ctrl+b` / `z → PageUp` / `Z → Ctrl+b` / `Z → PageUp`; `Ctrl+f` / `PageDown` / `z → Ctrl+f` / `z → PageDown` / `Z → Ctrl+f` / `Z → PageDown` | Move page up / down |
| `Ctrl+u` / `z → Ctrl+u` / `z → Backspace` / `Z → Ctrl+u` / `Z → Backspace`; `Ctrl+d` / `z → Ctrl+d` / `z → Space` / `Z → Ctrl+d` / `Z → Space` | Move page and cursor half up / down |
| `Ctrl+w → W`; `Ctrl+w → Ctrl+w` / `Ctrl+w → w` | Go to previous / next window |
| `Ctrl+w → Ctrl+s` / `Ctrl+w → s`; `Ctrl+w → Ctrl+v` / `Ctrl+w → v` | Split below / right |
| `Ctrl+w → Ctrl+t` / `Ctrl+w → t` | Transpose splits |
| `Ctrl+w → f`; `Ctrl+w → F` | Open selected file paths in a split below / right |
| `Ctrl+w → Ctrl+q` / `Ctrl+w → q` | Close window |
| `Ctrl+w → Ctrl+o` / `Ctrl+w → o` | Close windows except current |
| `Ctrl+w → Ctrl+h` / `Ctrl+w → h` / `Ctrl+w → Left`; `Ctrl+w → Ctrl+l` / `Ctrl+w → l` / `Ctrl+w → Right` | Jump to left / right split |
| `Ctrl+w → Ctrl+k` / `Ctrl+w → k` / `Ctrl+w → Up`; `Ctrl+w → Ctrl+j` / `Ctrl+w → j` / `Ctrl+w → Down` | Jump to split above / below |
| `Ctrl+w → H` / `Ctrl+w → Shift+Left`; `Ctrl+w → L` / `Ctrl+w → Shift+Right` | Swap with left / right split |
| `Ctrl+w → K` / `Ctrl+w → Shift+Up`; `Ctrl+w → J` / `Ctrl+w → Shift+Down` | Swap with split above / below |
| `Ctrl+w → n → Ctrl+s` / `Ctrl+w → n → s`; `Ctrl+w → n → Ctrl+v` / `Ctrl+w → n → v` | New scratch buffer in a split below / right |
| `Space → w` | Save current file (normal only) |
| `z → z` / `z → c` / `Z → z` / `Z → c` | Align view center |
| `z → t` / `Z → t`; `z → b` / `Z → b` | Align view top / bottom |
| `z → m` / `Z → m` | Align view middle |
| `z → k` / `z → Up` / `Z → k` / `Z → Up`; `z → j` / `z → Down` / `Z → j` / `Z → Down` | Scroll view up / down |
| `Ctrl+j`; `Ctrl+k`; `Ctrl+l`; `Ctrl+;` | Focus split left / down / up / right (normal only) |
| `Space → w → W`; `Space → w → Ctrl+w` / `Space → w → w` | Go to previous / next window (select only) |
| `Space → w → Ctrl+s` / `Space → w → s`; `Space → w → Ctrl+v` / `Space → w → v` | Split below / right (select only) |
| `Space → w → Ctrl+t` / `Space → w → t` | Transpose splits (select only) |
| `Space → w → f`; `Space → w → F` | Open selected file paths in a split below / right (select only) |
| `Space → w → Ctrl+q` / `Space → w → q` | Close window (select only) |
| `Space → w → Ctrl+o` / `Space → w → o` | Close windows except current (select only) |
| `Space → w → Ctrl+h` / `Space → w → h` / `Space → w → Left`; `Space → w → Ctrl+l` / `Space → w → l` / `Space → w → Right` | Jump to left / right split (select only) |
| `Space → w → Ctrl+k` / `Space → w → k` / `Space → w → Up`; `Space → w → Ctrl+j` / `Space → w → j` / `Space → w → Down` | Jump to split above / below (select only) |
| `Space → w → H` / `Space → w → Shift+Left`; `Space → w → L` / `Space → w → Shift+Right` | Swap with left / right split (select only) |
| `Space → w → K` / `Space → w → Shift+Up`; `Space → w → J` / `Space → w → Shift+Down` | Swap with split above / below (select only) |
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
| `Enter` | Jump from a diff review to its source location |
| `[ → d`; `] → d` | Go to previous / next diagnostic |
| `[ → s`; `] → s` | Go to previous / next spelling finding |
| `[ → D`; `] → D` | Go to first / last diagnostic |
| `[ → g`; `] → g` | Go to previous / next change |
| `[ → G`; `] → G` | Go to first / last change |
| `[ → f`; `] → f` | Go to previous / next function |
| `[ → t`; `] → t` | Go to previous / next type definition |
| `[ → a`; `] → a` | Go to previous / next parameter |
| `[ → c`; `] → c` | Go to previous / next comment |
| `[ → e`; `] → e` | Go to previous / next pairing |
| `[ → T`; `] → T` | Go to previous / next test |
| `[ → x`; `] → x` | Go to previous / next (X)HTML element |
| `Ctrl+c` | Comment/uncomment selections |
| `Space → s` | Open symbol picker from LSP or syntax information |
| `Space → S` | Open workspace symbol picker from LSP or syntax information |
| `Space → d` | Open diagnostic picker |
| `Space → D` | Open workspace diagnostic picker |
| `Space → a` | Perform code action |
| `Space → l` | Show code lenses under cursor |
| `Space → k` | Show docs for item under cursor |
| `Space → r` | Rename symbol |
| `Space → h` | Select symbol references |
| `Space → C` | Block comment/uncomment selections |
| `Space → Alt+c` | Line comment/uncomment selections |
| `Space → B` | Toggle inline Git blame |
| `Space → i` | Show the current change against HEAD |

## Debugging

Requires a configured debug adapter. `Space → G` stays in the debug menu until Esc.

| Shortcut | Use |
| --- | --- |
| `Space → G → l` | Launch debug target |
| `Space → G → r` | Restart debugging session |
| `Space → G → b` | Toggle breakpoints |
| `Space → G → c` | Continue program execution |
| `Space → G → h` | Pause program execution |
| `Space → G → i` | Step in |
| `Space → G → o` | Step out |
| `Space → G → n` | Step to next |
| `Space → G → v` | Browse variables |
| `Space → G → t` | End debug session |
| `Space → G → Ctrl+c` | Edit breakpoint condition on current line |
| `Space → G → Ctrl+l` | Edit breakpoint log message on current line |
| `Space → G → s → s` | Switch debugging session |
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

`mI/mA` selects all inner/around objects: `% → mIf` selects every function body. `s` is a spelling object, `d` diagnostic ranges in select-all mode, and `x` an XML/HTML element. Kitty captures `Alt+r`, so it opens terminal scrollback instead of Mitos replacement.

## Picking files and results

Pickers accept typing to filter results. Prompt controls also apply unless a picker key takes precedence.

| Shortcut | Use |
| --- | --- |
| `` <ret> `` | Accept |
| `` <C-s> `` | Accept horizontal split |
| `` <A-ret> `` | Accept keep open |
| `` <C-v> `` | Accept vertical split |
| `` <C-c> ``, `` <esc> `` | Cancel |
| `` <up> ``, `` <C-p> ``, `` <S-tab> ``; `` <C-n> ``, `` <tab> ``, `` <down> `` | Move up / down |
| `` <home> ``; `` <end> `` | Move start / end |
| `` <A-o> `` | Open preview |
| `` <C-u> ``, `` <pageup> ``; `` <C-d> ``, `` <pagedown> `` | Page up / down |
| `` <C-q> `` | Populate quicklist |
| `` <A-left> ``; `` <A-right> `` | Preview previous / next |
| `` <A-up> ``; `` <A-down> `` | Preview scroll up / down |
| `` <C-ret> ``, `` <Meta-ret> `` | Replace all |
| `` <A-c> `` | Toggle case sensitive |
| `` <C-t> `` | Toggle preview |
| `` <A-r> `` | Toggle replacement |

### Quicklist picker

| Shortcut | Use |
| --- | --- |
| `` <C-x> `` | Remove entry |

### Git picker

| Shortcut | Use |
| --- | --- |
| `` <A-a> `` | Actions |
| `` <A-p> ``, `` <A-left> ``; `` <A-n> ``, `` <A-right> `` | Preview previous / next |
| `` <A-s> `` | Stage |
| `` <A-z> `` | Stash |
| `` <A-l> `` | Stashes |
| `` <A-u> `` | Unstage |

### Stash picker

| Shortcut | Use |
| --- | --- |
| `` <A-a> `` | Actions |
| `` <A-s> `` | Apply stash |
| `` <A-i> `` | Apply stash with index |

### History picker

| Shortcut | Use |
| --- | --- |
| `` <A-a> `` | Actions |
| `` <A-h> `` | Back |

### Prompt

| Shortcut | Use |
| --- | --- |
| `` <ret> `` | Accept |
| `` <C-c> ``, `` <esc> `` | Cancel |
| `` <S-tab> ``; `` <tab> `` | Complete previous / next |
| `` <C-h> ``, `` <backspace> ``, `` <S-backspace> ``; `` <C-d> ``, `` <del> `` | Delete backward / forward |
| `` <C-u> ``; `` <C-k> `` | Delete to start / end |
| `` <C-w> ``, `` <A-backspace> ``, `` <C-backspace> ``; `` <A-d> ``, `` <A-del> ``, `` <C-del> `` | Delete word backward / forward |
| `` <C-q> `` | Exit selection |
| `` <up> ``, `` <C-p> ``; `` <C-n> ``, `` <down> `` | History previous / next |
| `` <C-r> `` | Insert register |
| `` <C-s> `` | Insert word |
| `` <C-a> ``, `` <home> ``; `` <C-e> ``, `` <end> `` | Move start / end |
| `` <C-b> ``, `` <left> ``; `` <C-f> ``, `` <right> `` | Move left / right |
| `` <A-b> ``, `` <C-left> ``; `` <A-f> ``, `` <C-right> `` | Move word left / right |

### Completion menu

| Shortcut | Use |
| --- | --- |
| `` <ret> `` | Accept |
| `` <C-c> ``, `` <esc> `` | Cancel |
| `` <up> ``, `` <C-p> ``, `` <S-tab> ``; `` <C-n> ``, `` <tab> ``, `` <down> `` | Move up / down |
| `` <C-u> ``, `` <pageup> ``; `` <C-d> ``, `` <pagedown> `` | Page up / down |

### Popup

| Shortcut | Use |
| --- | --- |
| `` <C-c> ``, `` <esc> `` | Cancel |
| `` <C-u> ``, `` <pageup> ``; `` <C-d> ``, `` <pagedown> `` | Scroll up / down |

### Hover

| Shortcut | Use |
| --- | --- |
| `` <A-p> ``; `` <A-n> `` | Previous / next |

### Signature-help popup

| Shortcut | Use |
| --- | --- |
| `` <A-p> ``; `` <A-n> `` | Previous / next |

### Blame

| Shortcut | Use |
| --- | --- |
| `` y `` | Copy commit id |
| `` Y `` | Copy message |

### Diff popup

| Shortcut | Use |
| --- | --- |
| `` <left> ``; `` <right> `` | Scroll left / right |

Buffer picker uses the general picker controls above. Specialized picker tables list only additional controls.

---

[Configuration](../home/modules/common/helix.nix) · [Source](/home/alohahenry/git/mitos/crates/term/src/keymap/default.rs) · Checked 2026-11-15 · [Index](shortcuts.md) · [Find by task](task-index.md)
