{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      # Keep Chromium's encryption backend identical in Plasma and niri.
      chromium = prev.chromium.override {
        commandLineArgs = "--password-store=kwallet6";
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

  # Bazecor checks this exact filename and content before requesting root access.
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
  ];

  # services.tailscale.enable = true;

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
          "m:1532:00b8" # Razer Viper V3 HyperSpeed
          "m:35ef:0031" # Sonsei-BLE - 3
          "m:3554:fa09" # Compx 2.4G Wireless Receiver
        ];
        settings = {
          main = {
            capslock = "C-S-f12";
            mouse1 = "layer(control)";
            mouse2 = "layer(meta)";
            mouseback = "layer(control)";
            mouseforward = "layer(meta)";
          };
        };
      };
      internal = {
        ids = [ "05ac:0342:89b7fedc" ];
        settings = {
          main = {
            capslock = "backspace";
            backspace = "C-S-f12";
            esc = "C-S-f12";
            leftshift = "esc";
            rightshift = "delete";
            # Previously disabled: leftmeta = "layer(symbol)";
            leftmeta = "layer(symbol)";
            rightmeta = "layer(plain)";
            a = "overloadt2(nav, a, 160)";
            s = "overloadt2(meta, s, 160)";
            d = "overloadt2(control, d, 160)";
            f = "overloadt2(shift, f, 160)";
            j = "overloadt2(shift, j, 160)";
            k = "overloadt2(control, k, 160)";
            l = "overloadt2(meta, l, 160)";
            semicolon = "overloadt2(num, semicolon, 160)";
          };

          plain = {
            a = "a";
            s = "s";
            d = "d";
            f = "f";
            j = "j";
            k = "k";
            l = "l";
            semicolon = "semicolon";
          };

          # https://newblog.alohahenry.top/posts/my-symbol-layer/
          symbol = {
            q = "`";
            w = "<";
            e = ">";
            r = "-";
            t = "$";
            y = "^";
            u = "{";
            i = "}";
            o = "|";
            p = "'";
            a = "!";
            s = ":";
            d = "_";
            f = "=";
            g = "&";
            h = "#";
            j = "(";
            k = ")";
            l = "\"";
            semicolon = ";";
            z = "~";
            x = "?";
            c = "[";
            v = "]";
            b = "+";
            n = "\\";
            m = "*";
            comma = ",";
            dot = ".";
            slash = "/";
            leftalt = "%";
            rightalt = "@";
          };

          nav = {
            q = "kbdillumdown";
            w = "kbdillumup";
            e = "scrollup";
            r = "C-S-u";
            t = "middlemouse";
            y = "C-u";
            u = "noop";
            i = "noop";
            o = "noop";
            p = "noop";
            a = "noop";
            s = "noop";
            d = "scrolldown";
            f = "C-S-d";
            g = "leftmouse";
            h = "C-d";
            j = "left";
            k = "down";
            l = "up";
            semicolon = "right";
            z = "noop";
            x = "noop";
            c = "C-S-c";
            v = "C-S-v";
            b = "rightmouse";
            n = "^";
            m = "home";
            comma = "pagedown";
            dot = "pageup";
            slash = "end";
          };

          num = {
            q = "f12";
            w = "f9";
            e = "f8";
            r = "f7";
            t = "noop";
            y = "noop";
            u = "7";
            i = "8";
            o = "9";
            p = "noop";
            a = "f10";
            s = "f3";
            d = "f2";
            f = "f1";
            g = "noop";
            h = "0";
            j = "1";
            k = "2";
            l = "3";
            semicolon = "noop";
            z = "f11";
            x = "f6";
            c = "f5";
            v = "f4";
            b = "noop";
            n = "noop";
            m = "4";
            comma = "5";
            dot = "6";
            slash = "noop";
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
  # Plasma supplies KWallet and PAM unlock for both SDDM sessions.
  services.gnome.gnome-keyring.enable = false;
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
    tunMode = false;

  };

  programs.kdeconnect.enable = true;

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    config.niri."org.freedesktop.impl.portal.Secret" = lib.mkForce "kwallet";
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
    # wheelNeedsPassword = false;
    wheelNeedsPassword = true;
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

  nix.channel.enable = false;

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
