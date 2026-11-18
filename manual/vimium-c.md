# Vimium C

Vimium C 2.12.2 · Helix/Mitos layout. This guide describes the local export, which must be imported manually; it has not been applied to the browser. Import `/etc/nixos/home/vimium/config.json` through Vimium C's options page. No NixOS rebuild is required.

`j k l ;` = left/down/up/right. `→` means press in sequence; uppercase letters include Shift. Space is left to the webpage; there is no Space prefix. Keys below are the keys received by the browser after [keyd](keyd.md) remapping. Page shortcuts work outside editable text fields on pages where Vimium can run. The export clears normal-mode defaults; Visual/Caret mode retains its own defaults with the overrides below.

## On this page

[Links, input and copying](#links-input-and-copying) · [Tabs and bookmarks](#tabs-and-bookmarks) · [Move around the page](#move-around-the-page) · [Navigation and page controls](#navigation-and-page-controls)

[Find text](#find-text) · [Select webpage text](#select-webpage-text) · [Video and typing sites](#video-and-typing-sites) · [Useful sequences](#useful-sequences)

## Links, input and copying

The URL/search chooser has two configured search engines: `ddg query` searches DuckDuckGo; `g query` searches Google. The default search URL is unchanged.

| Shortcut | Use |
| --- | --- |
| `f`; `F` | Open a link in the current / new tab |
| `g → w` | Select text using hints |
| `g → i` | Focus a visible input; use Tab to cycle inputs |
| `y`; `Y` | Copy selected text / current page URL |
| `o`; `O` | Open the URL/search chooser for the current / new tab |

## Tabs and bookmarks

| Shortcut | Use |
| --- | --- |
| `d` | Close the current tab, including on video sites; Chromium's Ctrl+w also works |
| `u` | Restore a closed tab |
| `g → p`; `g → n` | Previous / next tab |
| `g → a` | Return to the last visited tab |
| `<`; `>` | Move tab to the left / right |
| `t` | Search open tabs |
| `b` | Search bookmarks and open in a new tab |

## Move around the page

| Shortcut | Use |
| --- | --- |
| `j k l ;` / `Left Down Up Right` | Scroll left/down/up/right; arrows pass through on video sites |
| `Ctrl+u`; `Ctrl+d` | Scroll half a page up / down |
| `PageUp`; `PageDown` | Scroll a full page up / down |
| `g → g`; `g → e` | Scroll to the top / bottom of the page |

## Navigation and page controls

| Shortcut | Use |
| --- | --- |
| `r` | Reload current frame |
| `Ctrl+p` | Pass the next key to the page |
| `i`; `Esc` | Enter passthrough (Insert) mode / leave it |
| `g → f` | Cycle forward to the next frame on the page |
| `[ → [`; `] → ]` | Follow the previous / next page link |
| `Ctrl+o`; `Ctrl+i` | Back / forward in browser history |
| `g → ?` | Show help |

## Find text

| Shortcut | Use |
| --- | --- |
| `/`; `?` | Search forward / backward |
| `n`; `N` | Next / previous find match |
| `*` | Search forward for selected text |

## Select webpage text

Start with `g → w` and a text hint, or find text with `/`. Press `v` to enter Visual mode. Movement extends the selection in Visual mode and moves the caret in Caret mode.

| Shortcut | Use |
| --- | --- |
| `v` | Enter Visual mode; from Caret mode, resume extending the selection |
| `j k l ;` | Left/down/up/right in Visual/Caret mode |
| `w`; `b`; `e` | Next word start / previous word start / next word end |
| `h` | Switch to Caret mode and collapse the selection |
| `Alt+h` | Swap selection anchor and moving end |
| `x` | Enter line selection mode |
| `y` | Copy the selection and leave Visual mode |
| `Esc` | Leave Visual/Caret mode |

These are browser text selections: the custom Helix `w` macro, repeated `x/X`, text objects and multiple selections are not reproduced. Visual/Caret mode keeps upstream commands such as `gg` / `G` for document start/end and `0` / `$` for line start/end.

## Video and typing sites

On `www.bilibili.com` and `www.youtube.com`, Space and the four arrows pass through to the page so the player can use them. Player behavior still depends on focus. The same direct shortcuts work here: `d` closes a tab, with `t`, `o/O`, `b`, `y/Y` and `g?` for the other actions. Chromium's Ctrl+w also closes tabs, including while typing or in passthrough mode. For other player shortcuts, use `Ctrl+p → key`, or `i → player keys → Esc`.

Vimium is disabled on `www.typing.com` and `codingspeedtest.com`. Importing this export also imports these site rules.

## Useful sequences

| Shortcut | Use |
| --- | --- |
| `f → displayed hint` | Open a link here |
| `F → displayed hint → g → n` | Open a link in a new tab and move to the next tab |
| `/ → query → Enter → n / N` | Find text, then next / previous match |
| `t → tab title → Enter` | Switch to an existing tab |
| `b → bookmark → Enter` | Open a bookmark in a new tab |
| `gi → type → Esc` | Focus an input; leave it before using page shortcuts |
| `Ctrl+P → key` | Send the next key directly to the page |
| `d → u` | Close and restore a tab, including on video sites |
| `gw → hint → v → movement → y` | Select and copy webpage text |
| `Y → switch app → paste` | Share the current URL |

Esc cancels an active hint/search/chooser. On restricted browser pages or when a browser shortcut takes precedence, use Chromium's native shortcuts. Commands were checked against the installed extension; the new mappings have not been interactively tested.

---

[Saved export](../home/vimium/config.json) · [Extension installation](../configuration.nix) · [Per-mode mapping reference](https://github.com/gdh1995/vimium-c/wiki/Use-in-another-keyboard-layout#per-mode-mapkey) · Updated 2026-11-16 · [Index](shortcuts.md) · [Find by task](task-index.md)
