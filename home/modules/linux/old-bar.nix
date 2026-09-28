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
