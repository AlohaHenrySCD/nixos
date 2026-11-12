{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/keyd.nix
    ./modules/nirinit.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      # Keep Chromium's encryption backend identical in Plasma and niri.
      chromium = prev.chromium.override {
        commandLineArgs = "--password-store=kwallet6 --blink-settings=preferredColorScheme=1";
      };
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (pythonFinal: pythonPrev: {
          nanoemoji = pythonPrev.nanoemoji.overrideAttrs (oldAttrs: {
            version = "0.16.0";
            src = prev.fetchFromGitHub {
              owner = "googlefonts";
              repo = "nanoemoji";
              rev = "v0.16.0";
              hash = "sha256-FysyKC01XBnRiur5RR9fcsTxQqE8x0JJHSoe3q6JtKc=";
            };
            doCheck = false;
          });
        })
      ];
    })
  ];
  nixpkgs.config.allowUnsupportedSystem = true;
  users.users.alohahenry = {
    isNormalUser = true;
    home = "/home/alohahenry";
    extraGroups = [
      "video"
      "input"
      "wheel"
      "networkmanager"
      "openrazer"
    ];
  };
  nixpkgs.config.allowUnfree = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-fluent
      (fcitx5-rime.override {
        rimeDataPkgs = [ pkgs.rime-ice ];
      })
    ];
  };

  # some helix plugins
  #     notify
  #     oil
  #     breadcrumbs
  #     fake-warp
  #     smooth-scroll
  #     forest
  #     glyph
  #     show-keys
  #     moka

  # brightness controll
  hardware.brillo.enable = true;

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

  # services.tailscale.enable = true;

  # swapDevices = [
  #   {
  #     device = "/var/lib/swapfile";
  #     size = 4*1024;
  #   }
  # ];

  fonts.packages = (import ./fonts.nix { inherit pkgs; }).packages;

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

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;
  };

  xdg.portal = {
    config.niri."org.freedesktop.impl.portal.Secret" = lib.mkForce "kwallet";
    config.niri."org.freedesktop.impl.portal.FileChooser" = "kde";
    config.common.default = "*";
  };

  programs.fish.enable = true;

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
    # override.commandLineArgs = [
    #   "--extensions-on-chrome-urls --extensions-on-extension-urls"
    # ];
    extraOpts = {
      "RestoreOnStartup" = 1;
      "BackgroundModeEnabled" = false;
    };
  };

  users.extraUsers.alohahenry = {
    shell = pkgs.fish;
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

  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.configurationLimit = 8;
  };

  hardware.graphics.enable = true;
  hardware.bluetooth = {
    enable = true;
  };

  hardware.openrazer.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  nix.channel.enable = false;

  nix.settings = {
    max-jobs = 16;
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30"
    ];
    experimental-features = [
      "flakes"
      "nix-command"
    ];
  };

  time = {
    timeZone = "Asia/Macau";
  };

  networking = {
    networkmanager.enable = true;
    networkmanager.unmanaged = [
      "Mihomo"
      "Meta"
    ];
  };

  programs.starship.enable = true;

  environment.systemPackages = with pkgs; [
    # mesa
    gtk4.dev
    gsettings-desktop-schemas
    xwayland-satellite

    # glfw
  ];

  i18n.extraLocaleSettings.LANGUAGE = "en_US:en";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "25.05";
}
