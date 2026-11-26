{
  config,
  lib,
  pkgs,
  ...
}:
let
  dictionariesDir = "${config.xdg.dataHome}/goldendict/dictionaries";
  configFile = "${config.xdg.configHome}/goldendict/config";
in
{
  home.packages = [ pkgs.goldendict-ng ];

  xdg.dataFile."goldendict/dictionaries/ecdict".source = pkgs.ecdict-stardict;

  home.activation.goldendict = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ${pkgs.python3}/bin/python3 ${./goldendict-configure.py} ${
      lib.escapeShellArgs [
        configFile
        dictionariesDir
      ]
    }
  '';
}
