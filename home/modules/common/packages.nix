{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    yazi
    jujutsu
    usbutils
    codex
    tree
    halloy
    ansifilter
    qbittorrent
    eza
    ripgrep
    jq
    bat
    ov
    # animeko
    fzf
    tlrc
    navi
    hugo
    lazygit
    btop
    fd
    trash-cli

    pkg-config

    (lib.hiPrio jdk25)
    (lib.lowPrio jdk8)

    python3
    # euporie # python pack jypyter tui
    uv
    black
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    # clang
    lld
    llvm
    gnumake
    cmake
    clang-tools
    bash-language-server
    vscode-css-languageserver
    yaml-language-server
    fish-lsp
    haskell-language-server
    superhtml
    typescript-language-server
    vscode-json-languageserver
    texlab
    marksman
    nil
    ty
    taplo
  ];
}
