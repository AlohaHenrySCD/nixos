{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = with pkgs; [
    glow
    ffmpeg
    jujutsu
    tree
    ansifilter
    eza
    ripgrep
    jq
    resvg
    poppler
    imagemagick
    ov
    # animeko
    tlrc
    navi
    hugo
    fd
    trash-cli

    llmAgents.antigravity-cli
    llmAgents.opencode2
    llmAgents.t3code

    pkg-config

    (lib.hiPrio jdk25)
    (lib.lowPrio jdk8)

    nodejs
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
    # haskell-language-server
    superhtml
    typescript-language-server
    vscode-json-languageserver
    texlab
    tectonic
    marksman
    nil
    ty
    taplo
  ];
}
