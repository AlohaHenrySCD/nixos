# keyd — physical keys

The Asahi host selects the shared layout with `my.keyd.keymapIds` for device `05ac:0342:89b7fedc`. The default device group excludes `1d50:615e` (pskeeb5, which has its own ZMK layout); it also explicitly includes the three mouse IDs listed in the source.

## On this page

[Main layer](#main-layer) · [Navigation layer](#navigation-layer) · [Number and function-key layer](#number-and-function-key-layer) · [Symbol layer](#symbol-layer)

[Useful sequences](#useful-sequences)

## Main layer

All keys in this section are **physical** keys.

| Physical key | Output / action |
| --- | --- |
| `1`, `2` | `Ctrl+Shift+C`, `Ctrl+Shift+V` (terminal copy/paste) |
| `3`, `4`, `5` | `Ctrl+C`, `Ctrl+V`, `Ctrl+X` |
| `6`, `7` | Brightness down / up |
| `8`, `9`, `0` | Mute / volume down / volume up |
| Caps Lock | Backspace |
| Backspace | `Ctrl+Shift+F12` (Fcitx5 toggle) |
| Esc, Left Meta | Esc |
| Left Shift | Delete |
| Left Alt | Caps Lock |
| Left Ctrl | Hold the `num` layer |
| Right Meta | Hold the `plain` layer |
| Right Alt | Hold the `nav` layer |
| Mouse back / forward button | Hold Ctrl / Meta (default device group) |

These home-row keys use `overloadt(..., 130)`: tap for the character, hold for the modifier/layer, with a 130 ms timeout.

| Physical key | Hold action |
| --- | --- |
| `a` | Alt |
| `s`, `l` | Meta / Super |
| `d`, `k` | Shift |
| `f` | `nav` layer |
| `j` | `num` layer |
| `;` | AltGr |
| `v`, `m` | Ctrl |
| `c`, `,` | `symbol` layer |

The `plain` layer restores literal letters, number-row digits and the listed punctuation keys while held. It does not restore every physical modifier key.

## Navigation layer

Hold Right Alt or hold `f` long enough to activate the layer.

| Physical keys | Outputs in the same order |
| --- | --- |
| `j k l ;` | Left, Down, Up, Right arrows |
| `s d` | Page Up, Page Down |
| `m /` | Home, End |
| `w e` | `Ctrl+Shift+U`, `Ctrl+Shift+D` (Kitty half-page scroll) |
| `x c` | `Ctrl+U`, `Ctrl+D` (application-dependent) |
| `u i o p` | Literal `h j k l`, for applications using conventional Vim directions |

Disabled navigation positions: `q r t y a f g h z v b n , .`.

## Number and function-key layer

Hold Left Ctrl or hold `j` long enough to activate the layer.

| Physical keys | Outputs in the same order |
| --- | --- |
| `w e r` | `9 8 7` |
| `a s d f` | `3 2 1 0` |
| `x c v` | `6 5 4` |
| `k l ;` | F1, F2, F3 |
| `, . /` | F4, F5, F6 |
| `i o p` | F7, F8, F9 |
| `g b t` | F10, F11, F12 |

Disabled number-layer positions: `q y u h j z n m`.

## Symbol layer

Hold `c` or `,` long enough to activate the layer. Use the opposite layer key when you need the symbol at its own position.

| Physical keys | Outputs in the same order |
| --- | --- |
| `q w e r t` | Backtick, `<`, `>`, `-`, `$` |
| `y u i o p` | `^`, `{`, `}`, vertical bar, `'` |
| `a s d f g` | `!`, `:`, `_`, `=`, `&` |
| `h j k l ;` | `#`, `(`, `)`, `"`, `;` |
| `z x c v b` | `~`, `?`, `[`, `]`, `+` |
| `n m , . /` | Backslash, `*`, `,`, `.`, `/` |
| Left Alt, Right Alt | `%`, `@` |

In **all three** layers (`nav`, `num`, `symbol`), physical `1…0` become: brightness down, brightness up, previous track, play/pause, next track, Sleep, no action, mute, volume down, volume up. The Sleep output has no explicit Niri binding in this repository.

## Useful sequences

| Shortcut | Use |
| --- | --- |
| `1 → switch app → 2` | Copy/paste terminal text; ordinary GUI copy/paste uses physical 3/4 |
| `hold Right Alt + w / e` | Scroll Kitty history up/down |
| `hold Left Ctrl + l / k` | Screenshot selector / screen screenshot |
| `hold Right Meta + number row` | Type literal digits |
| `hold s + t` | Super+T: open Kitty |
| `hold , + c / v` | Type [ / ] |
| `physical Backspace → type pinyin` | Toggle Fcitx5 and compose text |
| `physical Caps Lock` | Delete the previous character |

Unlisted keys keep their inherited behavior. In the plain layer letters, digits and the listed punctuation are literal; the physical modifier keys are not all restored. The other keyboard/mouse group changes only mouse back/forward into held Ctrl/Super.

---

[Asahi device selection](../hosts/asahi/default.nix) · [Shared keymap and mouse rules](../modules/keyd.nix) · Checked 2026-11-15 · [Index](shortcuts.md) · [Find by task](task-index.md)
