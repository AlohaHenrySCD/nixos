{
  config,
  constants,
  pkgs,
  osConfig,
  theme,
  ...
}:
{
  imports = [
    # 这组模块向 home.packages 追加内容，导入顺序影响用户环境的派生。
    ./modules/linux/packages.nix
    ./modules/linux/goldendict.nix
    ./modules/linux/clipboard.nix
    ./modules/linux/flatpak.nix
    ./modules/linux/quit-focused-app.nix
    ./modules/linux/kitty-session.nix

    ./modules/linux/bar.nix
    ./modules/linux/fcitx5.nix
    ./modules/linux/fuzzel.nix
    ./modules/linux/gtk.nix
    ./modules/linux/obsidian.nix
    ./modules/linux/plasma.nix
  ];

  # ── 桌面与会话 ──
  home.homeDirectory = "/home/${constants.username}";
  home.sessionPath = [ "${config.home.homeDirectory}/.cargo/bin" ];
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "kde";
  xdg.configFile."niri/config.kdl".text = theme.render ./niri.kdl;
  fonts.fontconfig = theme.fonts.fontconfig;

  home.pointerCursor = {
    enable = true;
    package = pkgs.everforest-cursors;
    inherit (theme.cursor) name size;
    gtk.enable = true;
    x11.enable = true;
  };

  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      default-timeout = 5000;
      ignore-timeout = false;
      max-visible = 5;
      layer = "overlay";
      font = "${theme.fonts.gtk.name} 10";
      background-color = theme.palette.bg0;
      text-color = theme.palette.fg;
      border-color = theme.palette.green;
    };
  };

  # ── 应用与终端 ──
  programs.obs-studio.enable = true;
  programs.kitty = {
    # Compensate for Niri's touchpad scroll-factor 0.2 inside the terminal.
    settings.touch_scroll_multiplier = 5.0;
    keybindings.esc = "combine : send_text all \\x1b : launch --type=background ${pkgs.fcitx5}/bin/fcitx5-remote -c";
  };

  programs.fish = {
    shellAliases.bd = "sudo nixos-rebuild switch -L --flake /etc/nixos#${osConfig.networking.hostName}";
    shellAbbrs = {
      jlog = "journalctl -b -x --all --no-pager";
      nix-clean = "nix-collect-garbage && sudo nix-collect-garbage && sudo journalctl --vacuum-size=300M";
    };
  };

  # ── 文件与默认程序 ──
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.kde.dolphin.desktop";
      "x-scheme-handler/clash" = "clash-verge.desktop";
      "x-scheme-handler/clash-verge" = "clash-verge.desktop";
      "x-scheme-handler/codex" = "chatgpt.desktop";
      "x-scheme-handler/t3code" = "com.t3tools.T3Code.desktop";
      "x-scheme-handler/dshu" = "deepseek-harness-uncensored.desktop";
    };
  };
  xdg.configFile."mimeapps.list".force = true;

  xdg.dataFile."dbus-1/services/org.freedesktop.FileManager1.service".source =
    "${pkgs.kdePackages.dolphin}/share/dbus-1/services/org.kde.dolphin.FileManager1.service";
}
