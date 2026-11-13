{ pkgs, osConfig, ... }:
let
  python = pkgs.python3.withPackages (ps: [
    ps.dbus-python
    ps.pygobject3
  ]);
  kittySession = pkgs.writeShellApplication {
    name = "kitty-session";
    runtimeInputs = [
      pkgs.kitty
      pkgs.fuzzel
      pkgs.libnotify
      osConfig.programs.niri.package
    ];
    text = ''
      export KITTY_SESSION_KITTEN=${./kitty-session-kitten.py}
      exec ${python}/bin/python3 ${./kitty-session.py} "$@"
    '';
  };
in
{
  home.packages = [ kittySession ];

  programs.kitty = {
    settings = {
      restore_session_after_logout = true;
      allow_remote_control = "socket-only";
      listen_on = "unix:\${XDG_RUNTIME_DIR}/kitty-session-{kitty_pid}.sock";
    };
    keybindings."ctrl+shift+f5" = "kitten ${./kitty-session-kitten.py} save";
  };

  systemd.user.services.kitty-session = {
    Unit = {
      Description = "Save native Kitty sessions before shutdown";
      After = [ "niri.service" ];
      PartOf = [ "niri.service" ];
    };
    Service = {
      ExecStart = "${kittySession}/bin/kitty-session watch-shutdown";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "niri.service" ];
  };
}
