{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-apple-silicon.nixosModules.default
    inputs.steam-asahi.nixosModules.default
    ../../configuration.nix
    ./hardware-configuration.nix
    ./kernel.nix
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
  programs.steam-asahi.enable = true;

  home-manager.users.alohahenry.xdg.configFile."fex-emu/Config.json".text =
    builtins.toJSON {
      Config.RootFS = "/home/alohahenry/.local/share/fex-emu/RootFS/Fedora_44.ero";
    };

  nixpkgs.overlays = lib.mkAfter [
    (final: prev: {
      fex = final.symlinkJoin {
        name = "fex-compat-${prev.fex.version}";
        paths = [ prev.fex ];
        postBuild = ''
          ln -s FEX "$out/bin/FEXInterpreter"
        '';
        inherit (prev.fex) meta;
      };
      steam-asahi = prev.steam-asahi.override {
        fuse = final.symlinkJoin {
          name = "fuse-steam-compat";
          paths = [ (lib.getBin final.fuse3) ];
          postBuild = ''
            ln -s fusermount3 "$out/bin/fusermount"
          '';
        };
      };
    })
  ];

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
    "kvm"
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
    peripheralFirmwareDirectory = null;
  };

  # services.pipewire.wireplumber.extraConfig."51-asahi-hdmi" = {
  #   "monitor.alsa.rules" = [
  #     {
  #       matches = [
  #         { "node.name" = "~alsa_output.platform-39b540000.audio-controller.*"; }
  #       ];
  #       actions.update-props = {
  #         "api.alsa.period-size" = 1024;
  #         "api.alsa.period-num" = 8;
  #       };
  #     }
  #   ];
  # };

  boot = {
    kernelParams = [
      "appledrm.show_notch=1"
      "appledrm.hdmi_audio=1"
    ];
  };
}
