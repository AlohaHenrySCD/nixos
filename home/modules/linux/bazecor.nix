{
  config,
  lib,
  pkgs,
  ...
}:
let
  projectDir = "${config.home.homeDirectory}/git/Bazecor";
  launcher = pkgs.writeShellScript "bazecor-launch" ''
    cd ${lib.escapeShellArg projectDir}
    exec ${pkgs.nix}/bin/nix-shell ${lib.escapeShellArg "${projectDir}/shell.nix"} \
      --argstr command 'exec ./out/Bazecor-linux-arm64/Bazecor'
  '';
in
{
  xdg.desktopEntries.bazecor = {
    name = "Bazecor";
    comment = "Configure Dygma keyboards";
    exec = "${launcher}";
    icon = "${projectDir}/build/logo.png";
    terminal = false;
    categories = [ "Utility" ];
    settings.StartupWMClass = "Bazecor";
  };
}
