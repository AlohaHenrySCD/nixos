config_file=$1
settings=$2
pgrep_bin=$3
mkdir -p "$(dirname "$config_file")"
temporary=$(mktemp "$config_file.XXXXXX")
trap 'rm -f "$temporary"' EXIT

if [ -e "$config_file" ]; then
  cp -p "$config_file" "$temporary"
fi
crudini --merge "$temporary" < "$settings"

if [ -e "$config_file" ] && cmp -s "$config_file" "$temporary"; then
  exit 0
fi
if "$pgrep_bin" -u "$(id -u)" -x qbittorrent >/dev/null; then
  echo "Close qBittorrent before activating its declarative settings." >&2
  exit 1
fi

if [ -e "$config_file" ]; then
  cp -p --backup=numbered "$config_file" "$config_file.before-home-manager"
fi
chmod 600 "$temporary"
mv "$temporary" "$config_file"
