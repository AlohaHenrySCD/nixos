{ config, lib, ... }:
{
  options.my.keyd.keymapIds = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Keyboard device IDs that use the layered home-row keymap.";
  };

  # ── 键盘与鼠标 ──
  config.services.keyd = {
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
            mouseback = "layer(control)";
            mouseforward = "layer(meta)";
          };
        };
      };
      # ── 内置键盘分层映射 ──
      internal =
        let
          ids = config.my.keyd.keymapIds;
          mediaRow = {
            "1" = "brightnessdown";
            "2" = "brightnessup";
            "3" = "previoussong";
            "4" = "playpause";
            "5" = "nextsong";
            "6" = "sleep";
            "7" = "noop";
            "8" = "mute";
            "9" = "volumedown";
            "0" = "volumeup";
          };
          layerKeys = lib.stringToCharacters "qwertyuiopasdfghjklzxcvbnm" ++ [
            "semicolon"
            "comma"
            "dot"
            "slash"
          ];
          mkNoopLayer = bindings: mediaRow // lib.genAttrs layerKeys (_: "noop") // bindings;
        in
        lib.mkIf (ids != [ ]) {
          inherit ids;
          settings = {
            main = {
              "1" = "C-S-c";
              "2" = "C-S-v";
              "3" = "C-c";
              "4" = "C-v";
              "5" = "C-x";
              "6" = "brightnessdown";
              "7" = "brightnessup";
              "8" = "mute";
              "9" = "volumedown";
              "0" = "volumeup";

              capslock = "backspace";
              backspace = "C-S-f12";
              esc = "esc";
              leftshift = "delete";
              leftcontrol = "layer(num)";
              leftalt = "capslock";
              leftmeta = "esc";
              rightmeta = "layer(plain)";
              rightalt = "layer(nav)";

              a = "overloadt(alt, a, 130)";
              s = "overloadt(meta, s, 130)";
              d = "overloadt(shift, d, 130)";
              f = "overloadt(nav, f, 130)";
              j = "overloadt(num, j, 130)";
              k = "overloadt(shift, k, 130)";
              l = "overloadt(meta, l, 130)";
              semicolon = "overloadt(altgr, semicolon, 130)";

              c = "overloadt(symbol, c, 130)";
              v = "overloadt(control, v, 130)";
              m = "overloadt(control, m, 130)";
              comma = "overloadt(symbol, comma, 130)";
            };

            plain = lib.genAttrs (lib.stringToCharacters "1234567890" ++ layerKeys) lib.id;

            symbol = mediaRow // {
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

            nav = mkNoopLayer {
              w = "C-S-u";
              e = "C-S-d";
              u = "h";
              i = "j";
              o = "k";
              p = "l";

              s = "pageup";
              d = "pagedown";
              j = "left";
              k = "down";
              l = "up";
              semicolon = "right";

              x = "C-u";
              c = "C-d";
              m = "home";
              slash = "end";
            };

            num = mkNoopLayer {
              w = "9";
              e = "8";
              r = "7";
              t = "f12";
              i = "f7";
              o = "f8";
              p = "f9";

              a = "3";
              s = "2";
              d = "1";
              f = "0";
              g = "f10";
              k = "f1";
              l = "f2";
              semicolon = "f3";

              x = "6";
              c = "5";
              v = "4";
              b = "f11";
              comma = "f4";
              dot = "f5";
              slash = "f6";
            };
          };
        };
    };
  };
}
