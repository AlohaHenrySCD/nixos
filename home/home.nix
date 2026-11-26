{
  config,
  constants,
  lib,
  pkgs,
  theme,
  ...
}:
{
  imports = [
    ./modules/common/broot.nix
    ./modules/common/btop.nix
    ./modules/common/clash-hkmo.nix
    ./modules/common/claude.nix
    ./modules/common/codex.nix
    ./modules/common/fish.nix
    ./modules/common/git.nix
    ./modules/common/helix.nix
    ./modules/common/kitty.nix
    ./modules/common/lazygit.nix
    ./modules/common/packages.nix
    ./modules/common/qbittorrent.nix
    ./modules/common/sops.nix
    ./modules/common/ssh.nix
    ./modules/common/starship.nix
    ./modules/common/yazi.nix
    ./modules/common/zed.nix
  ];

  home.stateVersion = "26.05";
  home.enableNixpkgsReleaseCheck = false;
  home.username = constants.username;
  home.sessionVariables = {
    EDITOR = "ms";
    VISUAL = "ms";
    SUDO_EDITOR = "ms";
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
    RUSTUP_DIST_SERVER = "https://rsproxy.cn";
    RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
  };

  home.file.".gemini/config/AGENTS.md".source = ./antigravity-agents.md;
  xdg.configFile."tlrc/config.toml".source = ./tlrc.toml;

  # Euporie writes settings and recent files back to this file. Keep a writable
  # copy and reset it to the declarative template on each activation.
  home.activation.euporieConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ${pkgs.coreutils}/bin/mkdir -p ${lib.escapeShellArg "${config.xdg.configHome}/euporie"}
    run ${pkgs.coreutils}/bin/install -m 600 ${./euporie.json} ${lib.escapeShellArg "${config.xdg.configHome}/euporie/config.json"}
  '';

  programs.zoxide.enable = true;

  programs.bash.enable = true;
}
