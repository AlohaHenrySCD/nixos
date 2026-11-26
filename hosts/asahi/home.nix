{ config, ... }:
{
  xdg.configFile."fex-emu/Config.json".text = builtins.toJSON {
    Config.RootFS = "${config.xdg.dataHome}/fex-emu/RootFS/Fedora_44.ero";
  };
  xdg.configFile."niri/outputs.kdl".source = ./niri-outputs.kdl;
  programs.fish.shellAliases.bd-debug = "sudo nixos-rebuild switch -L --impure --flake /etc/nixos#asahi-debug";
}
