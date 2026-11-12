{ inputs, lib, ... }:
{
  imports = [ inputs.nirinit.nixosModules.nirinit ];

  services.nirinit = {
    enable = true;
    settings.launch.Chatgpt = "chatgpt";
    settings.skip.apps = [ "kitty" ];
  };

  systemd.user.services.nirinit = {
    wantedBy = lib.mkForce [ "niri.service" ];
    after = [ "niri.service" ];
  };
}
