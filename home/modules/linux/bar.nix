{
  lib,
  pkgs,
  ...
}:
let
  fontSettings = (import ../../../fonts.nix { inherit pkgs; }).waybar;
  inherit (fontSettings) iconSize networkIconSize bluetoothIconSize;
  sizedIcon =
    size: glyph: "<span font_desc=\"${fontSettings.iconFamily} ${toString size}px\">${glyph}</span>";
  icon = sizedIcon iconSize;
  systemMonitor = "${pkgs.kitty}/bin/kitty --title 'System Monitor' -e ${pkgs.btop}/bin/btop";

  gtkBindings = pkgs.fetchurl {
    name = "gotk3-ff349ae13f56.tar.gz";
    url = "https://codeload.github.com/gotk3/gotk3/tar.gz/ff349ae13f56";
    hash = "sha256-43CFmFJIxpqLQp436y6+4xorD2u9gxDcFUBQmF/MawQ=";
  };

  niriWindows = pkgs.stdenv.mkDerivation {
    pname = "waybar-niri-windows";
    version = "2.3.1";

    src = pkgs.fetchurl {
      name = "waybar-niri-windows-2.3.1.tar.gz";
      url = "https://codeload.github.com/calico32/waybar-niri-windows/tar.gz/refs/tags/v2.3.1";
      hash = "sha256-C/GA8iuKfHbgvHJw5r9fS/Ru4QHvKnYGuOzk7AfYzN8=";
    };

    nativeBuildInputs = [
      pkgs.go
      pkgs.pkg-config
    ];
    buildInputs = [ pkgs.gtk3 ];
    strictDeps = true;

    env = {
      CGO_ENABLED = "1";
      GOTOOLCHAIN = "local";
      GOPROXY = "off";
      GOSUMDB = "off";
    };

    postPatch = ''
      substituteInPlace module/module.go \
        --replace-fail \
        'i.calculateWindowSizes(column, scale, maxHeight-i.config.ColumnBorders)' \
        'i.calculateWindowSizes(column, scale*1.5, maxHeight-i.config.ColumnBorders)'
    '';

    buildPhase = ''
      runHook preBuild
      export GOCACHE="$TMPDIR/go-cache"
      export GOPATH="$TMPDIR/go"
      mkdir -p .deps/gotk3
      tar -xf ${gtkBindings} --strip-components=1 -C .deps/gotk3
      go mod edit -replace github.com/gotk3/gotk3=./.deps/gotk3
      go build -trimpath -ldflags="-s -w -buildid=" \
        -buildmode=c-shared -o waybar-niri-windows.so ./main
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 waybar-niri-windows.so "$out/lib/waybar-niri-windows.so"
      runHook postInstall
    '';

    meta = {
      description = "Niri window minimap for Waybar";
      homepage = "https://github.com/calico32/waybar-niri-windows";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };

  inputMethod = pkgs.writeShellScript "waybar-input-method" ''
    state=$(${pkgs.fcitx5}/bin/fcitx5-remote --check 2>/dev/null || true)
    name=$(${pkgs.fcitx5}/bin/fcitx5-remote --check -n 2>/dev/null || true)

    case "$state" in
      1) text="EN"; class="inactive" ;;
      2)
        class="active"
        case "$name" in
          rime) text="中" ;;
          mozc) text="あ" ;;
          keyboard-*) text="EN"; class="inactive" ;;
          *) text="$name" ;;
        esac
        ;;
      *) text="IME"; class="offline" ;;
    esac

    ${pkgs.jq}/bin/jq -cn \
      --arg text "$text" \
      --arg class "$class" \
      --arg tooltip "Fcitx5: $name" \
      '{text: $text, class: $class, tooltip: $tooltip}'
  '';
