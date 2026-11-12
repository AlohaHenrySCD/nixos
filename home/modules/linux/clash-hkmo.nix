{
  config,
  lib,
  pkgs,
  ...
}:
let
  profileDirectory = "${config.xdg.dataHome}/io.github.clash-verge-rev.clash-verge-rev/profiles";
  target = "${profileDirectory}/mqb9QlfTenXO.yaml";
in
{
  home.activation.clashHkmoRules = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    if [ -f ${lib.escapeShellArg target} ]; then
      if [ ! -e ${lib.escapeShellArg "${target}.before-hkmo"} ]; then
        run ${pkgs.coreutils}/bin/cp -p ${lib.escapeShellArg target} ${lib.escapeShellArg "${target}.before-hkmo"}
      fi
      run ${pkgs.coreutils}/bin/install -m 644 ${../../clash-hkmo.yaml} ${lib.escapeShellArg target}
    fi
  '';
}
