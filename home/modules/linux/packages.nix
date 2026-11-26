{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.packages =
    let
      llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in
    with pkgs;
    [
      # 桌面与系统工具
      bubblewrap # 为 Codex 提供 Linux 沙箱
      usbutils
      wl-clipboard
      deepseek-harness-uncensored # DeepSeek 桌面客户端
      pigma # 终端网易云音乐和本地音乐播放器
      squirreldisk # 图形化查看磁盘空间占用

      # AI 工具
      llmAgents.t3code-desktop
      chatgpt

      # 文件与开发工具
      gtrash # 在终端将文件移入回收站或还原
      qemu

      # 语言与构建工具链
      glib
      gcc
      gtk4

      # 音频与桌面应用
      wiremix # 终端 PipeWire 混音器
      pavucontrol # 图形化调节应用音量和输出设备
      zathura # 键盘操作的 PDF 阅读器
      libnotify

      # 硬件与调试
      polychromatic # 配置雷蛇设备的灯效等设置
    ];

  xdg.desktopEntries = lib.genAttrs [ "Helix" "btop" "yazi" ] (name: {
    inherit name;
    noDisplay = true;
  });
}
