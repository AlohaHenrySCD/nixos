{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  rgba = color: lib.removePrefix "#" color + "ff";
  dataDirs = "${config.xdg.dataHome}/flatpak/exports/share:/var/lib/flatpak/exports/share";
in
{
  programs.fuzzel = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "fuzzel-flatpak";
      paths = [ pkgs.fuzzel ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/fuzzel" \
          --prefix XDG_DATA_DIRS : ${lib.escapeShellArg dataDirs}
      '';
    };
    settings = {
      main.font = "${theme.fonts.gtk.name}:size=12";
      colors = lib.mapAttrs (_: rgba) {
        background = theme.palette.bg0;
        text = theme.palette.fg;
        prompt = theme.palette.aqua;
        input = theme.palette.fg;
        match = theme.palette.green;
        selection = theme.palette.bg2;
        selection-text = theme.palette.fg;
        selection-match = theme.palette.green;
        border = theme.palette.grey0;
      };
    };
  };
}
