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

  environment.systemPackages = with pkgs; [
  ];

  # services.logind.settings.Login = {
  #   HandleLidSwitch = "suspend";
  #   # HibernateDelaySec = "1h";
  #   HandleLidSwitchExternalPower = "ignore";
  #   HandleSuspendKey = "suspend";
  # };

  boot = {
    kernelParams = [
      "appledrm.show_notch=1"
    ];
    loader.efi.canTouchEfiVariables = true;
  };
}
