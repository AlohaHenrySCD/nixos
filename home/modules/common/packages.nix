{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.packages =
    let
      llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in
    with pkgs;
    [
      # 终端效率与预览
      glow # 在终端阅读 Markdown
      ffmpeg
      jujutsu # 兼容 Git 的版本控制工具
      tree
      ansifilter # 移除终端输出中的 ANSI 控制码
      eza # 带文件类型和 Git 状态的目录列表
      ripgrep # 递归搜索文件内容
      jq

      # 文本与文档
      resvg # 将 SVG 渲染为 PNG
      poppler # 提取 PDF 文本、图像等内容
      imagemagick

      # 终端查询与文件管理
      ov # 在终端分页查看长文本
      tlrc # 查阅 tldr 命令示例
      navi # 交互式查找并运行命令示例
      hugo # 静态网站生成器
      fd # 按名称查找文件
      trash-cli # 将文件移到回收站

      # AI 工具
      llmAgents.antigravity-cli
      llmAgents.opencode2 # 终端 AI 编程助手
      llmAgents.t3code # 启动 T3 Code 编程工作区

      # 语言与构建工具链
      pkg-config

      (lib.hiPrio jdk25)
      (lib.lowPrio jdk8)

      nodejs
      python3
      uv # 管理 Python 环境和依赖
      black # 格式化 Python 代码
      rustc
      cargo
      rustfmt
      clippy # 检查 Rust 代码中的常见问题
      rust-analyzer
      lld # LLVM 链接器
      llvm
      gnumake
      cmake
      clang-tools

      # 语言服务器 (LSP) 与检查工具
      bash-language-server
      vscode-css-languageserver
      yaml-language-server
      fish-lsp
      superhtml # HTML 语法检查与格式化
      typescript-language-server
      vscode-json-languageserver
      texlab # LaTeX 语言服务器
      tectonic # 编译 LaTeX 文档
      marksman # Markdown 语言服务器
      nil # Nix 语言服务器
      ty # 检查 Python 类型
      taplo # 检查和格式化 TOML
    ];
}
