{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # kdePackages.kdenlive
    chatgpt
    kazumi
    haruna
    vlc
    gtrash
    qemu
    (wechat.overrideAttrs { dieWithParent = false; })
    zed-editor
    vesktop
    chromium
    netease-cloud-music-gtk
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
    papers
    # osu-lazer
    prismlauncher
    polychromatic
  ];
}
