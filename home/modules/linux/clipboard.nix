{ config, pkgs, ... }:
{
  services.cliphist = {
    enable = true;
    systemdTargets = [ "niri.service" ];
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "clipboard-history";
      runtimeInputs = [
        pkgs.cliphist
        pkgs.wl-clipboard
        config.programs.fuzzel.package
        pkgs.procps
        pkgs.jq
        pkgs.coreutils
      ];
      text = builtins.readFile ./clipboard-history.sh;
    })
  ];
}
