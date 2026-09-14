{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./modules/linux/packages.nix
    ./modules/linux/bar.nix
    ./modules/linux/gtk.nix
  ];

  home.homeDirectory = "/home/alohahenry";

  home.sessionVariables = {
    "QT_IM_MODULE" = "fcitx";
  };

  programs.obs-studio = {
    enable = true;
  };
  programs.alacritty.enable = true;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "JetBrainsMono Nerd Font"
        "Symbols Nerd Font Mono"
      ];

      sansSerif = [
        "Noto Sans"
        "Symbols Nerd Font"
      ];

      serif = [
        "Noto Serif"
        "Symbols Nerd Font"
      ];
    };
  };

  programs.kitty = {
    # Compensate for Niri's touchpad scroll-factor 0.2 inside the terminal.
    settings.touch_scroll_multiplier = 5.0;
    keybindings = {
      "esc" =
        "combine : send_text all \\x1b : launch --type=background ${pkgs.fcitx5}/bin/fcitx5-remote -c";
    };
  };

  programs.fish = {
    shellAliases = {
      bd = "sudo nixos-rebuild switch --impure --flake /etc/nixos#asahi";
    };
    shellAbbrs = {
      nix-clean = "nix-collect-garbage && sudo nix-collect-garbage && sudo journalctl --vacuum-size=300M";
    };
    functions = {
      gbd = "git add /etc/nixos/ && git commit --message $argv[1] && git push && sudo nixos-rebuild switch --impure --flake /etc/nixos#asahi ";
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-fluent
      (fcitx5-rime.override {
        rimeDataPkgs = [
          pkgs.rime-ice
        ];
      })
    ];
  };

  xdg.dataFile."color-schemes/Everforest.colors".source =
    inputs.kde-everforest + "/Everforest.colors";
  programs.plasma = {
    enable = true;

    workspace.colorScheme = "Everforest";

    panels = [
      {
        location = "top";
        height = 32;
        floating = false;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
        ];
      }

    ];
  };

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
  home.file.".local/share/fcitx5/rime/default.custom.yaml".source = ./default.custom.yaml;

  xdg.configFile."mako/config".source = ./mako;
  xdg.configFile."fcitx5/config".source = ./fcitx5;
  # Leave Ctrl+Shift+U available for Kitty scrollback.
  xdg.configFile."fcitx5/conf/unicode.conf".text = ''
    [DirectUnicodeMode]
  '';
  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Theme=everforest
    DarkTheme=everforest
    UseDarkTheme=False
    UseAccentColor=False
  '';
  xdg.dataFile."fcitx5/themes/everforest/theme.conf".text = ''
    [Metadata]
    Name=Everforest
    Name[zh_CN]=Everforest 深色
    Version=1
    Author=Local
    Description=Everforest dark colors matching Kitty and the status bar
    ScaleWithDPI=True

    [InputPanel]
    NormalColor=#d3c6aa
    HighlightColor=#a7c080
    HighlightCandidateColor=#2d353b
    HighlightBackgroundColor=#3d484d
    PageButtonAlignment=Last Candidate

    [InputPanel/Background]
    Color=#2d353b
    BorderColor=#859289
    BorderWidth=1

    [InputPanel/Background/Margin]
    Left=1
    Right=1
    Top=1
    Bottom=1

    [InputPanel/ContentMargin]
    Left=6
    Right=6
    Top=6
    Bottom=6

    [InputPanel/TextMargin]
    Left=8
    Right=8
    Top=5
    Bottom=5

    [InputPanel/Highlight]
    Color=#a7c080

    [InputPanel/Highlight/Margin]
    Left=4
    Right=4
    Top=3
    Bottom=3

    [Menu]
    NormalColor=#d3c6aa
    SelectedItemColor=#2d353b

    [Menu/Background]
    Color=#2d353b
    BorderColor=#859289
    BorderWidth=1

    [Menu/Background/Margin]
    Left=1
    Right=1
    Top=1
    Bottom=1

    [Menu/ContentMargin]
    Left=4
    Right=4
    Top=4
    Bottom=4

    [Menu/TextMargin]
    Left=8
    Right=8
    Top=5
    Bottom=5

    [Menu/Highlight]
    Color=#a7c080

    [Menu/Separator]
    Color=#475258
  '';
  xdg.configFile."fcitx5/conf/rime.conf".text = ''
    # Commit the typed pinyin when switching away from Rime.
    SwitchInputMethodBehavior=CommitRawInput
  '';

  home.pointerCursor = {
    enable = true;
    # package = pkgs.bibata-cursors;
    package = pkgs.everforest-cursors;
    # package = pkgs.phinger-cursors;
    # name = "Bibata-Modern-Ice";
    name = "everforest-cursors";
    # name = "phinger-cursors-light";
    size = 28;

    gtk.enable = true;
  };

}
