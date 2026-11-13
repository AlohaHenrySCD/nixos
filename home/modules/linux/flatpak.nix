{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  flatpakDataDirs = "${config.xdg.dataHome}/flatpak/exports/share:/var/lib/flatpak/exports/share";
  apps = {
    chromium = "org.chromium.Chromium";
    kazumi = "io.github.Predidit.Kazumi";
    libreoffice = "org.libreoffice.LibreOffice";
    obsidian = "md.obsidian.Obsidian";
    wechat = "com.tencent.WeChat";
  };
  chromiumFlags = pkgs.writeText "chromium-flatpak-flags.conf" ''
    --password-store=kwallet6
    --blink-settings=preferredColorScheme=1
    --user-data-dir=${config.xdg.configHome}/chromium
    --remote-debugging-address=127.0.0.1
    --remote-debugging-port=9222
  '';
  systemFonts = lib.findFirst (
    package: package.name == "X11-fonts"
  ) null osConfig.environment.systemPackages;
  fontAccess = lib.concatMapStringsSep ";" (path: "${path}:ro") [
    "${systemFonts}/share/X11/fonts"
    "${config.gtk.font.package}/share/fonts"
  ];
  fontRules = lib.filterAttrs (
    name: _: lib.hasPrefix "fontconfig/conf.d/" name && !lib.hasSuffix "10-hm-fonts.conf" name
  ) config.xdg.configFile;
  fontDirectories = pkgs.writeText "flatpak-nix-fonts.conf" ''
    <?xml version="1.0"?>
    <fontconfig>
      <dir>${config.gtk.font.package}/share/fonts</dir>
    </fontconfig>
  '';
  obsidianFlags = pkgs.writeText "obsidian-flatpak-flags.conf" ''
    --user-data-dir=${config.xdg.configHome}/obsidian
  '';
in
{
  home.packages = [
    (pkgs.symlinkJoin {
      name = "fuzzel-flatpak";
      paths = [ pkgs.fuzzel ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/fuzzel" \
          --prefix XDG_DATA_DIRS : ${lib.escapeShellArg flatpakDataDirs}
      '';
    })
  ] ++ lib.mapAttrsToList (
    name: app:
    pkgs.writeShellScriptBin name ''
      exec ${pkgs.flatpak}/bin/flatpak run --user ${app} "$@"
    ''
  ) apps;

  home.activation.flatpakChromiumFlags = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run install -Dm644 ${chromiumFlags} \
      ${lib.escapeShellArg "${config.home.homeDirectory}/.var/app/org.chromium.Chromium/config/chromium-flags.conf"}
    run touch ${lib.escapeShellArg "${config.home.homeDirectory}/.var/app/org.chromium.Chromium/config/chromium-profiles-unlinked-stamp"}
  '';
  home.activation.flatpakFontRules = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    lib.concatMapStringsSep "\n" (
      app:
      ''
        run install -Dm644 ${fontDirectories} \
          ${lib.escapeShellArg "${config.home.homeDirectory}/.var/app/${app}/config/fontconfig/conf.d/10-nix-fonts.conf"}
      '' + lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          name: rule:
          "run install -Dm644 ${rule.source} ${lib.escapeShellArg "${config.home.homeDirectory}/.var/app/${app}/config/${name}"}"
        ) fontRules
      )
    ) (lib.attrValues apps)
  );

  home.activation.flatpakObsidianFlags = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run install -Dm644 ${obsidianFlags} \
      ${lib.escapeShellArg "${config.home.homeDirectory}/.var/app/md.obsidian.Obsidian/config/obsidian/user-flags.conf"}
  '';

  home.file.".local/share/flatpak/overrides/md.obsidian.Obsidian".text = ''
    [Context]
    filesystems=xdg-config/obsidian;${fontAccess};
  '';
  home.file.".local/share/flatpak/overrides/io.github.Predidit.Kazumi".text = ''
    [Context]
    filesystems=xdg-data/kazumi;${fontAccess};

    [Environment]
    GDK_BACKEND=wayland
    MESA_LOADER_DRIVER_OVERRIDE=zink
  '';
  home.file.".local/share/flatpak/overrides/com.tencent.WeChat".text = ''
    [Context]
    filesystems=${config.home.homeDirectory}/.xwechat;${fontAccess};
  '';
  home.file.".local/share/flatpak/overrides/org.libreoffice.LibreOffice".text = ''
    [Context]
    filesystems=xdg-config/libreoffice;${fontAccess};
  '';
  home.file.".local/share/flatpak/overrides/org.chromium.Chromium".text = ''
    [Context]
    filesystems=${fontAccess};
  '';

  home.file.".local/share/codex-browser/chromium-mcp.py" = {
    force = true;
    text = ''
      import os

      os.execv('${pkgs.nodejs_24}/bin/npx', [
          'npx', '-y', 'chrome-devtools-mcp@1.10.1',
          '--browser-url=http://127.0.0.1:9222',
          '--no-usage-statistics', '--no-performance-crux',
      ])
    '';
  };

  programs.plasma.configFile."mimeapps.list"."Default Applications" = {
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
      "org.libreoffice.LibreOffice.writer.desktop";
    "x-scheme-handler/obsidian" = "md.obsidian.Obsidian.desktop";
    "text/html" = "org.chromium.Chromium.desktop";
    "x-scheme-handler/about" = "org.chromium.Chromium.desktop";
    "x-scheme-handler/http" = "org.chromium.Chromium.desktop";
    "x-scheme-handler/https" = "org.chromium.Chromium.desktop";
    "x-scheme-handler/mailto" = "org.chromium.Chromium.desktop";
    "x-scheme-handler/unknown" = "org.chromium.Chromium.desktop";
  };
}
