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
