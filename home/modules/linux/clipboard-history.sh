list_entries() {
  cliphist list 2>/dev/null || true
}

choose_entry() {
  local entries
  entries=$(list_entries)
  [[ -n "$entries" ]] || return 1
  fuzzel --dmenu --only-match --prompt "$1" <<< "$entries"
}

case "${1:-}" in
  pick)
    entry=$(choose_entry '剪贴板 > ') || exit 0
    file=$(mktemp --tmpdir="${XDG_RUNTIME_DIR:-/tmp}" clipboard-history.XXXXXXXXXX)
    trap 'rm -f -- "$file"' EXIT
    cliphist decode <<< "$entry" > "$file"
    wl-copy < "$file"
    ;;
  menu)
    action=$(printf '%s\n' 删除单条记录 清空全部历史 |
      fuzzel --dmenu --only-match --prompt '剪贴板管理 > ') || exit 0
    case "$action" in
      删除单条记录)
        entry=$(choose_entry '删除剪贴板 > ') || exit 0
        cliphist delete <<< "$entry"
        ;;
      清空全部历史)
        confirm=$(printf '%s\n' 取消 确认清空 |
          fuzzel --dmenu --only-match --prompt '确认清空剪贴板？ > ') || exit 0
        [[ "$confirm" == 确认清空 ]] || exit 0
        cliphist wipe
        ;;
      *) exit 0 ;;
    esac
    ;;
  status)
    count=$(list_entries | wc -l)
    jq -cn --argjson n "$count" '{
      text: (if $n == 0 then "󰅌" else "󰅌 \($n)" end),
      tooltip: "剪贴板历史 · \($n) 条\n左键选择 · 右键管理",
      class: (if $n == 0 then "empty" else "active" end)
    }'
    exit 0
    ;;
  *) echo 'Usage: clipboard-history {pick|menu|status}' >&2; exit 2 ;;
esac
pkill -RTMIN+9 -x waybar || true
