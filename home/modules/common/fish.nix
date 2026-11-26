{ lib, pkgs, theme, ... }:
{
  # Let nix-shell find Bash without requiring <nixpkgs> in NIX_PATH.
  home.sessionVariables.NIX_BUILD_SHELL = "${pkgs.bashInteractive}/bin/bash";

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting "Hello! AlohaHenry"
      set -g fish_cursor_default block
      bind alt-u backward-kill-line
      abbr --add add --set-cursor='%' 'nix shell nixpkgs#%'
      abbr --add dis --set-cursor='%' '% & disown'
      # abbr --add fd --set-cursor='%' 'find . -iname "*%*" 2>/dev/null'
      function y
      	set tmp (mktemp -t "yazi-cwd.XXXXXX")
      	command yazi $argv --cwd-file="$tmp"
      	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
      		builtin cd -- "$cwd"
      	end
      	command rm -f -- "$tmp"
      end
    '';
    shellAbbrs = {
      ls = "eza";
      la = "eza -a";
      ll = "eza -al";
      cd = "z";
      grep = "rg";
      ove = "ov --exec --";
      ns = "nix-shell --run fish";
      ur = "uv run";
      jlog = "journalctl -b -x --all --no-pager";
      rm = "trash-put";
      cr = "codex resume";
      co = "codex";
      gp = "glow -p";
      lg = "lazygit";
    };
    functions = {
      mkcd = ''
        mkdir -p -- $argv[1]
        and cd -- $argv[1]
      '';
      # rm = ''
      #   mkdir -p ~/.trash
      #   mv -- $argv ~/.trash/
      # '';
      manrg = ''
        man $argv[1] | col -b | rg -C 3 -- $argv[2]
      '';
    };
  };

  xdg.configFile."fish/conf.d/everforest.fish".text =
    let
      hex = lib.removePrefix "#";
      colors = with theme.palette; {
        fish_color_normal = hex fg;
        fish_color_command = hex green;
        fish_color_keyword = hex purple;
        fish_color_param = hex fg;
        fish_color_option = hex aqua;
        fish_color_quote = hex yellow;
        fish_color_redirection = hex orange;
        fish_color_end = hex purple;
        fish_color_error = hex red;
        fish_color_comment = hex grey1;
        fish_color_operator = hex orange;
        fish_color_escape = hex aqua;
        fish_color_autosuggestion = hex grey0;
        fish_color_search_match = "--background=${hex bg2}";
        fish_color_selection = "--background=${hex bg3}";
        fish_pager_color_prefix = hex green;
        fish_pager_color_completion = hex fg;
        fish_pager_color_description = hex grey2;
        fish_pager_color_progress = hex aqua;
        fish_pager_color_selected_background = "--background=${hex bg2}";
      };
    in
    ''
      if status is-interactive
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: color: "    set -g ${name} ${color}") colors)}
      end
    '';
}
