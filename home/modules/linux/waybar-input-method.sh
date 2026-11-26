state=$(fcitx5-remote --check 2>/dev/null || true)
name=$(fcitx5-remote --check -n 2>/dev/null || true)

case "$state" in
  1) text="EN"; class="inactive" ;;
  2)
    class="active"
    case "$name" in
      rime) text="中" ;;
      mozc) text="あ" ;;
      keyboard-*) text="EN"; class="inactive" ;;
      *) text="$name" ;;
    esac
    ;;
  *) text="IME"; class="offline" ;;
esac

jq -cn \
  --arg text "$text" \
  --arg class "$class" \
  --arg tooltip "Fcitx5: $name" \
  '{text: $text, class: $class, tooltip: $tooltip}'
