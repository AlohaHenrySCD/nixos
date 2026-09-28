{
  lib,
  pkgs,
  ...
}:
let
  systemMonitor = "${pkgs.kitty}/bin/kitty --title 'System Monitor' -e ${pkgs.btop}/bin/btop";

  inputMethod = pkgs.writeShellScript "waybar-input-method" ''
    state=$(${pkgs.fcitx5}/bin/fcitx5-remote --check 2>/dev/null || true)
    name=$(${pkgs.fcitx5}/bin/fcitx5-remote --check -n 2>/dev/null || true)

    case "$state" in
      1) text="EN"; class="inactive" ;;
      2)
        class="active"
        case "$name" in
          rime) text="Rime" ;;
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
      --arg tooltip "Fcitx5: $name · 左键切换输入法，右键设置" \
      '{text: $text, class: $class, tooltip: $tooltip}'
  '';
in
{
  programs.waybar = {
    enable = true;
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
        "niri/window"
        "custom/input-method"
      ];
      modules-right = [
        "group/system"
        "network"
        "bluetooth"
        "pulseaudio"
        "upower"
        "clock"
      ];

      "niri/workspaces" = {
        format = "{value}";
        all-outputs = false;
        disable-click = false;
      };

      "niri/window" = {
        format = "{title}";
        icon = true;
        icon-size = 16;
        max-length = 24;
        separate-outputs = true;
        on-click = "${pkgs.niri}/bin/niri msg action toggle-overview";
      };

      "custom/input-method" = {
        exec = "${inputMethod}";
        return-type = "json";
        interval = 1;
        format = "󰌌 {}";
        max-length = 12;
        escape = true;
        on-click = "${pkgs.fcitx5}/bin/fcitx5-remote --check -t";
        on-click-right = "${pkgs.qt6Packages.fcitx5-configtool}/bin/fcitx5-configtool";
      };

      "group/system" = {
        orientation = "horizontal";
        drawer = {
          transition-duration = 250;
          transition-left-to-right = false;
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
        format = "󰍹";
        tooltip-format = "点击展开 / 收起系统信息\n点击指标打开系统监视器";
      };

      disk = {
        path = "/";
        interval = 30;
        format = "󰋊 {percentage_used}%";
        tooltip-format = "硬盘 {path}\n已用 {used} / {total}\n可用 {free}";
        on-click = systemMonitor;
      };

      memory = {
        interval = 3;
        format = "󰘚 {percentage}%";
        tooltip-format = "内存 {used:.1f} / {total:.1f} GiB\n交换空间 {swapUsed:.1f} / {swapTotal:.1f} GiB";
        states = {
          warning = 80;
          critical = 95;
        };
        on-click = systemMonitor;
      };

      cpu = {
        interval = 3;
        format = " {usage}%";
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
        format-wifi = "󰖩 {signalStrength}%";
        format-linked = "󰖩 …";
        format-disconnected = "󰖪";
        format-disabled = "󰖪";
        tooltip-format-wifi = "{essid}\n{ipaddr} · 信号 {signalStrength}%\n左键连接 Wi-Fi，右键编辑网络";
        tooltip-format-disconnected = "Wi-Fi 未连接 · 左键选择网络";
        tooltip-format-disabled = "Wi-Fi 已关闭 · 左键设置";
        on-click = "${pkgs.kitty}/bin/kitty --title 'Wi-Fi' -e ${pkgs.networkmanager}/bin/nmtui";
        on-click-right = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
      };

      bluetooth = {
        format = "";
        format-disabled = "󰂲";
        format-off = "󰂲";
        format-connected = " {num_connections}";
        tooltip-format = "蓝牙 {status}\n点击管理蓝牙设备";
        tooltip-format-connected = "{device_enumerate}\n点击管理蓝牙设备";
        tooltip-format-enumerate-connected = "{device_alias}";
        on-click = "${pkgs.blueman}/bin/blueman-manager";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟";
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
        max-volume = 100;
        tooltip-format = "{desc}\n左键音频设置 · 右键静音 · 滚轮调节音量";
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        on-click-right = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      upower = {
        format = "{percentage}";
        format-alt = "{percentage} {time}";
        icon-size = 16;
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
        font-family: "JetBrainsMono Nerd Font", "Noto Sans CJK SC", sans-serif;
        font-size: 13px;
        font-weight: 600;
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
        margin: 4px 2px;
        border-radius: 5px;
        color: @muted;
        background: transparent;
        box-shadow: none;
        text-shadow: none;
      }

      #workspaces button.active { color: @fg; }
      #workspaces button.focused { background: @green; color: @bg; }
      #workspaces button.urgent { background: @red; color: @bg; }
      #workspaces button:hover { background: @bg_alt; color: @fg; }

      #window, #custom-input-method, #custom-system, #disk, #memory,
      #cpu, #network, #bluetooth, #pulseaudio, #upower, #clock {
        padding: 0 8px;
        margin: 4px 0;
        border-radius: 5px;
      }

      #window { color: @fg; }
      window#waybar.empty #window { padding: 0; margin: 0; }
      #custom-input-method { color: @yellow; background: @bg_alt; }
      #custom-input-method.active { color: @green; }
      #custom-input-method.offline { color: @muted; }
      #system { background: @bg_alt; border-radius: 5px; margin: 4px 0; }
      #system #custom-system, #system #disk, #system #memory, #system #cpu { margin: 0; }
      #custom-system, #memory { color: @aqua; }
      #disk, #upower { color: @green; }
      #cpu, #pulseaudio { color: @yellow; }
      #network, #bluetooth { color: @blue; }
      #clock { color: @fg; background: @bg_alt; }

      #network.disconnected, #network.disabled, #bluetooth.off,
      #bluetooth.disabled, #pulseaudio.muted { color: @muted; }
      #cpu.warning, #memory.warning { color: @yellow; }
      #cpu.critical, #memory.critical { color: @red; }

      #custom-input-method:hover, #custom-system:hover, #network:hover,
      #bluetooth:hover, #pulseaudio:hover { background: @bg_alt; }
    '';
  };

  systemd.user.services.waybar.Install.WantedBy = lib.mkForce [ "niri.service" ];
}

