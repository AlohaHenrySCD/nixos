{
  inputs,
  lib,
  ...
}:
let
  kernelPkgs = import inputs.nixpkgs-kernel {
    system = "aarch64-linux";
    overlays = [ inputs.nixos-apple-silicon.overlays.default ];
  };
in
{
  # Use the pinned package set for Asahi's kernel and its build dependencies.
  # mkForce overrides the upstream module's assignment to the system package set.
  hardware.asahi.pkgs = lib.mkForce kernelPkgs;

  # Keep module aggregation compatible with the pinned kernel's outputs.
  nixpkgs.overlays = [
    (_final: _prev: {
      aggregateModules = kernelPkgs.aggregateModules;
    })
  ];

  boot.kernelPatches = [
    {
      name = "asahi-j314s-enable-pmp";
      patch = kernelPkgs.writeText "asahi-j314s-enable-pmp.patch" ''
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
}
