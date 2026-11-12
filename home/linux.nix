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
    ./modules/linux/packages.nix
  ];

  home.homeDirectory = "/home/alohahenry";
  home.sessionPath = [ "/home/alohahenry/.cargo/bin" ];

  fonts.fontconfig = fontSettings.fontconfig;


}