/*
  Previous i3bar/i3status configuration.
  {
    config,
    pkgs,
    ...
  }:
  let
    windowStatus = pkgs.writeShellScript "niri-window-status" ''
      export PATH=${
        pkgs.lib.makeBinPath [
          pkgs.niri
          pkgs.i3status-rust
        ]
      }:"$PATH"
      exec ${pkgs.python3}/bin/python3 ${./niri-window-status.py} "$@"
    '';
  in
  {
    programs.i3bar-river = {
      enable = true;
      package = pkgs.i3bar-river.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./i3bar-left-windows.patch ];
      });
      settings = {
        font = "JetBrainsMono Nerd Font Bold 15";
        height = 22;
        tags_padding = 25;
        separator_width = 1;
        command = "${windowStatus} ${config.xdg.configHome}/i3status-rust/config-default.toml";
        background = "#3C4841FF";
        color = "#d3c6aaff";
        separator = "#83c092ff";
        tag_fg = "#dbbc7fff";
        tag_bg = "#3C4841FF";
        tag_focused_fg = "#3C4841FF";
        tag_focused_bg = "#a7c080ff";
        tag_urgent_fg = "#3C4841FF";
        tag_urgent_bg = "#e67e80ff";
        tag_inactive_fg = "#dbbc7fff";
        tag_inactive_bg = "#3C4841FF";
      };
    };
    programs.i3status-rust.enable = true;
    programs.i3status-rust = {
      bars = {
        default = {
          blocks = [
            {
              block = "disk_space";
              info_type = "available";
              interval = 15;
              path = "/";
              warning = 20.0;
              alert = 10.0;
              format = "$icon$available";
            }
            # {
            #   block = "keyboard_layout";
            # }
            {
              block = "memory";
              format = "^icon_memory_mem $mem_used_percents";
              interval = 1;
            }
            {
              block = "cpu";
              format = "$icon $utilization";
              interval = 1;
            }
            {
              block = "battery";
              # UPower normalizes the signed discharge power reported by macsmc.
              driver = "upower";
              format = "$icon $percentage $time";
              full_format = "$icon";
              interval = 1;
            }
            {
              block = "net";
              # Read Wi-Fi strength even when a proxy/VPN owns the default route.
              # Matches wld0 on Asahi and predictable wl* names on other hosts.
              device = "^wl.*$";
              format = "$icon ";
            }
            {
              block = "sound";
              format = "$icon {$volume.eng(w:2)|}";
            }
            {
              block = "time";
              format = "$timestamp.datetime(f:'%a%m/%d %R') ";
              interval = 60;
            }
          ];
          settings = {
            theme = {
              theme = "gruvbox-light";
              # overrides = {
              #   separator_fg = "#A7C080FF";
              # };
            };
          };
          icons = "material-nf";
        };
      };
    };
  }
*/
