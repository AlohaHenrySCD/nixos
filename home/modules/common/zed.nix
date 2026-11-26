{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    # macOS installs Zed via Homebrew cask (darwin-configuration.nix).
    package = if pkgs.stdenv.hostPlatform.isLinux then pkgs.zed-editor else null;
    extensions = [
      "fish"
      "html"
      "latex"
      "nix"
      "toml"
    ];
  };
}
