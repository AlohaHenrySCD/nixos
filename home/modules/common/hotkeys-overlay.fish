# Searchable reference for configured Kitty/Fish shortcuts, abbreviations and aliases.
# --list prints the same entries without opening fzf (useful for inspection).

# This overlay runs before Fish's first prompt, when full bindings may still be lazy.
if set -q fish_key_bindings
    $fish_key_bindings
else
    fish_default_key_bindings
end
if functions -q fish_user_key_bindings
    fish_user_key_bindings
end

function __hotkeys_entries
    printf '\e[1;36m━━ KITTY：默认 + 当前配置（已覆盖的旧绑定不显示）━━\e[0m\n'
    kitty +runpy '
import os
from kitty.config import load_config
from kitty.constants import config_dir
from kitty.types import Shortcut

help_text = {
    "copy_to_clipboard": "复制到剪贴板",
    "paste_from_clipboard": "粘贴剪贴板",
    "paste_from_selection": "粘贴主选择区",
    "pass_selection_to_program": "把选中文本交给程序",
    "copy_or_interrupt": "有选区时复制，否则中断程序",
    "show_scrollback": "查看滚屏记录（当前配置使用 Helix）",
    "show_last_command_output": "查看上一条命令输出",
    "scroll_line_up": "向上滚动一行", "scroll_line_down": "向下滚动一行",
    "scroll_page_up": "向上翻页", "scroll_page_down": "向下翻页",
    "scroll_home": "滚动到顶部", "scroll_end": "滚动到底部",
    "scroll_to_prompt": "跳转到前后命令提示符",
    "new_window": "新建终端分屏", "new_os_window": "新建独立终端窗口",
    "close_window": "关闭终端分屏", "next_window": "下一个分屏",
    "previous_window": "上一个分屏", "nth_window": "跳转到指定分屏",
    "move_window_forward": "向前移动分屏", "move_window_backward": "向后移动分屏",
    "move_window_to_top": "把分屏移到首位", "start_resizing_window": "调整分屏大小",
    "focus_visible_window": "选择并聚焦可见分屏", "swap_with_window": "选择分屏交换位置",
    "new_tab": "新建标签页", "close_tab": "关闭标签页",
    "next_tab": "下一个标签页", "previous_tab": "上一个标签页",
    "goto_tab": "跳转到指定标签页", "set_tab_title": "修改标签页标题",
    "move_tab_forward": "向前移动标签页", "move_tab_backward": "向后移动标签页",
    "next_layout": "切换布局", "goto_layout": "切换到指定布局",
    "change_font_size": "调整字体大小", "toggle_fullscreen": "切换全屏",
    "toggle_maximized": "切换最大化", "open_url_with_hints": "选择并打开链接",
    "kitten": "运行 Kitten 工具", "launch": "启动程序/浮层",
    "load_config_file": "重新加载 Kitty 配置", "debug_config": "查看配置诊断",
    "edit_config_file": "编辑 Kitty 配置", "show_kitty_doc": "打开 Kitty 文档",
    "command_palette": "打开命令面板", "clear_terminal": "清理/重置终端",
    "kitty_shell": "打开 Kitty 远程控制命令行",
    "set_background_opacity": "调整背景透明度",
    "no_op": "已禁用", "no-op": "已禁用",
}
opts = load_config(os.path.join(config_dir, "kitty.conf"))
for index, ordinal in enumerate(("first", "second", "third", "fourth", "fifth",
                                 "sixth", "seventh", "eighth", "ninth", "tenth"), 1):
    help_text[ordinal + "_window"] = f"跳转到第 {index} 个分屏"
for mode, km in opts.keyboard_modes.items():
    effective = {}
    for definitions in km.keymap.values():
        for definition in definitions:
            effective[definition.unique_identity_within_keymap] = definition
    for definition in effective.values():
        keys = Shortcut(definition.full_key_sequence_to_trigger).human_repr().replace("kitty_mod+", "")
        action = definition.definition or "no_op"
        description = help_text.get(action.split()[0], "")
        if "hotkeys-overlay.fish" in action:
            description = "打开快捷键搜索浮层"
        elif "fcitx5-remote -c" in action:
            description = "发送 Esc 并关闭输入法"
        scope = f"/{mode}" if mode else ""
        condition = definition.options.when_focus_on
        detail = f" [{condition}]" if condition else ""
        print(f"Kitty{scope} | {keys} | {description}{detail} | {action}")
