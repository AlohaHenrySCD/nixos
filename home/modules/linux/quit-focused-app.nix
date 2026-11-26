{ pkgs, osConfig, ... }:
{
  home.packages = [
    (pkgs.quit-focused-app.override {
      niri = osConfig.programs.niri.package;
    })
  ];
}
