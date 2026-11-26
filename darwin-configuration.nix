{
  pkgs,
  constants,
  ...
}:
{
  imports = [ ./modules/common/nix.nix ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = constants.username;

  users.users.${constants.username} = {
    home = "/Users/${constants.username}";
    shell = pkgs.fish;
  };

  time.timeZone = "Asia/Shanghai";

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
