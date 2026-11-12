{ ... }:
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
      blog = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_blog";
      };

      my-nix = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };

      nixpkgs = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_nixpkgs";
      };
    };
  };
}