'
    or printf 'Kitty | 无法读取配置；请用 Kitty 命令面板中的 debug_config 检查\n'

    printf '\n\e[1;36m━━ FISH：当前模式的默认绑定 + 用户覆盖 ━━\e[0m\n'
    printf '说明 | Kitty 先处理快捷键；已被 Kitty 拦截的按键不会交给 Fish\n'
    printf '说明 | --preset 为默认绑定；同模式、同按键的用户绑定优先\n'
    for mode in (bind -L)
        for binding in (bind --preset -M $mode 2>/dev/null)
            if string match -q 'bind *' -- $binding
                printf 'Fish/%s 默认 | %s\n' $mode $binding
            end
        end
        for binding in (bind --user -M $mode 2>/dev/null)
            if string match -q 'bind *' -- $binding
                printf 'Fish/%s 用户 | %s\n' $mode $binding
            end
        end
    end

    printf '\n\e[1;36m━━ FISH 动作说明（可搜索中文或动作名）━━\e[0m\n'
    printf '%s\n' \
        'Fish 动作 | complete / complete-and-search | 补全 / 补全并搜索' \
        'Fish 动作 | up-or-search / down-or-search | 按当前输入搜索上一条/下一条历史' \
        'Fish 动作 | history-pager | 打开历史命令搜索面板' \
        'Fish 动作 | forward-char / forward-word | 向右移动；在末尾接受建议/部分建议' \
        'Fish 动作 | end-of-line | 移到行尾；在行尾接受自动建议' \
        'Fish 动作 | beginning-of-line | 移到行首' \
        'Fish 动作 | backward-kill-word / kill-word | 删除前一个/后一个词' \
        'Fish 动作 | backward-kill-line / kill-line | 删除到行首/行尾' \
        'Fish 动作 | yank / yank-pop | 恢复剪切内容 / 轮换剪切记录' \
        'Fish 动作 | undo / redo | 撤销 / 重做编辑' \
        'Fish 动作 | history-token-search-backward | 从历史命令搜索参数' \
        'Fish 动作 | prevd-or-backward-word / nextd-or-forward-word | 空命令行切换目录历史，否则按词移动' \
        'Fish 动作 | fish_clipboard_copy / fish_clipboard_paste | 复制 / 粘贴系统剪贴板' \
        'Fish 动作 | edit_command_buffer | 用编辑器编辑当前命令' \
        'Fish 动作 | clear-commandline / cancel-commandline | 清空 / 取消当前命令' \
        'Fish 动作 | clear-screen | 清屏' \
        'Fish 动作 | exit | 退出 Shell（通常要求命令行为空）'

    printf '\n\e[1;36m━━ FISH 缩写：输入后按空格展开 ━━\e[0m\n'
    for entry in (abbr --show)
        printf '缩写 | %s\n' $entry
    end
    printf '\n\e[1;36m━━ FISH 别名 ━━\e[0m\n'
    for entry in (alias)
        printf '别名 | %s\n' $entry
    end
    printf '\n\e[1;36m━━ 本地辅助函数 ━━\e[0m\n'
    for entry in 'mkcd|创建目录并进入' 'manrg|搜索 man 页面，显示上下文' 'fd|按名称递归查找文件（本地 Fish 函数）'
        set -l parts (string split '|' -- $entry)
        if functions -q $parts[1]
            printf '函数 | %s | %s\n' $parts[1] $parts[2]
        end
    end
end

if contains -- --list $argv
    __hotkeys_entries
else
    __hotkeys_entries | fzf \
        --ansi \
        --no-sort \
        --layout=reverse \
        --border \
        --prompt='快捷键 > ' \
        --header='输入关键词搜索 · Ctrl+U 清空搜索 · Esc 关闭 · 仅查阅，不执行条目' \
        --info=inline >/dev/null
end
functions -e __hotkeys_entries
