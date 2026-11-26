# Fish

Fish 4.9.3 · Keys act at the shell prompt. Foreground programs handle their own keys. `Alt+U` deletes back to line start in your layout.

## On this page

| Task | 用途检索 |
| --- | --- |
| [Copy and restore text](#copy-and-restore-text) | 复制、恢复文本 |
| [Move through text and directories](#move-through-text-and-directories) | 移动、目录历史 |
| [History and completion](#history-and-completion) | 历史、补全 |
| [Inspect, cancel and use tools](#inspect-cancel-and-use-tools) | 帮助、取消 |
| [Edit the command line](#edit-the-command-line) | 编辑、撤销 |
| [Enter text and run commands](#enter-text-and-run-commands) | 输入、执行 |
| [Abbreviations and typed helpers](#abbreviations-and-typed-helpers) | 缩写、辅助命令 |
| [Useful sequences](#useful-sequences) | 组合用法 |

## Copy and restore text

| Shortcut | Use |
| --- | --- |
| `Ctrl+y` | Reinsert the most recently killed text |
| `Alt+y` | After yank, cycle through earlier killed text |
| `Ctrl+x` | Copy command line/selection to system clipboard |
| `Ctrl+v` | Paste system clipboard |

## Move through text and directories

| Shortcut | Use |
| --- | --- |
| `Left` / `Ctrl+b`; `Right` / `Ctrl+f` | Move left / right; at input end, Right accepts the autosuggestion |
| `Ctrl+Left`; `Ctrl+Right` | Move backward / forward by shell token |
| `Shift+Left`; `Shift+Right` | Move backward / forward by whitespace-delimited word |
| `Alt+b` / `Alt+Left`; `Alt+f` / `Alt+Right` | Empty line: previous / next directory; otherwise previous / next word |
| `Home` / `Ctrl+a`; `End` / `Ctrl+e` | Line start / end; at input end, End accepts the autosuggestion |
| `Alt+<`; `Alt+>` | Go to beginning / end of multiline input |

## History and completion

| Shortcut | Use |
| --- | --- |
| `PageUp`; `PageDown` | First / last matching history entry |
| `Tab` / `Ctrl+i` | Complete the current token |
| `Ctrl+s` | Toggle completion-pager search |
| `Shift+Tab` | Complete and immediately search the completion pager |
| `Shift+Delete` | Delete the selected history entry; otherwise delete previous character |
| `Up` / `Ctrl+p`; `Down` / `Ctrl+n` | Previous / next history entry; up / down in multiline input |
| `Alt+Up` / `Alt+.`; `Alt+Down` | Earlier / later history argument |
| `Shift+Enter` / `Alt+Enter` | Insert a newline without executing; expand abbreviations |
| `Ctrl+Space` | Insert a literal space on a nonempty command line, without expanding abbreviations |
| `Shift+Space` | Insert a space and expand abbreviations |
| `Ctrl+r` | Open searchable command history |

## Inspect, cancel and use tools

| Shortcut | Use |
| --- | --- |
| `Esc` / `Ctrl+[` / `Ctrl+g` | Cancel the current completion/search operation |
| `Alt+l` | List files for the token under the cursor |
| `Alt+o` | Preview the file named by the current token |
| `Alt+w` | Show a short description of the current command/token |
| `Ctrl+l` | Push screen into scrollback when supported, then clear screen |
| `Alt+s` | Prepend the first installed privilege command: sudo, doas, please or run0 |
| `F1` / `Alt+h` | Open the current command manual |
| `Alt+p` | Append a pager to the command line |
| `Alt+#` | Toggle a comment on the command line |
| `Alt+e` / `Alt+v` | Edit the command in the external editor (ms here) |

## Edit the command line

| Shortcut | Use |
| --- | --- |
| `Ctrl+c` | Clear current command line |
| `Ctrl+u` / `Alt+u`; `Ctrl+k` | Kill to line start / end (Alt+U is locally remapped to line start) |
| `Ctrl+w` | Kill previous path component |
| `Alt+d` | Empty line: show directory history; otherwise kill next word |
| `Ctrl+d` | Delete at cursor; exit only when command line is empty |
| `Delete` | Delete character under cursor |
| `Backspace` / `Shift+Backspace` / `Ctrl+h` | Delete previous character |
| `Ctrl+t` | Swap adjacent characters |
| `Ctrl+/` / `Ctrl+_` / `Ctrl+z`; `Ctrl+Shift+z` / `Alt+/` | Undo / redo command-line editing |
| `Alt+t` | Swap adjacent words |
| `Alt+c` | Capitalize the current word |
| `Alt+Backspace` / `Ctrl+Alt+h`; `Alt+Delete` | Kill previous / next word |
| `Ctrl+Backspace`; `Ctrl+Delete` | Kill previous / next shell token |

## Enter text and run commands

| Shortcut | Use |
| --- | --- |
| `any other text` / `Space` / `;` / `\|` / `&` / `>` / `<` / `)` | Insert text; listed separators also expand abbreviations |
| `Enter` / `Ctrl+j` / `Ctrl+m` / `Ctrl+Enter` | Execute command (or accept the active pager selection) |

## Abbreviations and typed helpers


Abbreviations expand when followed by a space. These are typed commands, not simultaneous key chords.

| Input | Expansion / effect |
| --- | --- |
| `ls`, `la`, `ll` | `eza`, `eza -a`, `eza -al` |
| `cd` | `z` (zoxide) |
| `grep` | `rg` |
| `ove` | `ov --exec --` |
| `ns` | `nix-shell --run fish` |
| `ur` | `uv run` |
| `jlog` | `journalctl -b -x --all --no-pager` |
| `rm` | `trash-put` |
| `cr`, `co` | `codex resume`, `codex` |
| `add` | `nix shell nixpkgs#`, with cursor at the package name |
| `dis` | ` & disown`, with cursor before the command suffix |
| `nix-clean` | Garbage-collect user and root Nix stores; also vacuum the journal to 300 MB on Linux |
| `y` | Open Yazi and change Fish's directory to the directory selected on exit |
| `mkcd DIR` | Create a directory and enter it |
| `manrg COMMAND PATTERN` | Search a man page with three lines of context |
| `bd` | Rebuild/switch the current Linux host, or switch `macbook` from `~/my-nix` on Darwin |
| `bd-debug` | Rebuild/switch `asahi-debug` with `--impure` (Asahi only) |


For [directory jumping, clipboard, trash recovery and command examples](utilities.md), use the smaller-tool guide. For long output, use [ov](ov.md).

## Useful sequences

| Shortcut | Use |
| --- | --- |
| `Ctrl+R → words → choose a result` | Find a previous command |
| `command → Alt+.` | Reuse an earlier argument; repeat to browse |
| `path prefix → Tab → Shift+Tab` | Complete and filter possible paths |
| `Alt+U → replacement text` | Replace the command prefix; Ctrl+Y restores killed text |
| `Alt+Enter` | Add another line without running the command |
| `Alt+E → edit in ms → save and quit` | Return the edited command to Fish |
| `Alt+Left / Alt+Right` on an empty line | Move through directory history |
| `add → Space → jq → Enter` | Start a Nix shell with jq |
| `dis → Space → program → Enter` | Run the inserted program with `& disown` |
| `y → choose directory → q` | Return from Yazi with Fish in that directory |

Niri intercepts F1 for screenshots; use Alt+H for command help.

---

[Configuration](../home/modules/common/fish.nix) · [Fish input guide](https://fishshell.com/docs/current/interactive.html#shared-bindings) · Checked 2026-11-15 · [Index](shortcuts.md) · [Find by task](task-index.md)
