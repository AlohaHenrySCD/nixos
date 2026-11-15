# Small terminal tools and helpers

Search words: find files, grep, clipboard, trash, restore, jump directory, examples / 找文件、搜索内容、剪贴板、回收站、恢复、跳目录、命令示例。

## On this page

[Find files and text](#find-files-and-text) · [List and inspect files](#list-and-inspect-files) · [Jump between directories — zoxide](#jump-between-directories--zoxide) · [Copy terminal data — wl-clipboard](#copy-terminal-data--wl-clipboard)

[Trash and recovery](#trash-and-recovery) · [Command examples](#command-examples) · [Read Markdown and monitor work](#read-markdown-and-monitor-work)

## Find files and text

| Entry | Use |
| --- | --- |
| `rg -n 'pattern' PATH` | Search file contents and show line numbers |
| `rg -ni -F -- 'literal text' PATH` | Case-insensitive literal search; symbols such as `+` are not treated as regex |
| `rg --files PATH` | List searchable files |
| `rg -l 'pattern' PATH` | Show matching filenames only |
| `rg -n -C 3 'pattern' PATH` | Include three lines of context |
| `rg --hidden -g '!.git' 'pattern' PATH` | Include hidden files, excluding .git |
| `fd 'name' PATH` | Find names rather than contents |
| `fd -t d 'name' PATH` | Find directories |
| `fd -e pdf . PATH` | Find PDFs |
| `fd -H -I 'name' PATH` | Include hidden and ignored names |

**Find then inspect:** `rg -n 'pattern' PATH` → open the matching file in `ms`. **Choose a file:** `rg --files PATH | fzf`. Search tools normally honor ignore rules; use the explicit hidden/ignored options when needed.

## List and inspect files

| Entry | Use |
| --- | --- |
| `ls / la / ll` in Fish | eza normal / hidden / long listing |
| `eza --tree --level=2 PATH` | Shallow directory tree |
| `bat --paging=never -- FILE` | Syntax-highlighted file contents without a pager |
| `bat --line-range 20:60 -- FILE` | Inspect a line range |
| `file -- FILE` | Identify a file's format |
| `jq . FILE.json` | Format and inspect JSON |
| `jq -r '.name' FILE.json` | Print a JSON field without JSON quotes |
| `pdftotext -layout FILE.pdf -` | Read PDF text in the terminal |
| `pdfinfo FILE.pdf` | Inspect PDF page count and metadata |

For long output use [ov](ov.md). For interactive file operations use [Yazi](yazi.md) or [Broot](broot.md).

## Jump between directories — zoxide

| Entry | Use |
| --- | --- |
| `z project` | Jump to a previously visited matching directory |
| `z parent child` | Match several path fragments |
| `zi project` | Choose interactively using fzf |
| `zoxide query -l project` | List known matches without changing directory |
| `cd` + Space in Fish | Expand the abbreviation to z |
| `builtin cd PATH` | Use Fish's ordinary directory change explicitly |
| `mkcd DIR` | Create a directory and enter it |
| `y` → navigate → `q` | Use Yazi to choose Fish's next directory |

**Pick among similarly named projects:** `zi project → narrow query → Enter`. zoxide learns visited directories; it is not a filesystem-wide search.

## Copy terminal data — wl-clipboard

| Entry | Use |
| --- | --- |
| `command \| wl-copy` | Copy stdout to Wayland clipboard |
| `wl-copy < FILE` | Copy a file's contents |
| `wl-paste --no-newline` | Print clipboard text without adding a newline |
| `wl-paste --primary --no-newline` | Read primary selection instead of clipboard |
| `wl-paste > FILE` | Save clipboard to a file; overwrites FILE |

**Copy search results:** `rg -n 'pattern' PATH | wl-copy`. Primary selection and clipboard are different; this matters for [GoldenDict](desktop-tools.md#look-up-a-word--goldendict) and middle-click paste.

## Trash and recovery

| Entry | Use |
| --- | --- |
| `trash-put -- FILE` | Move a file to trash |
| `rm` + Space in Fish | Expand to trash-put |
| `trash-list` | List trashed items |
| `trash-restore` | Choose an item to restore from the current directory's trash entries |
| `trash-restore PATH` | Choose entries for the specified path |
| `trash-restore /` | Search restore candidates across paths |
| `trash-empty` | Permanently empty trash |
| `trash-empty 30` | Permanently remove items older than 30 days |

**Recover a deletion:** `trash-list → trash-restore PATH → choose item`. The Fish abbreviation only affects interactive typing. Yazi's `D`, Broot's `:rm`, and scripts can still delete permanently.

## Command examples

| Entry | Use |
| --- | --- |
| `tldr COMMAND` | Show practical examples; the installed client is tlrc |
| `tldr -o COMMAND` | Use cached examples without updating |
| `tldr -s KEYWORD` | Search available example pages |
| `man COMMAND` | Read the full manual |
| `manrg COMMAND PATTERN` | Search a manual with three lines of context |
| `navi --print` | Choose a command snippet and print it for review |
| `navi --print --query 'topic'` | Start with a search term |
| `navi --tldr COMMAND --print` | Search tldr-based snippets |
| `navi` | Choose and execute a snippet after filling its variables |

navi's chooser uses [fzf controls](fzf.md). No Fish navi shortcut widget is configured. Prefer `--print` when looking up usage rather than running a snippet.

## Read Markdown and monitor work

| Entry | Use |
| --- | --- |
| `glow /etc/nixos/manual` | Browse this manual directory |
| `glow -p /etc/nixos/manual/kitty.md` | Read one guide through a pager |
| `glow -s ascii FILE.md` | Render without colored styling |
| `btop` | Inspect CPU, memory and processes; also available by clicking Waybar's system metrics |
| `btop --filter NAME` | Start with a process filter |
| `lazygit --path REPO` | Open Git's terminal interface in a repository |
| `lazygit log` | Start focused on commit history |
| `jlog` in Fish | Show the current boot's journal |
| `jlog \| rg 'pattern'` | Filter current boot logs |
| `jlog \| ov` | Browse logs interactively |

**Read logs without losing your prompt:** `jlog | ov → / → pattern → Enter → n → q`. To inspect older terminal output instead, use [Kitty scrollback](kitty.md#review-terminal-output).


---

[Packages](../home/modules/common/packages.nix) · [Fish helpers](../home/modules/common/fish.nix) · [zoxide integration](../home/home.nix) · installed command help; all examples use Fish-compatible syntax · Checked 2026-11-15 · [Index](shortcuts.md) · [Find by task](task-index.md)
