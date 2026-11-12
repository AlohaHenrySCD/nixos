{ pkgs, osConfig, ... }:
{
  home.packages = [
    (pkgs.callPackage ../../../packages/quit-focused-app {
      niri = osConfig.programs.niri.package;
    })
  ];
}
