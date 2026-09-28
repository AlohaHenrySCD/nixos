{
  lib,
  pkgs,
  ...
}:
let
  # Keep LibreOffice and its dependencies on the already available 26.2.5.2 build.
  libreofficePkgs =
    import
      (builtins.fetchTree {
        type = "github";
        owner = "nixos";
        repo = "nixpkgs";
        rev = "8ce4ef6cb6f871616146b9fe26d2a5ae594e94fe";
        narHash = "sha256-xB8mKMOx1IA9vTDNLmJZ6n4wCMq/cuWBBOzGCRnqxrU=";
      })
      {
        system = pkgs.stdenv.hostPlatform.system;
      };
in
{
  home.packages = with pkgs; [
    kdePackages.kdenlive
    kazumi
    qemu
    wechat
    zed-editor
    vesktop
    chromium
    netease-cloud-music-gtk
    ncspot
    obsidian
    libreofficePkgs.libreoffice
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
