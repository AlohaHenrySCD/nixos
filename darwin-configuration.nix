{
  pkgs,
  ...
}:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = "alohahenry";

  users.users.alohahenry = {
    home = "/Users/alohahenry";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  nix.settings = {
    max-jobs = 8;
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

  time.timeZone = "Asia/Shanghai";

  fonts.packages = (import ./fonts.nix { inherit pkgs; }).packages;

  system.keyboard = {
    enableKeyMapping = true;
    swapCapsLockAndEscape = true;
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  homebrew = {
    enable = true;
    enableFishIntegration = true;

    casks = [
      "google-chrome"
      "obs"
      "discord"
      "wechat"
      "osu"
      "microsoft-office"
      # "neteasemusic"
      "obsidian"
      "clash-verge-rev"
    ];
  };

  system.defaults = {
    dock.autohide = true;
    finder.ShowPathbar = true;
  };

  system.stateVersion = 7;
}
