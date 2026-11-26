{
  config,
  lib,
  pkgs,
  ...
}:
let
  commonKeys = {
    "*" = "search_selection";
    "A-*" = "search_selection_detect_word_boundaries";
    h = "collapse_selection";
    "A-h" = "flip_selections";
    x = "select_line_below";
    X = "select_line_above";
  };
  toml = pkgs.formats.toml { };
  mitosSettings = lib.recursiveUpdate config.programs.helix.settings {
    editor.cursor.block-rendering = "native";
  };
in
{
  home.sessionVariables.MITOS_RUNTIME = "${config.home.homeDirectory}/git/mitos/runtime";

  # xdg.configFile."mitos/config.toml".source = config.xdg.configFile."helix/config.toml".source;
  xdg.configFile."mitos/config.toml".source = toml.generate "mitos-config.toml" mitosSettings;
  xdg.configFile."mitos/scrollback.toml".source = toml.generate "mitos-scrollback.toml" (
    lib.recursiveUpdate mitosSettings {
      editor.gutters.layout = [ ];
    }
  );
  xdg.configFile."mitos/languages.toml".source = config.xdg.configFile."helix/languages.toml".source;
  xdg.configFile."mitos/themes/everforest_dark.toml".text = ''
    inherits = "everforest_dark"
    "ui.highlight" = { underline = { style = "curl" } }
  '';

  programs.helix = {
    enable = true;

    languages = {
      language = [
        {
          name = "nix";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          auto-format = true;
        }
        {
          name = "rust";
          indent = {
            tab-width = 4;
            unit = "\t";
          };
          auto-format = true;
        }
        {
          name = "toml";
          indent = {
            tab-width = 4;
            unit = "\t";
          };
        }
        {
          name = "python";
          indent = {
            tab-width = 4;
            unit = "\t";
          };
          auto-format = true;
          formatter = {
            command = "black";
            args = [
              "-"
              "-q"
            ];
          };
        }
        {
          name = "markdown";
          indent = {
            tab-width = 2;
            unit = "\t";
          };
        }
      ];
      language-server = {
        rust-analyzer.config = {
          check.command = "clippy";
          rustfmt.rangeFormatting.enable = true;
        };
        texlab.config.texlab = {
          chktex = {
            onOpenAndSave = true;
            onEdit = true;
          };
          forwardSearch = {
            executable = "zathura";
            args = [
              "--synctex-forward"
              "%l:%c:%f"
              "%p"
            ];
          };
          build = {
            auxDirectory = "build";
            logDirectory = "build";
            pdfDirectory = "build";
            forwardSearchAfter = true;
            onSave = true;
            executable = "tectonic";
            args = [
              "-X"
              "compile"
              "--synctex"
              "--keep-logs"
              "--keep-intermediates"
              "--outdir=build"
              "%f"
            ];
          };
        };
      };
    };

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
          left = [
            "mode"
            "read-only-indicator"
            "spinner"
            "file-name"
            "file-modification-indicator"
          ];
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
        indent-guides.render = true;
        indent-guides.skip-levels = 1;
      };
      keys.normal = commonKeys // {
        w = "@miwvwv";
        C-j = "jump_view_left";
        C-k = "jump_view_down";
        C-l = "jump_view_up";
        "C-;" = "jump_view_right";
        j = "move_char_left";
        k = "move_line_down";
        l = "move_line_up";
        ";" = "move_char_right";
        space = {
          q = ":q";
          Q = ":q!";
          w = ":w";
          W = ":wa";
          x = ":wq";
          c = ":bc";
        };
      };
      keys.select = commonKeys // {
        j = "extend_char_left";
        k = "extend_line_down";
        l = "extend_line_up";
        ";" = "extend_char_right";
      };

    };

  };
}
