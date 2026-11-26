{
  constants,
  pkgs,
  ...
}:
let
  envUser = builtins.getEnv "USER";
  envHome = builtins.getEnv "HOME";
  username = if envUser != "" then envUser else constants.username;
  homeDirectory =
    if envHome != "" then
      envHome
    else if pkgs.stdenv.hostPlatform.isDarwin then
      "/Users/${username}"
    else if username == "root" then
      "/root"
    else
      "/home/${username}";
in
{
  imports = [
    ../home/modules/common/git.nix
    ../home/modules/common/ssh.nix
    ../home/modules/common/fish.nix
    ../home/modules/common/starship.nix
    ../home/modules/common/helix.nix
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "26.05";
    enableNixpkgsReleaseCheck = false;
    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      SUDO_EDITOR = "hx";
    };
    packages = with pkgs; [
      pi-coding-agent # 终端 AI 编程助手
      eza # 带文件类型和 Git 状态的目录列表
      ripgrep # 递归搜索文件内容
      fd # 按名称查找文件
      jq
      tree
      sops # 加密和编辑机密配置
      age # 加密和解密文件
      nil # Nix 语言服务器
      nixfmt
    ];
  };

  programs.home-manager.enable = true;
  programs.zoxide.enable = true;
  programs.bash.enable = true;
}
