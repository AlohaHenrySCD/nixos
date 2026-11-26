{
  config,
  constants,
  lib,
  pkgs,
  inputs,
  osConfig,
  theme,
  ...
}:
let
  inherit (theme) fonts palette;
  obsidianVaultFiles = {
    "community-plugins.json" = pkgs.writeText "obsidian-community-plugins.json" (builtins.toJSON [
      "background-tray"
    ]);
    "plugins/background-tray/main.js" = pkgs.fetchurl {
      url = "https://github.com/Synaphi/background-tray/releases/download/1.09.14/main.js";
      hash = "sha256-oFFWYLnutOnr1oi85ZHtNK9SCIZyHMsW6pZAeJ9FS10=";
    };
    "plugins/background-tray/manifest.json" =
      pkgs.fetchurl
        {
          url = "https://github.com/Synaphi/background-tray/releases/download/1.09.14/manifest.json";
          hash = "sha256-/IbWCCLEwsZ8ggSxAvpeNBo6VA5KVFg0PWuTBqudwoQ=";
        };
    "plugins/background-tray/styles.css" = pkgs.fetchurl {
      url = "https://github.com/Synaphi/background-tray/releases/download/1.09.14/styles.css";
      hash = "sha256-Pj+HusIxpnMdNwWbOBZwgeebYzToMl2T3Kv6V9+Ng3Q=";
    };

    "themes/Everforest/theme.css" =
      pkgs.concatText "obsidian-everforest.css" [
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/0xglitchbyte/obsidian_everforest/0b125d77156e1965e0b9489caccece65034582fb/obsidian.css";
          hash = "sha256-Wc0isaAFy2pkkX5Y/+yuyiXLWHGrh5f8qEvagdPdr0U=";
        })
        (pkgs.writeText "everforest-heading.css" ''

          .theme-dark {
            --h1-color: var(--everforest-dim-orange);
            --h2-color: var(--everforest-dim-yellow);
            --h3-color: var(--everforest-dim-green);
            --h4-color: var(--everforest-dim-aqua);
            --h5-color: var(--everforest-dim-purple);
          }
          .theme-light {
            --h1-color: var(--everforest-light-orange);
            --h2-color: var(--everforest-light-yellow);
            --h3-color: var(--everforest-light-green);
            --h4-color: var(--everforest-light-aqua);
            --h5-color: var(--everforest-light-purple);
          }
        '')
      ];
    # Upstream provides a legacy stylesheet without a theme manifest.
    "themes/Everforest/manifest.json" = pkgs.writeText "obsidian-everforest-manifest.json" (builtins.toJSON {
      name = "Everforest";
      version = "0.0.0+0b125d7";
      minAppVersion = "1.0.0";
      author = "0xglitchbyte";
      authorUrl = "https://github.com/0xglitchbyte";
    });
  };
in
{
  imports = [
    ./modules/linux/packages.nix
    ./modules/linux/goldendict.nix
    ./modules/linux/qbittorrent.nix
    ./modules/linux/fuzzel.nix
    ./modules/linux/flatpak.nix
    ./modules/linux/bar.nix
    ./modules/linux/gtk.nix
    ./modules/linux/clash-hkmo.nix
    ./modules/linux/quit-focused-app.nix
    ./modules/linux/kitty-session.nix
  ];

  home.homeDirectory = "/home/${constants.username}";
  home.sessionPath = [ "${config.home.homeDirectory}/.cargo/bin" ];

  home.activation.obsidianVaultFiles = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: source:
        "run install -Dm644 ${source} ${lib.escapeShellArg "${config.home.homeDirectory}/Documents/obsidian/.obsidian/${name}"}"
      ) obsidianVaultFiles
    )
  );

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

  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      default-timeout = 5000;
      ignore-timeout = false;
      max-visible = 5;
      layer = "overlay";
      font = "${fonts.gtk.name} 10";
      background-color = palette.bg0;
      text-color = palette.fg;
      border-color = palette.green;
    };
  };

  programs.obs-studio = {
    enable = true;
  };

  fonts.fontconfig = fonts.fontconfig;

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
      bd = "sudo nixos-rebuild switch -L --flake /etc/nixos#${osConfig.networking.hostName}";
    };
    shellAbbrs = {
      jlog = "journalctl -b -x --all --no-pager";
      nix-clean = "nix-collect-garbage && sudo nix-collect-garbage && sudo journalctl --vacuum-size=300M";
    };
  };

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

    fonts = fonts.plasma;

    configFile."plasma-localerc" = {
      Formats.LANG = "en_US.UTF-8";
      Translations.LANGUAGE = "en_US:en";
    };

    configFile."mimeapps.list"."Default Applications"."inode/directory" =
      "org.kde.dolphin.desktop";

    workspace.colorScheme = "Everforest";
    configFile."kdeglobals"."Icons"."Theme" = "Papirus";
    configFile."kcminputrc"."Mouse" = {
      cursorTheme = config.home.pointerCursor.name;
      cursorSize = config.home.pointerCursor.size;
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

  xdg.configFile."niri/config.kdl".text = theme.render ./config.kdl;
  home.file.".local/share/fcitx5/rime/default.custom.yaml".source = ./default.custom.yaml;
  home.file.".local/share/fcitx5/rime/rime_ice.custom.yaml".text = ''
    patch:
      "switches/@1/reset": 1
      "engine/processors/@before 0": lua_processor@*raw_on_symbol
  '';
  home.file.".local/share/fcitx5/rime/lua/raw_on_symbol.lua".source = ./raw_on_symbol.lua;

  xdg.configFile."fcitx5/config".source = ./fcitx5;
  # Leave Ctrl+Shift+U available for Kitty scrollback.
  xdg.configFile."fcitx5/conf/unicode.conf".text = ''
    DirectUnicodeMode=
  '';
  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Font=${fonts.fcitx}
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
    NormalColor=${palette.fg}
    HighlightColor=${palette.green}
    HighlightCandidateColor=${palette.bg0}
    HighlightBackgroundColor=${palette.bg2}
    PageButtonAlignment=Last Candidate

    [InputPanel/Background]
    Color=${palette.bg0}
    BorderColor=${palette.grey1}
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
    Color=${palette.green}

    [InputPanel/Highlight/Margin]
    Left=4
    Right=4
    Top=3
    Bottom=3

    [Menu]
    NormalColor=${palette.fg}
    SelectedItemColor=${palette.bg0}

    [Menu/Background]
    Color=${palette.bg0}
    BorderColor=${palette.grey1}
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
    Color=${palette.green}

    [Menu/Separator]
    Color=${palette.bg3}
  '';
  xdg.configFile."fcitx5/conf/rime.conf".text = ''
    # Commit the typed pinyin when switching away from Rime.
    SwitchInputMethodBehavior=Commit raw input
  '';

  home.pointerCursor = {
    enable = true;
    package = pkgs.everforest-cursors;
    inherit (theme.cursor) name size;
    gtk.enable = true;
    x11.enable = true;
  };

}
