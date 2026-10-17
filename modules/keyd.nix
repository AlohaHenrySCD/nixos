{
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
      internal =
        let
          # Sonsei 20261011110742: shared media row; LED effects have no keyd equivalent.
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
        in
        {
          ids = [ "05ac:0342:89b7fedc" ];
          settings = {
            main = {
              "1" = "C-S-c";
              "2" = "C-S-v";
              "3" = "C-c";
              "4" = "C-v";
              "5" = "noop";
              "6" = "noop";
              "7" = "7";
              "8" = "8";
              "9" = "9";
              "0" = "0";
              capslock = "backspace";
              backspace = "C-S-f12";
              esc = "esc";
              leftshift = "delete";
              rightshift = "delete";
              leftcontrol = "toggle(num)";
              leftalt = "layer(symbol)";
              leftmeta = "esc";
              rightmeta = "layer(plain)";
              rightalt = "toggle(nav)";
              # Require the hold timeout to avoid overloadt2 misclassifying successive taps.
              a = "overloadt(alt, a, 185)";
              s = "overloadt(meta, s, 185)";
              d = "overloadt(shift, d, 185)";
              f = "overloadt(nav, f, 185)";
              j = "overloadt(num, j, 185)";
              k = "overloadt(shift, k, 185)";
              l = "overloadt(meta, l, 185)";
              semicolon = "overloadt(altgr, semicolon, 185)";
              v = "overloadt(control, v, 185)";
              m = "overloadt(control, m, 185)";
              c = "overloadt(symbol, c, 185)";
              comma = "overloadt(symbol, comma, 185)";
            };

            plain = {
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
              "5" = "5";
              "6" = "6";
              "7" = "7";
              "8" = "8";
              "9" = "9";
              "0" = "0";
              q = "q";
              w = "w";
              e = "e";
              r = "r";
              t = "t";
              y = "y";
              u = "u";
              i = "i";
              o = "o";
              p = "p";
              a = "a";
              s = "s";
              d = "d";
              f = "f";
              g = "g";
              h = "h";
              j = "j";
              k = "k";
              l = "l";
              semicolon = "semicolon";
              z = "z";
              x = "x";
              c = "c";
              v = "v";
              b = "b";
              n = "n";
              m = "m";
              comma = "comma";
              dot = "dot";
              slash = "slash";
            };

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
              leftcontrol = "%";
              rightalt = "@";
            };

            nav = mediaRow // {
              q = "noop";
              w = "C-S-u";
              e = "C-S-d";
              r = "noop";
              t = "noop";
              y = "noop";
              u = "j";
              i = "k";
              o = "l";
              p = ";";
              a = "noop";
              s = "pageup";
              d = "pagedown";
              f = "noop";
              g = "noop";
              h = "noop";
              j = "left";
              k = "down";
              l = "up";
              semicolon = "right";
              z = "noop";
              x = "C-u";
              c = "C-d";
              v = "noop";
              b = "noop";
              n = "noop";
              m = "m";
              comma = "noop";
              dot = "noop";
              slash = "noop";
            };

            num = mediaRow // {
              q = "noop";
              w = "9";
              e = "8";
              r = "7";
              t = "f12";
              y = "noop";
              u = "noop";
              i = "f7";
              o = "f8";
              p = "f9";
              a = "3";
              s = "2";
              d = "1";
              f = "0";
              g = "f10";
              h = "noop";
              j = "noop";
              k = "f1";
              l = "f2";
              semicolon = "f3";
              z = "noop";
              x = "6";
              c = "5";
              v = "4";
              b = "f11";
              n = "noop";
              m = "noop";
              comma = "f4";
              dot = "f5";
              slash = "f6";
            };
          };
        };
    };
  };
}
