{ ... }:
{
  xdg.configFile."helix/languages.toml".source = ./helix-languages.toml;
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "everforest_dark";
      editor = {
        completion-trigger-len = 1;
        idle-timeout = 0;
        completion-replace = true;
        end-of-line-diagnostics = "hint";
        inline-diagnostics.cursor-line = "warning";
        soft-wrap.enable = true;
        line-number = "relative";
        mouse = true;
        cursorline = true;
        bufferline = "always";
        color-modes = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        statusline = {
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
        indent-guides.render = true;
        indent-guides.skip-levels = 1;
      };
      keys.normal = {
        w = "rotate_view";
        C-j = "jump_view_left";
        C-k = "jump_view_down";
        C-l = "jump_view_up";
        "C-;" = "jump_view_right";
        j = "move_char_left";
        k = "move_line_down";
        l = "move_line_up";
        ";" = "move_char_right";
        x = "select_line_below";
        X = "select_line_above";
        space = {
          q = ":q";
          Q = ":q!";
          w = ":w";
          W = ":wa";
          x = ":wq";
        };
      };
      keys.select = {
        j = "extend_char_left";
        k = "extend_line_down";
        l = "extend_line_up";
        ";" = "extend_char_right";
        x = "select_line_below";
        X = "select_line_above";
      };

    };

  };
}
