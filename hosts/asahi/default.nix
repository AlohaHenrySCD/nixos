{
  config,
  constants,
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

  # ── 主机与外设 ──
  my.keyd.keymapIds = [ "05ac:0342:89b7fedc" ];
  services.btrfs.autoScrub.enable = true;
  networking.hostName = lib.mkDefault "asahi";

  environment.systemPackages = with pkgs; [
    asahi-bless # 选择 Apple 芯片 Mac 的启动分区
    picocom # 串口终端
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

  # ── 虚拟机与游戏 ──
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  programs.steam-asahi.enable = true;

  # Allow libvirt guests to use the host's Clash proxy.
  networking.firewall.interfaces.virbr0.allowedTCPPorts = [ constants.proxy.port ];

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

  # ── 系统与启动 ──
  systemd.tmpfiles.rules = [
    "d /.Trash-1000 0700 ${constants.username} users - -"
  ];

  users.users.${constants.username}.extraGroups = [
    "dialout"
    "libvirtd"
    "kvm"
  ];

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "ignore";
    HandleSuspendKey = "suspend";
  };

  hardware.asahi = {
    enable = true;
    peripheralFirmwareDirectory = null;
  };

  boot = {
    kernelParams = [
      "appledrm.show_notch=1"
      "appledrm.hdmi_audio=1"
    ];
  };

  # ── Steam Asahi 兼容层 ──
  # FEX 和 FUSE 3 的可执行文件在 nixpkgs 中使用了不同的名称。
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
}
