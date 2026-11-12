{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/common/packages.nix
    ./modules/common/broot.nix
    ./modules/common/fish.nix
    ./modules/common/ssh.nix
    ./modules/common/kitty.nix
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

  xdg.configFile."tlrc/config/toml".source = ./tlrc.toml;
  xdg.configFile."yazi/theme.toml".source = ./yazi/theme.toml;

  # Euporie writes settings and recent files back to this file. Keep a writable
  # copy and reset it to the declarative template on each activation.
  programs.zoxide.enable = true;

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user.name = "AlohaHenry";
      user.email = "aloha.henry.2018@gmail.com";
    };
  };

  xdg.configFile."starship.toml".source = ./starship.toml;
  programs.starship.enable = true;

  programs.bash = {
    enable = true;

  };

}
