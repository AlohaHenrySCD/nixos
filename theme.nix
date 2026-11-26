{ pkgs }:
let
  ui = "JetBrains Sans";
  uiCjk = "LXGW WenKai GB Screen";
  monospace = "JetBrainsMonoNL Nerd Font Mono";
  monospaceCjk = "LXGW Neo XiHei";
  icons = "JetBrainsMono Nerd Font Propo";
  cursor = {
    name = "everforest-cursors";
    size = 32;
  };
  palette = {
    bg_dim = "#232a2e";
    bg0 = "#2d353b";
    bg1 = "#343f44";
    bg2 = "#3d484d";
    bg3 = "#475258";
    bg4 = "#4f585e";
    bg5 = "#56635f";
    bg_visual = "#543a48";
    bg_red = "#514045";
    bg_green = "#425047";
    bg_blue = "#3a515d";
    bg_yellow = "#4d4c43";
    fg = "#d3c6aa";
    red = "#e67e80";
    orange = "#e69875";
    yellow = "#dbbc7f";
    green = "#a7c080";
    aqua = "#83c092";
    blue = "#7fbbb3";
    purple = "#d699b6";
    grey0 = "#7a8478";
    grey1 = "#859289";
    grey2 = "#9da9a0";
    statusline1 = "#a7c080";
    statusline2 = "#d3c6aa";
    statusline3 = "#e67e80";
  };
in
{
  inherit cursor palette;

  render =
    file:
    let
      values = palette // {
        cursorName = cursor.name;
        cursorSize = toString cursor.size;
      };
      tokens = map (name: "@${name}@") (builtins.attrNames values);
    in
    builtins.replaceStrings tokens (builtins.attrValues values) (builtins.readFile file);

  fonts = {
    packages =
      pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.corefonts ]
      ++ (with pkgs; [
        lxgw-wenkai
        lxgw-wenkai-gb-screen
        lxgw-neoxihei
        jetbrains-sans
        jetbrains-mono
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
        nerd-fonts.caskaydia-cove
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
      ]);

    fontconfig = {
      enable = true;
      configFile.jetbrains-cjk = {
        enable = true;
        priority = 53;
        text = builtins.replaceStrings
          [ "@ui@" "@uiCjk@" "@monospace@" "@monospaceCjk@" ]
          [ ui uiCjk monospace monospaceCjk ]
          (builtins.readFile ./fontconfig-jetbrains-cjk.xml);
      };
      defaultFonts = {
        monospace = [
          monospace
          "Symbols Nerd Font Mono"
        ];
        sansSerif = [
          ui
          uiCjk
          "Symbols Nerd Font"
        ];
        serif = [
          "Noto Serif"
          uiCjk
          "Symbols Nerd Font"
        ];
      };
    };

    gtk = {
      name = ui;
      package = pkgs.jetbrains-sans;
    };
    gtkDpi = 196608;

    plasma =
      let
        uiFont = {
          family = ui;
          pointSize = 10;
        };
      in
      {
        general = uiFont;
        menu = uiFont;
        toolbar = uiFont;
        windowTitle = uiFont;
        small = uiFont // {
          pointSize = 8;
        };
        fixedWidth = {
          family = monospace;
          pointSize = 10;
        };
      };

    kitty = {
      font_family = monospace;
      font_size = 13;
    };

    fcitx = "${monospaceCjk} 11";

    waybar = rec {
      family = ''"${ui}", "${uiCjk}", "${icons}", sans-serif'';
      textSize = 16;
      weight = 600;
      iconFamily = icons;
      iconSize = textSize;
    };
  };
}
