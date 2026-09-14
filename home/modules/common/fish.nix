{ pkgs, ... }:
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
      # abbr --add fd --set-cursor='%' 'find . -iname "*%*" 2>/dev/null'
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
}
