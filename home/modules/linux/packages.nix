{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
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
  }
  // lib.genAttrs [ "Helix" "btop" "yazi" ] (name: {
    inherit name;
    noDisplay = true;
  });

  home.packages = with pkgs; [
    bubblewrap # codex required
    usbutils
    wl-clipboard
    deepseek-harness-uncensored
    pigma
    squirreldisk
    # kdePackages.kdenlive
    # opencode
    llmAgents.antigravity-cli
    llmAgents.opencode2
    llmAgents.t3code
    llmAgents.t3code-desktop
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
    wiremix
    pavucontrol
    zathura
    libnotify
    papers
    # osu-lazer
    prismlauncher
    polychromatic
  ];
}
