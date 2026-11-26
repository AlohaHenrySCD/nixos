{ constants, pkgs, ... }:
{
  home.homeDirectory = "/Users/${constants.username}";
  targets.darwin.copyApps.enable = true;
  programs.fish = {
    shellAliases = {
      bd = "sudo nix run nix-darwin -- switch --impure --flake ~/my-nix#macbook";
    };
    shellAbbrs = {
      nix-clean = "nix-collect-garbage && sudo nix-collect-garbage";
    };
  };
}
