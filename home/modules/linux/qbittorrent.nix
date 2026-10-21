{
  config,
  lib,
  pkgs,
  ...
}:
let
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
      "Proxy\\IP" = "127.0.0.1";
      "Proxy\\Port" = 7897;
      "Proxy\\Profiles\\BitTorrent" = true;
      "Proxy\\Type" = "SOCKS5";
    };
  };

  configure = pkgs.writeShellApplication {
    name = "configure-qbittorrent";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.crudini
      pkgs.procps
    ];
    text = ''
      config_file=${lib.escapeShellArg "${config.xdg.configHome}/qBittorrent/qBittorrent.conf"}
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
      if pgrep -u "$(id -u)" -x 'qbittorrent|\.qbittorrent-wr' >/dev/null; then
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
