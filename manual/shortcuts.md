# Shortcut and usage guides

**[Find by task · 按用途查找](task-index.md)** — search Chinese or English terms such as `分屏`, `历史命令`, `通知`, `trash`, or `clipboard`.

## Everyday tools

| Guide | Find help for |
| --- | --- |
| **[Kitty](kitty.md)** | Terminal panes, tabs, scrollback, clipboard, links, sessions |
| **[Fish](fish.md)** | Input editing, history, completion, abbreviations, typed helpers |
| **[Niri](niri.md)** | Windows, columns, workspaces, monitors, screenshots, media keys |
| [Helix](helix.md) | Movement, selection, search, editing, files, splits, code tools |
| [Mitos](mitos.md) | Editing, quicklists, spelling, Git, pickers, Kitty scrollback |

## Files, input and smaller helpers

| Guide | Find help for |
| --- | --- |
| [Desktop helpers](desktop-tools.md) | Fuzzel launcher, Waybar clicks, Mako notifications, GoldenDict |
| [Small terminal tools](utilities.md) | rg/fd, eza/bat/jq, zoxide, clipboard, trash recovery, tldr/navi, Glow, monitoring |
| [ov](ov.md) | Long output, logs, following, filtering, wrapping, columns |
| [fzf](fzf.md) | Fuzzy search, query syntax, result selection, query editing |
| [Yazi](yazi.md) | File navigation, selection, copying, previews, tabs, dialogs |
| [Broot](broot.md) | Tree search, panels, staging, file actions |
| [keyd](keyd.md) | Physical keys, held modifiers, navigation, numbers, symbols |
| [Fcitx5 / Rime](fcitx5-rime.md) | Language switching, candidates, composition, punctuation |
| [Vimium C](vimium-c.md) | Browser navigation, links, tabs, finding text |
| [Euporie](euporie.md) | Notebook cells, execution, text editing, output |

## Search the manual

Run these from any directory in Fish. Use `-F` for literal keys: `+` has a different meaning in a regular expression.

```fish
# Find a task in Chinese or English
rg -ni '通知|notification' /etc/nixos/manual
# Find an exact key chord, ignoring letter case
rg -ni -F -- 'Ctrl+Shift+P' /etc/nixos/manual
# Search one tool
rg -ni 'history|completion' /etc/nixos/manual/fish.md
# Browse guides or read one with a pager
glow /etc/nixos/manual
glow -p /etc/nixos/manual/kitty.md
```

Each guide has a section directory at the top. [The task index](task-index.md) links directly to those sections and includes a [same-key lookup](task-index.md#same-key-different-place--同键不同用途).

## Read the keys

- `Ctrl+C`: hold Ctrl and press C. `Space → f`: press Space, release, then f.
- A capital single letter includes Shift; `→` marks a sequence. Grouped keys and actions correspond in order: `Home`; `End` = start / end. Semicolons separate groups containing alternative keys. `1…9` means any digit in that range.
- Except in the keyd guide, keys are those received by the application **after remapping**. On the internal keyboard, hold `s` or `l` for Super; physical Left Meta sends Esc.
- Desktop and terminal shortcuts may intercept a key before the foreground app receives it. Modes and conflicts are noted where they matter.

## Common tasks across tools

| Task | Sequence |
| --- | --- |
| Inspect old terminal output | Kitty `Alt+R` → [Mitos](mitos.md) navigation → `Space → q` |
| Find errors in logs | Fish `jlog \| ov` → `/ → error → Enter → n` |
| Enter a project directory | Fish `y` → [Yazi](yazi.md) navigation → `q`; or `zi project` |
| Look up selected text | Select text → Niri `Mod+Ctrl+D` |
| Copy editor text to another app | Helix/Mitos selection → `Space → y` → paste in destination |
| Recover a dismissed notification | Fish `makoctl restore` |
| Recover a trashed file | Fish `trash-list` → `trash-restore PATH` → choose an item |
| Return to editor navigation | Esc; in Linux Kitty this also deactivates Fcitx5 |
| Save terminal sessions and log out | Niri `Mod+Shift+E` → **Save Kitty and log out** |

Versions and sources appear in each guide. Vimium describes the saved export; its browser import is unverified. Euporie has saved settings but no executable on PATH, so its default reference is explicitly versioned. Guides are checked against configuration and reference sources; every action has not been interactively exercised.
