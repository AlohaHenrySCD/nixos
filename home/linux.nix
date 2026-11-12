{
  pkgs,
  inputs,
  osConfig,
  ...
}:
let
  fontSettings = import ../fonts.nix { inherit pkgs; };
in
{
  imports = [
    ./modules/linux/packages.nix
    ./modules/linux/gtk.nix
  ];

  home.homeDirectory = "/home/alohahenry";
  home.sessionPath = [ "/home/alohahenry/.cargo/bin" ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  xdg.dataFile."dbus-1/services/org.freedesktop.FileManager1.service".source =
    "${pkgs.kdePackages.dolphin}/share/dbus-1/services/org.kde.dolphin.FileManager1.service";

  home.sessionVariables = {
    GLFW_IM_MODULE = "ibus";
    SDL_IM_MODULE = "fcitx";
    "QT_IM_MODULE" = "fcitx";
    QT_QPA_PLATFORMTHEME = "kde";
  };

  systemd.user.sessionVariables.QT_QPA_PLATFORMTHEME = "kde";

  programs.obs-studio = {
    enable = true;
  };
  programs.alacritty.enable = true;

  fonts.fontconfig = fontSettings.fontconfig;

  programs.kitty = {
    settings.restore_session_after_logout = true;
    # Compensate for Niri's touchpad scroll-factor 0.2 inside the terminal.
    settings.touch_scroll_multiplier = 5.0;
    keybindings = {
      "esc" =
        "combine : send_text all \\x1b : launch --type=background ${pkgs.fcitx5}/bin/fcitx5-remote -c";
    };
  };

  programs.fish = {
    shellAliases = {
      bd = "sudo nixos-rebuild switch -L --impure --flake /etc/nixos#asahi";
      bd-debug = "sudo nixos-rebuild switch -L --impure --flake /etc/nixos#asahi-debug";
    };
    shellAbbrs = {
      nix-clean = "nix-collect-garbage && sudo nix-collect-garbage && sudo journalctl --vacuum-size=300M";
    };
    functions = {
      gbd = "git add /etc/nixos/ && git commit --message $argv[1] && git push && sudo nixos-rebuild switch -L --impure --flake /etc/nixos#asahi ";
    };
  };

  # Migrated to configuration.nix.
  /* i18n.inputMethod = {
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
  }; */

  systemd.user.services.fcitx5-daemon = {
    Unit = {
      Description = "Fcitx5 input method editor";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service.ExecStart = "${osConfig.i18n.inputMethod.package}/bin/fcitx5";
    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.dataFile."color-schemes/Everforest.colors".source =
    inputs.kde-everforest + "/Everforest.colors";
  programs.plasma = {
    enable = true;

    fonts = fontSettings.plasma;

    configFile."plasma-localerc" = {
      Formats.LANG = "en_US.UTF-8";
      Translations.LANGUAGE = "en_US:en";
    };

    configFile."mimeapps.list"."Default Applications"."inode/directory" =
      "org.kde.dolphin.desktop";

    workspace.colorScheme = "Everforest";
    configFile."kdeglobals"."Icons"."Theme" = "Papirus";
    configFile."kcminputrc"."Mouse" = {
      cursorTheme = "everforest-cursors";
      cursorSize = 28;
    };
    configFile."kded5rc"."Module-gtkconfig".autoload = false;

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
  home.file.".local/share/fcitx5/rime/rime_ice.custom.yaml".text = ''
    patch:
      "switches/@1/reset": 1
  '';

  xdg.configFile."mako/config".source = ./mako;
  xdg.configFile."fcitx5/config".source = ./fcitx5;
  # Leave Ctrl+Shift+U available for Kitty scrollback.
  xdg.configFile."fcitx5/conf/unicode.conf".text = ''
    DirectUnicodeMode=
  '';
  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Font=${fontSettings.fcitx}
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
    SwitchInputMethodBehavior=Commit raw input
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
