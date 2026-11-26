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
      pi-coding-agent
      eza
      ripgrep
      fd
      jq
      tree
      sops
      age
      nil
      nixfmt
    ];
  };

  programs.home-manager.enable = true;
  programs.zoxide.enable = true;
  programs.bash.enable = true;
}
