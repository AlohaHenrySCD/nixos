{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/common/packages.nix
    ./modules/common/fish.nix
    ./modules/common/ssh.nix
    ./modules/common/helix.nix
  ];

  home.stateVersion = "26.05";
  home.enableNixpkgsReleaseCheck = false;
  home.username = "alohahenry";
  home.sessionVariables = {
    EDITOR = "ms";
    VISUAL = "ms";
    SUDO_EDITOR = "ms";
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
    RUSTUP_DIST_SERVER = "https://rsproxy.cn";
    RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
  };


}
