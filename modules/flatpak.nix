{
  config,
  lib,
  pkgs,
  ...
}:
let
  policies = lib.filterAttrs (
    name: _: lib.hasPrefix "chromium/policies/" name
  ) config.environment.etc;
  chromiumPolicies = pkgs.runCommand "chromium-flatpak-policies" { } (
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: policy:
        "install -Dm444 ${policy.source} \"$out\"/${lib.escapeShellArg (lib.removePrefix "chromium/" name)}"
      ) policies
    )
  );
in
{
  services.flatpak.enable = true;

  systemd.tmpfiles.rules = [
    "L+ /var/lib/flatpak/extension/org.chromium.Chromium.Extension.nixos/${pkgs.stdenv.hostPlatform.uname.processor}/1 - - - - ${chromiumPolicies}"
  ];
}
