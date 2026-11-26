{ ... }:
let
  mkGithubHost = key: {
    hostname = "github.com";
    user = "git";
    identityFile = "~/.ssh/${key}";
  };
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        ControlMaster = "no";
        ControlPersist = "no";
      };
      blog = mkGithubHost "id_ed25519_blog";
      my-nix = mkGithubHost "id_ed25519";
      nixpkgs = mkGithubHost "id_ed25519_nixpkgs";
    };
  };
}
