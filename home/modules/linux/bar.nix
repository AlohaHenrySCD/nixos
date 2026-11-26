{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  fontSettings = theme.fonts.waybar;
in
{
  programs.waybar = {
    # ── Waybar 包与补丁 ──
    enable = true;
    # upower.cpp 按 10% 选择主题的电池符号图标；上游支持相同步进后可移除补丁。
    # 跳过 #5356 的并发测试仅用于源码构建，恢复使用预构建包或上游修复后可移除。
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

    # ── 顶栏布局与模块 ──
    systemd = {
      enable = true;
      targets = [ "niri.service" ];
    };

    settings.mainBar =
      let
        inherit (fontSettings) iconSize;
        icon = glyph: "<span font_family=\"${fontSettings.iconFamily}\">${glyph}</span>";
        systemMonitor = "${pkgs.kitty}/bin/kitty --title 'System Monitor' -e ${pkgs.btop}/bin/btop";

        appAudio = pkgs.writeShellScript "waybar-app-audio" ''
          export PATH=${
            lib.makeBinPath (
              with pkgs;
              [
                pipewire
                wireplumber
                niri
                fuzzel
                kitty
                wiremix
                pavucontrol
                procps
              ]
            )
          }:$PATH
          exec ${pkgs.python3}/bin/python3 ${./waybar-app-audio.py} "$@"
        '';
      in
      {
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

        # ── 状态栏模块 ──
        "group/tray" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 250;
            transition-left-to-right = false;

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
                app-id = "(?i)(vlc|haruna)$";
                class = "video";
                icon = "";
              }
              {
                app-id = "(?i)(vesktop|halloy)$";
                class = "chat";
                icon = "";
              }
              {
                app-id = "(?i)papers$";
                class = "document";
                icon = "";
              }
              {
                app-id = "(?i)qbittorrent$";
                class = "download";
                icon = "";
              }
              {
                app-id = "(?i)prismlauncher$";
                class = "game";
                icon = "";
              }
              {
                app-id = "(?i)bazecor$";
                class = "keyboard";
                icon = "";
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
          exec = lib.getExe (
            pkgs.writeShellApplication {
              name = "waybar-input-method";
              runtimeInputs = [
                pkgs.fcitx5
                pkgs.jq
              ];
              text = builtins.readFile ./waybar-input-method.sh;
            }
          );
          return-type = "json";
          interval = 1;

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

    style =
      builtins.replaceStrings
        [ "@fontFamily@" "@fontSize@" "@fontWeight@" "@iconFamily@" ]
        [
          fontSettings.family
          (toString fontSettings.textSize)
          (toString fontSettings.weight)
          fontSettings.iconFamily
        ]
        (theme.render ./waybar.css);
  };

  # ── 关联服务 ──
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

  systemd.user.services.waybar = {
    Unit = {
      Wants = [ "playerctld.service" ];
      After = [ "playerctld.service" ];
    };
    Install.WantedBy = lib.mkForce [ "niri.service" ];
  };
}
