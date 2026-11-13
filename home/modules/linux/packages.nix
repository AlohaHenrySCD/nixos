{
  config,
  lib,
  pkgs,
  ...
}:
let
  bazecorDir = "${config.home.homeDirectory}/git/Bazecor";
  bazecorLauncher = pkgs.writeShellScript "bazecor-launch" ''
    cd ${lib.escapeShellArg bazecorDir}
    exec ${pkgs.nix}/bin/nix-shell ${lib.escapeShellArg "${bazecorDir}/shell.nix"} \
      --argstr command 'exec ./out/Bazecor-linux-arm64/Bazecor'
  '';
in
{
  xdg.desktopEntries = {
    bazecor = {
      name = "Bazecor";
      comment = "Configure Dygma keyboards";
      exec = "${bazecorLauncher}";
      icon = "${bazecorDir}/build/logo.png";
      categories = [ "Utility" ];
      settings.StartupWMClass = "Bazecor";
    };
  } // lib.genAttrs [ "Helix" "btop" "yazi" ] (name: {
    inherit name;
    noDisplay = true;
  });

  home.packages = with pkgs; [
    (callPackage ../../../packages/pomotroid.nix { })
    (callPackage ../../../packages/pigma.nix { })
    (callPackage ../../../packages/squirreldisk.nix { })
    # kdePackages.kdenlive
    # opencode
    chatgpt
    haruna
    vlc
    gtrash
    qemu
    zed-editor
    vesktop
    netease-cloud-music-gtk
    # localsend
    glib
    gcc
    gtk4
    pavucontrol
    mako
    libnotify
    papers
    # osu-lazer
    prismlauncher
    polychromatic
  ];
}
