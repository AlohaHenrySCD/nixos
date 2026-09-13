{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
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

  services.dbus.enable = true;

  services.tailscale.enable = true;

  # services.nirinit = {
  #   enable = true;
  #   settings = {
  #     launch = {
  #       "chromium-example.com__-Default" = "example-web-app";
  #     };
  #   };
  # };

  # swapDevices = [
  #   {
  #     device = "/var/lib/swapfile";
  #     size = 4*1024;
  #   }
  # ];

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [
          "*"
          "-1d50:615e" # pskeeb5 uses its own ZMK keymap.
        ];
        settings = {
          main = {
            capslock = "esc";
            esc = "f12";
          };
        };
      };
    };
  };

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];
  # ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  programs.niri.enable = true;
  services.greetd.enable = false;
  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    defaultSession = "niri";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       user = "alohahenry";
  #       command = "${config.programs.niri.package}/bin/niri-session";
  #     };
  #   };
  # };
  systemd.user.services.niri.enableDefaultPath = false;

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;

  };

  programs.kdeconnect.enable = true;

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  programs.fish.enable = true;

  programs.chromium = {
    enable = true;
    extensions = [
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
    enable = true;
    wheelNeedsPassword = false;
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
  # hardware.opengl.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.openrazer.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  nix.settings = {
    max-jobs = 16;
    experimental-features = [
      "flakes"
      "nix-command"
    ];
  };

  time = {
    timeZone = "Asia/Shanghai";
  };

  # services.clatd.enable = true;
  networking = {
    # hostName = "alohahenry";
    networkmanager.enable = true;
    networkmanager.wifi.backend = "wpa_supplicant";
    networkmanager.unmanaged = [
      "Mihomo"
      "Meta"
    ];
    # networkmanager.settings = {
    #   main.ndisc = "external";
    # };
    # networkmanager.ensureProfiles.profiles = {
    #   "wlan0" = {
    #     connection = {
    #       id = "wlan0";
    #       type = "wifi";
    #     };
    #     ipv4 = {
    #       method = "auto";
    #     };
    #     ipv6 = {
    #       method = "auto";
    #       # addr-gen-mode = "stable-privacy";
    #       ndisc = "kernel";
    #     };
    #   };
    # };
    # networkmanager.dhcp = true;
    enableIPv6 = true;
    # useDHCP = true;
    # dhcpcd.persistent = true;
    # wireless.iwd = {
    #   enable = true;
    #   settings.General.EnableNetworkConfiguration = true;
    # };
  };

  programs.starship.enable = true;

  environment.systemPackages = with pkgs; [
    # moved
    # base
    # mesa
    gtk4.dev
    gsettings-desktop-schemas
    xwayland-satellite

    # gaming
    # sbclPackages.frpc
    # frpc
    # glfw
  ];

  environment.sessionVariables = lib.mkForce {
    LC_MESSAGES = "zh_CN.UTF-8";
    LC_ALL = "zh_CN.UTF-8";
    LC_COLLATE = "zh_CN.UTF-8";
    LANG = "zh_CN.UTF-8";
  };

  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  users.mutableUsers = true;

  system.stateVersion = "25.05";
}