in
{
  home.packages = [ niriWindows ];
  services.playerctld.enable = true;

  systemd.user.services.xembed-sni-proxy = {
    Unit = {
      Description = "Expose X11 tray icons to Waybar";
      After = [
        "niri.service"
        "waybar.service"
      ];
      PartOf = [ "niri.service" ];
    };
    Service = {
      ExecStart = "${pkgs.kdePackages.plasma-workspace}/bin/xembedsniproxy";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "niri.service" ];
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace src/modules/upower.cpp \
          --replace-fail '"model", &upDevice_.model, NULL);' '"model", &upDevice_.model, NULL);
        if (upDevice_.kind == UP_DEVICE_KIND_BATTERY) {
          const int percentage = CLAMP(static_cast<int>(std::round(upDevice_.percentage)), 0, 100);
          const int level = ((percentage + 5) / 10) * 10;
          const bool charging = upDevice_.state == UP_DEVICE_STATE_CHARGING;
          const auto iconName = charging && level == 100
              ? std::string("battery-full-charging-symbolic")
              : fmt::format("battery-level-{}{}-symbolic", level, charging ? "-charging" : "");
          if (gtkTheme_->has_icon(iconName)) {
            g_free(upDevice_.icon_name);
            upDevice_.icon_name = g_strdup(iconName.c_str());
          }
        }'
      '';
    });
    systemd = {
      enable = true;
      targets = [ "niri.service" ];
    };

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 26;
      spacing = 4;
      fixed-center = false;
      no-center = true;
      modules-center = [ ];

      modules-left = [
        "niri/workspaces"
        "group/system"
        "cffi/niri-windows"
      ];
      modules-right = [
        "mpris"
        "custom/input-method"
        "network"
        "bluetooth"
        "pulseaudio"
        "upower"
        "group/tray"
        "clock"
      ];

      "group/tray" = {
        orientation = "horizontal";
        drawer = {
          transition-duration = 250;
          transition-left-to-right = false;
          # click-to-reveal = true;
          click-to-reveal = false;
        };
        modules = [
          "custom/tray"
          "tray"
        ];
      };

      "custom/tray" = {
        format = "${icon "▸"}";
        tooltip = false;
      };

      tray = {
        icon-size = iconSize;
        spacing = 8;
        icons = {
          Steam = "${pkgs.steam-asahi}/share/icons/hicolor/48x48/apps/steam.png";
          obsidian_status_icon_1 = "${pkgs.obsidian.override { electron = pkgs.electron_44; }}/share/icons/hicolor/48x48/apps/obsidian.png";
        };
      };

      "niri/workspaces" = {
        format = "{value}";
      };

      "cffi/niri-windows" = {
        module_path = "${niriWindows}/lib/waybar-niri-windows.so";
        options = {
          mode = "graphical";
          show-floating = "auto";
          minimum-size = 4;
          spacing = 2;
          icon-minimum-size = iconSize;
          on-tile-click = "FocusWindow";
          on-tile-middle-click = "";
          on-tile-right-click = "";
          rules = [
            {
              app-id = "(?i)kitty|alacritty|wezterm";
              class = "terminal";
              icon = "";
            }
            {
              app-id = "(?i)chromium|chrome";
              class = "browser";
              icon = "";
            }
            {
              app-id = "(?i)firefox";
              class = "browser";
              icon = "";
            }
            {
              app-id = "(?i)obsidian";
              class = "notes";
              icon = "";
            }
            {
              app-id = "(?i)netease|spotify|ncspot";
              class = "music";
              icon = "";
            }
            {
              app-id = "(?i)dolphin|nautilus";
              class = "files";
              icon = "";
            }
            {
              app-id = ".*";
              class = "application";
              icon = "";
            }
          ];
        };
      };

      mpris = {
        format = "${icon "{status_icon}"} {dynamic}";
        status-icons = {
          playing = "";
          paused = "";
          stopped = "";
        };
        dynamic-order = [ "title" ];
        title-len = 13;
        dynamic-len = 13;
        max-length = 15;
        tooltip-format = "{player}\n{title}\n{artist}";
      };

      "custom/input-method" = {
        exec = "${inputMethod}";
        return-type = "json";
        interval = 1;
        # format = "${icon "󰌌"} {}";
        format = "{}";
        max-length = 12;
        escape = true;
        on-click = "${pkgs.fcitx5}/bin/fcitx5-remote --check -t";
        on-click-right = "${pkgs.qt6Packages.fcitx5-configtool}/bin/fcitx5-configtool";
      };

      "group/system" = {
        orientation = "horizontal";
        drawer = {
          transition-duration = 250;
          click-to-reveal = true;
        };
        modules = [
          "custom/system"
          "disk"
          "memory"
          "cpu"
        ];
      };

      "custom/system" = {
        format = "${icon "󰍹"}";
        tooltip = false;
      };

      disk = {
        format = "${icon "󰋊"} {percentage_used}%";
        tooltip-format = "已用 {used} / {total}\n可用 {free}";
        on-click = systemMonitor;
      };

      memory = {
        interval = 3;
        format = "${icon "󰘚"} {percentage}%";
        tooltip-format = "内存 {used:.1f} / {total:.1f} GiB\n交换空间 {swapUsed:.1f} / {swapTotal:.1f} GiB";
        states = {
          warning = 80;
          critical = 95;
        };
        on-click = systemMonitor;
      };

      cpu = {
        interval = 3;
        format = "${icon ""} {usage}%";
        tooltip-format = "CPU {usage}%\n负载 {load}";
        states = {
          warning = 80;
          critical = 95;
        };
        on-click = systemMonitor;
      };

      network = {
        interface = "wl*";
        interval = 5;
        format-wifi = "${sizedIcon networkIconSize "{icon}"}";
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        format-linked = "${sizedIcon networkIconSize "󰖩"} …";
        format-disconnected = "${sizedIcon networkIconSize "󰖪"}";
        format-disabled = "${sizedIcon networkIconSize "󰖪"}";
        tooltip-format-wifi = "{essid}\n{ipaddr} · 信号 {signalStrength}%";
        tooltip-format-disconnected = "Wi-Fi 未连接";
        tooltip-format-disabled = "Wi-Fi 已关闭";
        on-click = "${pkgs.kitty}/bin/kitty --title 'Wi-Fi' -e ${pkgs.networkmanager}/bin/nmtui";
        on-click-right = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
      };

      bluetooth = {
        format = "${sizedIcon bluetoothIconSize ""}";
        format-disabled = "${sizedIcon bluetoothIconSize "󰂲"}";
        format-off = "${sizedIcon bluetoothIconSize "󰂲"}";
        format-connected = "${sizedIcon bluetoothIconSize ""} {num_connections}";
        tooltip-format = "蓝牙 {status}";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}";
        on-click = "${pkgs.blueman}/bin/blueman-manager";
      };

      pulseaudio = {
        format = "${icon "{icon}"} {volume}%";
        format-muted = "${icon "󰝟"}";
        format-icons = {
          headphone = "󰋋";
          headset = "󰋎";
          default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
        };
        scroll-step = 2;
        tooltip-format = "{desc}";
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        on-click-right = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      upower = {
        format = "{percentage}";
        format-alt = "{percentage} {time}";
        min-length = 4;
        align = 0.5;
        icon-size = iconSize;
        hide-if-empty = true;
        tooltip = true;
      };

      clock = {
        interval = 60;
        format = "{:%m/%d %a %H:%M}";
        tooltip-format = "<big>{:%Y年%m月}</big>\n<tt><small>{calendar}</small></tt>";
      };
    };

    style = ''
      @define-color bg #2d353b;
      @define-color bg_alt #343f44;
      @define-color fg #d3c6aa;
      @define-color muted #859289;
      @define-color green #a7c080;
      @define-color aqua #83c092;
      @define-color blue #7fbbb3;
      @define-color yellow #dbbc7f;
      @define-color red #e67e80;

      * {
        font-family: ${fontSettings.family};
        font-size: ${toString fontSettings.textSize}px;
        font-weight: ${toString fontSettings.weight};
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: @bg;
        color: @fg;
      }

      .modules-left { margin-left: 6px; }
      .modules-right { margin-right: 6px; }

      tooltip {
        background: @bg_alt;
        border: 1px solid @muted;
        border-radius: 6px;
      }

      tooltip label { color: @fg; }

      #workspaces button {
        padding: 0 10px;
        margin: 1px 2px;
        border-radius: 5px;
        color: @muted;
        background: transparent;
        box-shadow: none;
        text-shadow: none;
      }

      #workspaces button.active { color: @fg; }
      #workspaces button.focused { background: @green; color: @bg; }
      #workspaces button.urgent { background: @red; color: @bg; }

      #mpris, #custom-input-method, #custom-system, #disk, #memory,
      #cpu, #network, #bluetooth, #pulseaudio, #upower, #clock {
        padding: 0 8px;
        margin: 1px 0;
        border-radius: 5px;
      }

      .cffi-niri-windows { margin: 1px 0; }
      #custom-tray { padding: 0 4px; color: @muted; }
      #tray { padding: 0 6px; }
      .cffi-niri-windows .column, .cffi-niri-windows .floating { margin: 0 2px; }
      .cffi-niri-windows .tile { background: @bg_alt; color: @fg; border-radius: 3px; }
      .cffi-niri-windows .tile label {
        font-family: "${fontSettings.iconFamily}";
        font-size: ${toString iconSize}px;
      }
      .cffi-niri-windows .tile:active { background: @green; color: @bg; }
      .cffi-niri-windows .tile.urgent { background: @red; color: @bg; }
      #mpris { color: @aqua; }
      #mpris.paused, #mpris.stopped { color: @muted; }
      #custom-input-method { color: @yellow; }
      #custom-input-method.active { color: @green; }
      #custom-input-method.offline { color: @muted; }
      #system { border-radius: 5px; margin: 1px 0; }
      #system #custom-system, #system #disk, #system #memory, #system #cpu { margin: 0; }
      #custom-system, #memory { color: @aqua; }
      #disk, #upower { color: @green; }
      #upower image { margin-right: 4px; }
      #upower label {
        font-size: ${toString fontSettings.textSize}px;
        padding: 0;
        margin: 0;
      }
      #cpu, #pulseaudio { color: @yellow; }
      #network, #bluetooth { color: @blue; }
      #clock { color: @fg; background: @bg_alt; }

      #network.disconnected, #network.disabled, #bluetooth.off,
      #bluetooth.disabled, #pulseaudio.muted { color: @muted; }
      #cpu.warning, #memory.warning { color: @yellow; }
      #cpu.critical, #memory.critical { color: @red; }

    '';
  };

  systemd.user.services.waybar = {
    Unit = {
      Wants = [ "playerctld.service" ];
      After = [ "playerctld.service" ];
    };
    Install.WantedBy = lib.mkForce [ "niri.service" ];
  };
}
