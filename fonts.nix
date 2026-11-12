{ pkgs }:
let
  ui = "JetBrains Sans";
  uiCjk = "LXGW WenKai GB Screen";
  monospace = "JetBrainsMonoNL Nerd Font Mono";
  monospaceCjk = "LXGW Neo XiHei";
  icons = "JetBrainsMono Nerd Font";
  monoIcons = "JetBrainsMono Nerd Font Mono";
in
{
  packages =
    pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      pkgs.corefonts
      pkgs.lxgw-wenkai
      (pkgs.callPackage ./packages/lxgw-wenkai-gb-screen.nix { })
      pkgs.lxgw-neoxihei
    ]
    ++ (with pkgs; [
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
      text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <alias binding="strong">
            <family>${ui}</family>
            <accept>
              <family>${uiCjk}</family>
            </accept>
          </alias>
          <alias binding="strong">
            <family>${monospace}</family>
            <accept>
              <family>${monospaceCjk}</family>
            </accept>
          </alias>
        </fontconfig>
      '';
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
    package = pkgs.callPackage ./packages/jetbrains-sans.nix { };
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

  waybar = {
    family = ''"${ui}", "${uiCjk}", "${icons}", sans-serif'';
    textSize = 16;
    weight = 600;
    iconFamily = monoIcons;
    iconSize = 20;
    networkIconSize = 22;
    bluetoothIconSize = 18;
  };
}
