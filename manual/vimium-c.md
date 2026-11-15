# Vimium C

The installed extension is 2.12.2. These are all keys in your saved export; automatic import of that export is not configured. It clears the normal-mode defaults, so unlisted upstream normal shortcuts are unavailable after import. Keys act on the page, outside editable text fields.

## On this page

[Links, input and copying](#links-input-and-copying) · [Tabs and bookmarks](#tabs-and-bookmarks) · [Move around the page](#move-around-the-page) · [Navigation and page controls](#navigation-and-page-controls)

[Find text](#find-text) · [Useful sequences](#useful-sequences)

## Links, input and copying

| Shortcut | Use |
| --- | --- |
| `f` | Open a link in the current tab |
| `g → w` | Select text using hints |
| `g → i` | Focus the N-th visible text box on the page and cycle using tab |
| `y` | Copy page's info |
| `c` | Copy selected text automatically |

## Tabs and bookmarks

| Shortcut | Use |
| --- | --- |
| `F` | Open a link in a new tab |
| `d` | Close N tabs |
| `D` | Restore closed tabs |
| `Ctrl+q`; `Ctrl+e` | Go one tab left / right |
| `<`; `>` | Move tab to the left / right |
| `t` | Search open tabs |
| `b` | Search bookmarks and open in a new tab |

## Move around the page

| Shortcut | Use |
| --- | --- |
| `j`; `k`; `l`; `;` | Scroll left / down / up / right |
| `Ctrl+u`; `Ctrl+d` | Scroll a page up / down |
| `g → g`; `g → e` | Scroll to the top / bottom of the page |

## Navigation and page controls

| Shortcut | Use |
| --- | --- |
| `r` | Reload current frame |
| `Ctrl+p` | Pass the next keys to the page |
| `Ctrl+k` | Cycle forward to the next frame on the page |
| `[ → [`; `] → ]` | Follow the previous / next page link |
| `J`; `:` | Back / forward in browser history |
| `?` | Show help |
| `Ctrl+o` | Open URL |

## Find text

| Shortcut | Use |
| --- | --- |
| `p`; `n` | Previous / next find match |
| `/` | Enter find mode |

## Useful sequences

| Shortcut | Use |
| --- | --- |
| `f → displayed hint` | Open a link here |
| `F → displayed hint → Ctrl+E` | Open a link in a new tab and switch tabs |
| `/ → query → Enter → n / p` | Find text, then next / previous match |
| `t → tab title → Enter` | Switch to an existing tab |
| `b → bookmark → Enter` | Open a bookmark in a new tab |
| `gi → type → Esc` | Focus an input; leave it before using page shortcuts |
| `Ctrl+P → key` | Send the next key directly to the page |
| `d → D` | Close and restore a tab |
| `y → switch app → paste` | Share the current URL |

Esc cancels an active hint/search/chooser. For restricted browser pages, the extension may not receive keys. `Ctrl+O` is saved as an open-URL action without a URL argument; use `t`/`b` for the configured searchable choosers.

---

[Saved export](../home/vimium/config.json) · [Extension installation](../configuration.nix) · Checked 2026-11-15 · [Index](shortcuts.md) · [Find by task](task-index.md)
