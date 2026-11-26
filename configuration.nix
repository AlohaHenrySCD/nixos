{
  lib,
  pkgs,
  constants,
  ...
}:
{
  imports = [
    ./modules/common/nix.nix
    ./modules/flatpak.nix
    ./modules/keyd.nix
    ./modules/nirinit.nix
  ];

  # ── 用户与权限 ──
  users.users.${constants.username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    home = "/home/${constants.username}";
    extraGroups = [
      "video"
      "input"
      "wheel"
      "networkmanager"
      "openrazer"
    ];
  };

  security.sudo = {
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  # ── Nix ──
  nix.channel.enable = false;
  nix.gc.dates = "weekly";

  # ── 桌面与会话 ──
  programs.niri.enable = true;
  services.desktopManager.plasma6.enable = true;
  # Plasma supplies KWallet and PAM unlock for both SDDM sessions.
  services.gnome.gnome-keyring.enable = false;
  services.displayManager = {
    defaultSession = "niri";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
  # Plasma runs this helper itself; niri needs its own PAM unlock hook.
  systemd.user.services.niri-kwallet-pam = {
    description = "Unlock KWallet in niri from PAM credentials";
    wantedBy = [ "niri.service" ];
    after = [ "niri.service" ];
    partOf = [ "niri.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init";
      RemainAfterExit = true;
    };
  };

  xdg.portal = {
    # Niri 的 Secret 门户默认使用 GNOME Keyring，此处须与 PAM 解锁的 KWallet 一致。
    config.niri."org.freedesktop.impl.portal.Secret" = lib.mkForce "kwallet";
    config.niri."org.freedesktop.impl.portal.FileChooser" = "kde";
    config.common.default = "*";
  };

  environment.systemPackages = with pkgs; [
    gtk4.dev
    gsettings-desktop-schemas # 提供桌面 GSettings 配置项定义
    xwayland-satellite # 在 Niri 中运行 X11 应用
  ];

  # ── 输入法 ──
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc # 日语输入引擎
      fcitx5-gtk # 让 GTK 应用接入 Fcitx5
      fcitx5-fluent # Fluent 风格输入法主题
      (fcitx5-rime.override {
        # 接入中州韵输入引擎
        rimeDataPkgs = [ pkgs.rime-ice ]; # 雾凇拼音方案和词库
      })
    ];
  };

  # ── 音频与外设 ──
  hardware.brillo.enable = true;
  hardware.graphics.enable = true;
  hardware.bluetooth = {
    enable = true;
  };

  hardware.openrazer.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.extraConfig = {
      device.routes = true;
    };
  };
  services.blueman.enable = true;

  # Bazecor checks 60-dygma.rules exactly; keep Bluetooth permissions separate.
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "dygma-udev-rules";
      destination = "/lib/udev/rules.d/60-dygma.rules";
      text = ''
        # Dygma Raise
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2200", MODE="0660", TAG+="uaccess"
        # bootloader mode
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2201", MODE="0660", TAG+="uaccess"

        # Dygma USB Keyboards Vendor ID
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="35ef", MODE="0660", TAG+="uaccess"
        # bootloader mode
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="35ef", MODE="0660", TAG+="uaccess"

        # Dygma HID Keyboards Vendor ID
        KERNEL=="hidraw*", ATTRS{idVendor}=="35ef", MODE="0660", TAG+="uaccess"
        # bootloader mode
        KERNEL=="hidraw*", ATTRS{idVendor}=="35ef", MODE="0660", TAG+="uaccess"
      '';
    })
    (pkgs.writeTextDir "lib/udev/rules.d/60-sonsei-bluetooth.rules" ''
      SUBSYSTEM=="hidraw", KERNELS=="0005:35EF:0031.*", MODE="0660", TAG+="uaccess"
    '')
  ];

  # ── 网络与代理 ──
  networking = {
    networkmanager.enable = true;
    networkmanager.unmanaged = [
      "Mihomo"
      "Meta"
    ];
    firewall.trustedInterfaces = [ "tailscale0" ];
  };

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraSetFlags = [
      "--operator=${constants.username}"
      "--accept-dns=false"
    ];
  };
  systemd.services.tailscaled.environment =
    let
      proxyUrl = "http://${constants.proxy.host}:${toString constants.proxy.port}";
    in
    {
      HTTP_PROXY = proxyUrl;
      HTTPS_PROXY = proxyUrl;
      # 回环地址、Tailscale 地址段和 ts.net 域名直接连接，避免绕经 Clash。
      NO_PROXY = "localhost,127.0.0.1,::1,100.64.0.0/10,*.ts.net";
    };

  # ── Chromium ──
  programs.chromium = {
    enable = true;
    extensions = [
      "dlcadbmcfambdjhecipbnolmjchgnode" # everforest theme
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
      "hdokiejnpimakedhajhdlcegeplioahd" # lastpass
      "dhdgffkkebhmkfjojejmpbldmpobfkfo" # tampermonkey
      "bpoadfkcbjbfhfodiogcnhhhpibjhbnh" # immersive translate
      "hfjbmagddngcpeloejdejnfgbamkjaeg" # vimium c
      "bkdgflcldnnnapblkhphbgpggdiikppg" # duck duck go
    ];
    extraOpts = {
      "RestoreOnStartup" = 1;
      "BackgroundModeEnabled" = false;
    };
  };

  # ── 本地化与系统 ──
  time = {
    timeZone = "Asia/Singapore";
  };
  i18n.defaultLocale = "en_SG.UTF-8";
  i18n.extraLocaleSettings.LANGUAGE = "en_SG:en";
  i18n.supportedLocales = [
    "en_SG.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.configurationLimit = 8;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  system.stateVersion = "25.05";
}
