{ pkgs, theme, ... }:
let
  inherit (theme) palette;
in
{
  xdg.configFile."kitty/Everforest.conf".text = ''
    # vim:ft=kitty
    ## name: Everforest Dark Medium
    ## author: Sainnhe Park
    ## license: MIT
    ## upstream: https://github.com/ewal/kitty-everforest/blob/master/themes/everforest_dark_medium.conf
    ## blurb: A green based color scheme designed to be warm and soft

    foreground ${palette.fg}
    background ${palette.bg0}
    selection_foreground ${palette.grey2}
    selection_background ${palette.bg4}

    cursor ${palette.fg}
    cursor_text_color ${palette.bg1}

    url_color ${palette.blue}

    active_border_color ${palette.green}
    inactive_border_color ${palette.bg5}
    bell_border_color ${palette.orange}
    visual_bell_color none

    wayland_titlebar_color system
    macos_titlebar_color system

    active_tab_background ${palette.bg0}
    active_tab_foreground ${palette.fg}
    inactive_tab_background ${palette.bg2}
    inactive_tab_foreground ${palette.grey2}
    tab_bar_background ${palette.bg1}
    tab_bar_margin_color none

    mark1_foreground ${palette.bg0}
    mark1_background ${palette.blue}
    mark2_foreground ${palette.bg0}
    mark2_background ${palette.fg}
    mark3_foreground ${palette.bg0}
    mark3_background ${palette.purple}

    #: black
    color0 ${palette.bg1}
    color8 ${palette.grey0}

    #: red
    color1 ${palette.red}
    color9 ${palette.red}

    #: green
    color2 ${palette.green}
    color10 ${palette.green}

    #: yellow
    color3 ${palette.yellow}
    color11 ${palette.yellow}

    #: blue
    color4 ${palette.blue}
    color12 ${palette.blue}

    #: magenta
    color5 ${palette.purple}
    color13 ${palette.purple}

    #: cyan
    color6 ${palette.aqua}
    color14 ${palette.aqua}

    #: white
    color7 ${palette.grey1}
    color15 ${palette.grey2}
  '';
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
