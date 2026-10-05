{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.nixos-apple-silicon.nixosModules.default
    ../../configuration.nix
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    # utm
    asahi-bless
    picocom
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="316d", GOTO="m1n1"
    GOTO="not_m1n1"

    LABEL="m1n1"
    GROUP="dialout", MODE="0660"
    SUBSYSTEM=="tty", ATTRS{bInterfaceNumber}=="00", KERNEL=="ttyACM*", SYMLINK+="m1n1"
    SUBSYSTEM=="tty", ATTRS{bInterfaceNumber}=="02", KERNEL=="ttyACM*", SYMLINK+="m1n1-sec"
    LABEL="not_m1n1"
  '';

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Allow libvirt guests to use the host's Clash proxy.
  networking.firewall.interfaces.virbr0.allowedTCPPorts = [ 7897 ];

  # Ensure the default NAT network is available after boot and nixos-rebuild.
  systemd.services.libvirt-default-network = {
    description = "Start the default libvirt network";
    wantedBy = [ "multi-user.target" ];
    requires = [ "libvirtd.service" ];
    after = [ "libvirtd.service" ];
    partOf = [ "libvirtd.service" ];
    path = [
      config.virtualisation.libvirtd.package
      pkgs.gnugrep
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      virsh --connect qemu:///system net-autostart default
      active_networks=$(virsh --connect qemu:///system net-list --name)
      if ! grep -Fxq default <<< "$active_networks"; then
        virsh --connect qemu:///system net-start default
      fi
    '';
  };

  systemd.tmpfiles.rules = [
    "d /.Trash-1000 0700 alohahenry users - -"
  ];

  users.users.alohahenry.extraGroups = [
    "dialout"
    "libvirtd"
  ];

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    # HibernateDelaySec = "1h";
    HandleLidSwitchExternalPower = "ignore";
    HandleSuspendKey = "suspend";
  };

  hardware.asahi = {
    enable = true;
    # useExperimentalGPUDriver = true;
    peripheralFirmwareDirectory = /boot/vendorfw;
    setupAsahiSound = true;
  };

  boot = {
    kernelPatches = [
      {
        name = "asahi-j314s-enable-pmp";
        patch = pkgs.writeText "asahi-j314s-enable-pmp.patch" ''
          --- a/arch/arm64/boot/dts/apple/t6000-j314s.dts
          +++ b/arch/arm64/boot/dts/apple/t6000-j314s.dts
          @@ -12,2 +12,4 @@
          +#define APPLE_USE_PMP
          +
           #include "t6000.dtsi"
           #include "t600x-j314-j316.dtsi"
        '';
      }
    ];
    kernelParams = [
      "appledrm.show_notch=1"
    ];
    loader.efi.canTouchEfiVariables = false;
  };
}
