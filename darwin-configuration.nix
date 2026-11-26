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

  services.tailscale.enable = true;
  launchd.daemons.tailscaled.environment =
    let
      proxyUrl = "http://${constants.proxy.host}:${toString constants.proxy.port}";
    in
    {
      HTTP_PROXY = proxyUrl;
      HTTPS_PROXY = proxyUrl;
      NO_PROXY = "localhost,127.0.0.1,::1,100.64.0.0/10,*.ts.net";
    };

  homebrew = {
    enable = true;
    enableFishIntegration = true;

    taps = [ "akirco/pigma" ];
    brews = [ "akirco/pigma/pigma" ];
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
      "zed"
      "linearmouse"
      "bazecor"
      "iina"
      "prismlauncher"
      "monitorcontrol"
      "raycast"
      "background-music"
    ];
  };

  system.defaults = {
    dock.autohide = true;
    finder.ShowPathbar = true;
  };

  system.stateVersion = 7;
}
