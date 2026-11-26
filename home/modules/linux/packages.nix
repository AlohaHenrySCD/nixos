{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  xdg.desktopEntries = lib.genAttrs [ "Helix" "btop" "yazi" ] (name: {
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
    llmAgents.t3code-desktop
    chatgpt
    gtrash
    qemu
    zed-editor
    # localsend
    glib
    gcc
    gtk4
    wiremix
    pavucontrol
    zathura
    libnotify
    # osu-lazer
    polychromatic
  ];
}
