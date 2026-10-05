{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (callPackage ../../../packages/pomotroid.nix { })
    kdePackages.kdenlive
    kazumi
    gtrash
    qemu
    wechat
    zed-editor
    vesktop
    chromium
    netease-cloud-music-gtk
    ncspot
    obsidian
    libreoffice
    localsend
    glib
    gcc
    gtk4
    pavucontrol
    fuzzel
    mako
    libnotify
    kdePackages.kate
    papers
    # osu-lazer
    prismlauncher
    polychromatic
  ];
}
