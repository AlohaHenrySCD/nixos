{ pkgs, theme, ... }:
{
  xdg.configFile."kitty/Everforest.conf".text = theme.render ./kitty-everforest.conf;
  programs.kitty = {
    shellIntegration.mode = "no-rc no-cursor";
    enable = true;
    # mouse_map = "mouse_map left release ungrabbed mouse_handle_click selection link";
    keybindings = {
      "alt+r" = "show_scrollback";
      "ctrl+shift+d" = "remote_control scroll-window 0.5p";
      "ctrl+shift+u" = "remote_control scroll-window 0.5p-";
      "ctrl+shift+q" = "no_op";
      "ctrl+shift+enter" = "no_op";
    };
    settings = {
      shell = "${pkgs.fish}/bin/fish";

      confirm_os_window_close = 0;
      restore_session_after_logout = true;
      include = "Everforest.conf";
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      # hide_window_decorations = "titlebar-only";
      window_padding_width = 10;

      cursor_trail = 1;
      cursor_trail_decay = "0.05 0.4";
      cursor_trail_start_threshold = 0;
      cursor_blink_interval = "0.5 ease-in-out";

      scrollback_pager = "${pkgs.fish}/bin/fish --no-config -c 'ms -c ~/.config/mitos/scrollback.toml + (ansifilter --ignore-csi | psub -f)'";
    }
    // theme.fonts.kitty;
  };
}
