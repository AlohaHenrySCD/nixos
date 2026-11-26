{
  config,
  constants,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  configFile =
    if isDarwin then
      "${config.xdg.configHome}/qBittorrent/qBittorrent.ini"
    else
      "${config.home.homeDirectory}/.var/app/org.qbittorrent.qBittorrent/config/qBittorrent/qBittorrent.conf";
  pgrep = if isDarwin then "/usr/bin/pgrep" else "${pkgs.procps}/bin/pgrep";
  trackers = lib.filter (line: line != "") (
    lib.splitString "\n" (builtins.readFile ./qbittorrent-trackers.txt)
  );
  settings = (pkgs.formats.ini { }).generate "qbittorrent-settings.ini" {
    BitTorrent = {
      "Session\\AddTrackersEnabled" = true;
      "Session\\AdditionalTrackers" = lib.concatStringsSep "\\n" trackers;
      "Session\\BTProtocol" = "TCP";
      "Session\\Encryption" = 0;
      "Session\\Interface" = "";
      "Session\\InterfaceAddress" = "";
      "Session\\InterfaceName" = "";
      "Session\\ProxyPeerConnections" = true;
    };
    Network = {
      "Proxy\\AuthEnabled" = false;
      "Proxy\\HostnameLookupEnabled" = true;
      "Proxy\\IP" = constants.proxy.host;
      "Proxy\\Port" = constants.proxy.port;
      "Proxy\\Profiles\\BitTorrent" = true;
      "Proxy\\Type" = "SOCKS5";
    };
  };

  configure = pkgs.writeShellApplication {
    name = "configure-qbittorrent";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.crudini
    ];
    text = ''
      config_file=${lib.escapeShellArg configFile}
      mkdir -p "$(dirname "$config_file")"
      temporary=$(mktemp "$config_file.XXXXXX")
      trap 'rm -f "$temporary"' EXIT

      if [ -e "$config_file" ]; then
        cp -p "$config_file" "$temporary"
      fi
      crudini --merge "$temporary" < ${settings}

      if [ -e "$config_file" ] && cmp -s "$config_file" "$temporary"; then
        exit 0
      fi
      if ${pgrep} -u "$(id -u)" -x qbittorrent >/dev/null; then
        echo "Close qBittorrent before activating its declarative settings." >&2
        exit 1
      fi

      if [ -e "$config_file" ]; then
        cp -p --backup=numbered "$config_file" "$config_file.before-home-manager"
      fi
      chmod 600 "$temporary"
      mv "$temporary" "$config_file"
    '';
  };
in
{
  home.activation.qbittorrentConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${lib.getExe configure}
  '';
}
