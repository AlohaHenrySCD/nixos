{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (callPackage ../../../packages/pomotroid.nix { })
    (callPackage ../../../packages/pigma.nix { })
    (callPackage ../../../packages/squirreldisk.nix { })
    # kdePackages.kdenlive
    chatgpt
    kazumi
    haruna
    vlc
    gtrash
    qemu
    # wechat
    (wechat.overrideAttrs { dieWithParent = false; })
    zed-editor
    vesktop
    chromium
    netease-cloud-music-gtk
    # ncspot
    # obsidian
    (obsidian.override { electron = electron_44; })
    libreoffice
    # localsend
    glib
    gcc
    gtk4
    pavucontrol
    fuzzel
    mako
    libnotify
    # kdePackages.kate
    papers
    # osu-lazer
    prismlauncher
    polychromatic
  ];
}
