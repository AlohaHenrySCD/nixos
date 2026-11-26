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
    brews = [ "akirco/pigma/pigma" ]; # 终端网易云音乐和本地音乐播放器
    casks = [
      "google-chrome"
      "obs"
      "discord"
      "wechat"
      "osu" # 节奏游戏
      "microsoft-office"
      "obsidian"
      "clash-verge-rev" # 管理 Clash 代理配置
      "zed"
      "linearmouse" # 调整鼠标与触控板的滚动和加速
      "bazecor" # 配置 Dygma 键盘的键位和灯效
      "iina" # macOS 视频播放器
      "prismlauncher" # 管理和启动 Minecraft 实例
      "monitorcontrol" # 调节外接显示器的亮度和音量
      "raycast" # 启动应用并执行快捷操作
      "background-music" # 按应用调节音量
    ];
  };

  system.defaults = {
    dock.autohide = true;
    finder.ShowPathbar = true;
  };

  system.stateVersion = 7;
}
