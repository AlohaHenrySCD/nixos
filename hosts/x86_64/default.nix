{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = lib.mkDefault "x86_64";

  environment.systemPackages = with pkgs; [
  ];

  # services.logind.settings.Login = {
  #   HandleLidSwitch = "suspend";
  #   # HibernateDelaySec = "1h";
  #   HandleLidSwitchExternalPower = "ignore";
  #   HandleSuspendKey = "suspend";
  # };

  boot = {
    loader.efi.canTouchEfiVariables = true;
  };
}
