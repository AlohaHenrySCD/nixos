{
  pkgs,
  inputs,
  osConfig,
  ...
}:
let
  fontSettings = import ../fonts.nix { inherit pkgs; };
in
{
  imports = [
  ];

  home.homeDirectory = "/home/alohahenry";
  fonts.fontconfig = fontSettings.fontconfig;


}
