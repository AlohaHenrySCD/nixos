{
  config,
  lib,
  ...
}:
let
  localKernelPath = /home/alohahenry/git/linux;
  localKernelSource = lib.fileset.toSource {
    root = localKernelPath;
    fileset = lib.fileset.gitTracked localKernelPath;
  };
  kernelPkgs = config.hardware.asahi.pkgs;
in
{
  imports = [ ../asahi ];

  boot.kernelPackages = lib.mkForce (
    kernelPkgs.linux-asahi.override {
      _kernelPatches = config.boot.kernelPatches;
      linuxPackagesFor =
        kernel:
        kernelPkgs.linuxPackagesFor (
          kernel.override {
            buildLinux = args: kernelPkgs.buildLinux (args // { src = localKernelSource; });
          }
        );
    }
  );
}
