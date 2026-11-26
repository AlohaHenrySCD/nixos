{ inputs, lib, theme, ... }:
{
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.optimise.automatic = true;
  nixpkgs.config.allowUnfree = true;
  fonts.packages = theme.fonts.packages;

  programs.fish.enable = true;

  nix.settings = {
    max-jobs = "auto";
    substituters = lib.mkForce [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30"
      "https://cache.nixos.org"
    ];
    extra-substituters = [
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
}
