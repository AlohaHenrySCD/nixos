final: prev:
let
  inherit (final) callPackage;
  inherit (prev) lib stdenv;
in
{
  ecdict-stardict = callPackage ../packages/ecdict-stardict.nix { };
  jetbrains-sans = callPackage ../packages/jetbrains-sans.nix { };
  lxgw-wenkai-gb-screen = callPackage ../packages/lxgw-wenkai-gb-screen.nix { };
}
// lib.optionalAttrs stdenv.hostPlatform.isLinux {
  pomotroid = callPackage ../packages/pomotroid.nix { };
  quit-focused-app = callPackage ../packages/quit-focused-app { };
  squirreldisk = callPackage ../packages/squirreldisk.nix { };
  waybar-niri-windows = callPackage ../packages/waybar-niri-windows.nix { };
}
//
  lib.optionalAttrs
    (builtins.elem stdenv.hostPlatform.system [
      "aarch64-linux"
      "x86_64-linux"
    ])
    {
      deepseek-harness-uncensored = callPackage ../packages/deepseek-harness-uncensored.nix { };
      pigma = callPackage ../packages/pigma.nix { };
    }
