{ constants, pkgs, ... }:
{
  home.homeDirectory = "/Users/${constants.username}";
  home.packages = [
    pkgs.halloy # IRC 聊天客户端
    pkgs.qbittorrent
  ];
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
