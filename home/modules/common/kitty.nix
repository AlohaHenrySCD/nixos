{ pkgs, ... }:
{
  xdg.configFile."kitty/Everforest.conf".source = ./Everforest.conf;
  xdg.configFile."kitty/hotkeys-overlay.fish".source = ./hotkeys-overlay.fish;
  programs.kitty = {
    shellIntegration.mode = "no-rc no-cursor";
    enable = true;
    # mouse_map = "mouse_map left release ungrabbed mouse_handle_click selection link";
    keybindings = {
      "ctrl+d" = "remote_control scroll-window 0.5p";
      "ctrl+u" = "remote_control scroll-window 0.5p-";
      "ctrl+shift+q" = "no_op";
      "ctrl+shift+enter" = "no_op";
      "ctrl+shift+/" =
        "launch --type=overlay --title=Hotkeys fish -i ~/.config/kitty/hotkeys-overlay.fish";
    };
    settings = {
      shell = "${pkgs.fish}/bin/fish";

      font_size = 13;
      confirm_os_window_close = 0;
      include = "Everforest.conf";
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      font_family = "JetBrainsMonoNL Nerd Font Mono";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # hide_window_decorations = "titlebar-only";
      window_padding_width = 10;
      remember_window_size = "yes";

      cursor_shape = "block";
      cursor_trail = 1;
      cursor_trail_decay = "0.05 0.4";
      cursor_trail_start_threshold = 0;
      cursor_blink_interval = "0.5 ease-in-out";

      scrollback_pager = "sh -c 'cat > /tmp/kitty-scrollback.txt && ansifilter -i /tmp/kitty-scrollback.txt -o /tmp/kitty-scrollback-filtered.txt && hx /tmp/kitty-scrollback-filtered.txt'";
      "map alt+q" = "show_scrollback";
    };
  };
}
