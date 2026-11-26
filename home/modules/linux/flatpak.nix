{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  cursor = config.home.pointerCursor;
  cursorIcons = "${cursor.package}/share/icons";
  apps = {
    bazecor.id = "com.dygma.bazecor";
    halloy.id = "org.squidowl.halloy";
    haruna.id = "org.kde.haruna";
    netease.id = "com.github.gmg137.netease-cloud-music-gtk";
    papers.id = "org.gnome.Papers";
    prismlauncher.id = "org.prismlauncher.PrismLauncher";
    qbittorrent.id = "org.qbittorrent.qBittorrent";
    vlc.id = "org.videolan.VLC";
    vesktop = rec {
      id = "dev.vencord.Vesktop";
      mimeTypes."x-scheme-handler/discord" = "${id}.desktop";
    };
    chromium = rec {
      id = "org.chromium.Chromium";
      wrapper = true;
      flags."chromium-flags.conf" = ''
        --password-store=kwallet6
        --blink-settings=preferredColorScheme=1
        --user-data-dir=${config.xdg.configHome}/chromium
        --remote-debugging-address=127.0.0.1
        --remote-debugging-port=9222
      '';
      stamp = "chromium-profiles-unlinked-stamp";
      mimeTypes = lib.genAttrs [
        "text/html"
        "x-scheme-handler/about"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/mailto"
        "x-scheme-handler/unknown"
      ] (_: "${id}.desktop");
    };
    kazumi = {
      id = "io.github.Predidit.Kazumi";
      wrapper = true;
      filesystems = [ "xdg-data/kazumi" ];
      env = {
        GDK_BACKEND = "wayland";
        MESA_LOADER_DRIVER_OVERRIDE = "zink";
      };
    };
    libreoffice = rec {
      id = "org.libreoffice.LibreOffice";
      wrapper = true;
      filesystems = [ "xdg-config/libreoffice" ];
      # LibreOffice has host access and can read the Home Manager font rules directly.
      env.FONTCONFIG_FILE = "/etc/fonts/fonts.conf";
      mimeTypes = {
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "${id}.writer.desktop";
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" =
          "${id}.impress.desktop";
      };
    };
    obsidian = rec {
      id = "md.obsidian.Obsidian";
      wrapper = true;
      filesystems = [ "xdg-config/obsidian" ];
      flags."obsidian/user-flags.conf" = ''
        --user-data-dir=${config.xdg.configHome}/obsidian
      '';
      mimeTypes."x-scheme-handler/obsidian" = "${id}.desktop";
    };
    wechat = {
      id = "com.tencent.WeChat";
      wrapper = true;
      filesystems = [ "${config.home.homeDirectory}/.xwechat" ];
    };
  };
  flatpakSync = pkgs.writeShellApplication {
    name = "flatpak-sync";
    runtimeInputs = [
      pkgs.flatpak
      pkgs.coreutils
      pkgs.gnugrep
    ];
    text = ''
      flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      installed=$(flatpak list --user --app --columns=application)
      missing=()
      for id in ${lib.escapeShellArgs (lib.mapAttrsToList (_: app: app.id) apps)}; do
        if ! grep -Fxq -- "$id" <<< "$installed"; then
          missing+=("$id")
        fi
      done
      if (( ''${#missing[@]} )); then
        flatpak install --user --noninteractive flathub "''${missing[@]}"
      fi
    '';
  };
  systemFonts = lib.findFirst (
    package: package.name == "X11-fonts"
  ) null osConfig.environment.systemPackages;
  fontPaths = [
    "${systemFonts}/share/X11/fonts"
    "${config.gtk.font.package}/share/fonts"
  ];
  fontRules = lib.filterAttrs (
    name: rule:
    rule.enable && lib.hasPrefix "fontconfig/conf.d/" name && !lib.hasSuffix "10-hm-fonts.conf" name
  ) config.xdg.configFile;
  sandboxFonts = config.xdg.configFile."fontconfig/10-nix-fonts.conf".source;
  ruleFiles = lib.mapAttrsToList (_: rule: rule.source) fontRules;
  override =
    paths: env:
    lib.generators.toINI { } (
      {
        Context.filesystems = lib.concatStringsSep ";" paths + ";";
      }
      // lib.optionalAttrs (env != { }) { Environment = env; }
    );
  appConfig = app: "${config.home.homeDirectory}/.var/app/${app.id}/config";
  installFile =
    app: name: source:
    "run install -Dm644 ${source} ${lib.escapeShellArg "${appConfig app}/${name}"}";
in
{
  systemd.user.services.flatpak-sync = {
    Unit = {
      Description = "Install declared user Flatpak applications";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe flatpakSync;
    };
    Install.WantedBy = [ "default.target" ];
  };

  home.packages = lib.mapAttrsToList (
    name: app:
    pkgs.writeShellScriptBin name ''
      exec ${pkgs.flatpak}/bin/flatpak run --user ${app.id} "$@"
    ''
  ) (lib.filterAttrs (_: app: app.wrapper or false) apps);

  home.activation.flatpakAppSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    lib.concatLines (
      lib.concatMap (
        app:
        lib.mapAttrsToList (name: value: installFile app name (pkgs.writeText (baseNameOf name) value)) (
          app.flags or { }
        )
        ++ lib.optional (app ? stamp) "run touch ${lib.escapeShellArg "${appConfig app}/${app.stamp}"}"
      ) (lib.attrValues apps)
    )
  );

  # Use the store sources directly inside sandboxes with no access to the HM generation.
  xdg.configFile."fontconfig/10-nix-fonts.conf".text = ''
    <fontconfig>
      <include>/etc/fonts/fonts.conf</include>
      <dir>${config.gtk.font.package}/share/fonts</dir>
      ${lib.concatMapStringsSep "\n" (file: "<include>${file}</include>") ruleFiles}
    </fontconfig>
  '';

  home.file.".local/share/flatpak/overrides/global".text =
    override
      (
        [ "xdg-config/fontconfig:ro" ]
        ++ map (path: "${path}:ro") (
          fontPaths ++ ruleFiles
          ++ [
            sandboxFonts
            cursorIcons
            config.gtk.theme.package
          ]
        )
      )
      {
        FONTCONFIG_FILE = toString sandboxFonts;
        GTK_DATA_PREFIX = "${config.gtk.theme.package}";
        XCURSOR_PATH = "${cursorIcons}:/usr/share/icons:/app/share/icons";
        XCURSOR_THEME = cursor.name;
        XCURSOR_SIZE = toString cursor.size;
      };

  # Leave Chromium's app override writable for KDE browser integration.
  xdg.dataFile = lib.mapAttrs' (
    _: app:
    lib.nameValuePair "flatpak/overrides/${app.id}" {
      text = override app.filesystems (app.env or { });
    }
  ) (lib.filterAttrs (_: app: app ? filesystems) apps);

  home.file.".local/share/codex-browser/chromium-mcp.py" = {
    force = true;
    text = ''
      import os

      os.execv('${pkgs.nodejs}/bin/npx', [
          'npx', '-y', 'chrome-devtools-mcp@1.10.1',
          '--browser-url=http://127.0.0.1:9222',
          '--no-usage-statistics', '--no-performance-crux',
      ])
    '';
  };

  xdg.mimeApps.defaultApplications = lib.mergeAttrsList (
    map (app: app.mimeTypes or { }) (lib.attrValues apps)
  );
}
