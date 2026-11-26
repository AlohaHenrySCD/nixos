{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  inherit (theme) palette;
  fontSettings = theme.fonts.waybar;
  inherit (fontSettings) iconSize;
  icon = glyph: "<span font_family=\"${fontSettings.iconFamily}\">${glyph}</span>";
  systemMonitor = "${pkgs.kitty}/bin/kitty --title 'System Monitor' -e ${pkgs.btop}/bin/btop";

  appAudio = pkgs.writeShellScript "waybar-app-audio" ''
    export PATH=${lib.makeBinPath (with pkgs; [
      pipewire wireplumber niri fuzzel kitty wiremix pavucontrol procps
    ])}:$PATH
    exec ${pkgs.python3}/bin/python3 ${./waybar-app-audio.py} "$@"
  '';

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
      # https://github.com/Alexays/Waybar/issues/5356
      preCheck = (old.preCheck or "") + ''
        mesonCheckFlagsArray+=('--test-args=~"SleeperThread control flags are stable under concurrent wake and stop"')
      '';
      postPatch = (old.postPatch or "") + ''
        substituteInPlace src/modules/upower.cpp \
          --replace-fail 'upDevice_.icon_name = (icon_name != NULL) ? icon_name : "";' 'upDevice_.icon_name = (icon_name != NULL) ? icon_name : "";
        if (upDevice_.kind == UP_DEVICE_KIND_BATTERY) {
          const int percentage = CLAMP(static_cast<int>(std::round(upDevice_.percentage)), 0, 100);
          const int level = ((percentage + 5) / 10) * 10;
          const bool charging = upDevice_.state == UP_DEVICE_STATE_CHARGING;
          const auto iconName = charging && level == 100
              ? std::string("battery-full-charging-symbolic")
              : fmt::format("battery-level-{}{}-symbolic", level, charging ? "-charging" : "");
          if (gtkTheme_->has_icon(iconName)) {
            upDevice_.icon_name = iconName;
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
      height = 32;
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
        "custom/clipboard"
        "network"
        "bluetooth"
        "custom/app-audio"
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
          obsidian_status_icon_1 = "${config.xdg.dataHome}/flatpak/exports/share/icons/hicolor/512x512/apps/md.obsidian.Obsidian.png";
        }
        // lib.optionalAttrs (pkgs ? steam-asahi) {
          Steam = "${pkgs.steam-asahi}/share/icons/hicolor/48x48/apps/steam.png";
        };
      };

      "niri/workspaces" = {
        format = "{value}";
      };

      "cffi/niri-windows" = {
        module_path = "${pkgs.waybar-niri-windows}/lib/waybar-niri-windows.so";
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

      "custom/clipboard" = {
        exec = "clipboard-history status";
        return-type = "json";
        interval = 5;
        signal = 9;
        escape = true;
        on-click = "clipboard-history pick";
        on-click-right = "clipboard-history menu";
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
        format = "${icon "󰋊"} {specific_free:.0f}G";
        unit = "GB";
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
        format-wifi = "${icon "{icon}"}";
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        format-linked = "${icon "󰖩"} …";
        format-disconnected = "${icon "󰖪"}";
        format-disabled = "${icon "󰖪"}";
        tooltip-format-wifi = "{essid}\n{ipaddr} · 信号 {signalStrength}%";
        tooltip-format-disconnected = "Wi-Fi 未连接";
        tooltip-format-disabled = "Wi-Fi 已关闭";
        on-click = "${pkgs.kitty}/bin/kitty --title 'Wi-Fi' -e ${pkgs.networkmanager}/bin/nmtui";
        on-click-right = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
      };

      bluetooth = {
        format = "${icon ""}";
        format-disabled = "${icon "󰂲"}";
        format-off = "${icon "󰂲"}";
        format-connected = "${icon ""} {num_connections}";
        tooltip-format = "蓝牙 {status}";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}";
        on-click = "${pkgs.blueman}/bin/blueman-manager";
      };

      "custom/app-audio" = {
        exec = "${appAudio} status";
        return-type = "json";
        interval = 2;
        signal = 8;
        escape = true;
        on-click = "${appAudio} menu";
        on-click-right = "${appAudio} mute";
        on-click-middle = "${appAudio} mixer";
        on-scroll-up = "${appAudio} volume up";
        on-scroll-down = "${appAudio} volume down";
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
        on-click = "${appAudio} mixer";
        on-click-middle = "${pkgs.pavucontrol}/bin/pavucontrol";
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
      @define-color bg ${palette.bg0};
      @define-color bg_alt ${palette.bg1};
      @define-color fg ${palette.fg};
      @define-color muted ${palette.grey1};
      @define-color green ${palette.green};
      @define-color aqua ${palette.aqua};
      @define-color blue ${palette.blue};
      @define-color yellow ${palette.yellow};
      @define-color red ${palette.red};

      * {
        font-family: ${fontSettings.family};
        font-size: ${toString fontSettings.textSize}px;
        font-weight: ${toString fontSettings.weight};
        padding: 0;
        margin: 0;
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

      #mpris, #custom-input-method, #custom-clipboard, #custom-system, #disk, #memory,
      #cpu, #network, #bluetooth, #custom-app-audio, #pulseaudio, #upower, #clock {
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
      }
      .cffi-niri-windows .tile:active { background: @green; color: @bg; }
      .cffi-niri-windows .tile.urgent { background: @red; color: @bg; }
      #mpris { color: @aqua; }
      #mpris.paused, #mpris.stopped { color: @muted; }
      #custom-input-method { color: @yellow; }
      #custom-input-method.active { color: @green; }
      #custom-input-method.offline { color: @muted; }
      #custom-clipboard { font-family: "${fontSettings.iconFamily}"; color: @aqua; }
      #custom-clipboard.empty { color: @muted; }
      #system { border-radius: 5px; margin: 1px 0; }
      #system #custom-system, #system #disk, #system #memory, #system #cpu { margin: 0; }
      #custom-system, #memory { color: @aqua; }
      #disk, #upower { color: @green; }
      #upower image { margin-right: 4px; }
      #custom-app-audio { color: @aqua; }
      #custom-app-audio.muted { color: @muted; }
      #custom-app-audio.empty { padding: 0; margin: 0; }
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
