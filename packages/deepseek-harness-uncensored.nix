{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  libdrm,
  libgbm,
  libnotify,
  libsecret,
  libuuid,
  libxcrypt-legacy,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxscrnsaver,
  libxtst,
  libxcb,
  mesa,
  nspr,
  nss,
  openssl,
  pango,
  systemd,
  vulkan-loader,
  wayland,
  xdg-utils,
  zlib,
}:
let
  version = "2026.11.24.3";
  releases = {
    aarch64-linux = {
      arch = "arm64";
      hash = "sha512-Ao+DwSJYtql5n424tZ4+8MIqvgLNRingk1AJqqR3VNfZ/hP8nFbnvhBbbwve/yQUyFDq81652beFaad9BLb+9g==";
    };
    x86_64-linux = {
      arch = "amd64";
      hash = "sha512-l7gQ3UoB5Mng1FUDm29LO7sOYi7Defo1mn2DBtqptrLlK2u6AkZ3wiI/oW2dwe4d5OBvjLMNneX+7rUbRAiAdw==";
    };
  };
  release = releases.${stdenv.hostPlatform.system};
  runtimeLibs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libGL
    libdrm
    libgbm
    libnotify
    libsecret
    libuuid
    libxcrypt-legacy
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    libxscrnsaver
    libxtst
    mesa
    nspr
    nss
    openssl
    pango
    stdenv.cc.cc.lib
    systemd
    vulkan-loader
    wayland
    zlib
  ];
in
stdenv.mkDerivation {
  pname = "deepseek-harness-uncensored";
  inherit version;

  src = fetchurl {
    url = "https://github.com/Water-Run/deepseek-harness-uncensored/releases/download/v${version}/deepseek-harness-uncensored-${version}-linux-${release.arch}-unsigned.deb";
    inherit (release) hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = runtimeLibs;

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-aarch64.so.1"
    "libc.musl-x86_64.so.1"
  ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontWrapGApps = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x "$src" .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/deepseek-harness-uncensored" "$out/bin" "$out/share"
    cp -a "opt/DeepSeek Harness Uncensored/." "$out/lib/deepseek-harness-uncensored/"
    cp -a usr/share/. "$out/share/"

    if [ -f "$out/share/applications/deepseek-harness-uncensored.desktop" ]; then
      substituteInPlace "$out/share/applications/deepseek-harness-uncensored.desktop" \
        --replace-fail '"/opt/DeepSeek Harness Uncensored/deepseek-harness-uncensored"' "$out/bin/deepseek-harness-uncensored"
    fi

    runHook postInstall
  '';

  preFixup = ''
    addAutoPatchelfSearchPath "$out/lib/deepseek-harness-uncensored"
  '';

  postFixup = ''
    makeWrapper "$out/lib/deepseek-harness-uncensored/deepseek-harness-uncensored" "$out/bin/deepseek-harness-uncensored" \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          libgbm
          libnotify
          libsecret
          systemd
          vulkan-loader
        ]
      }" \
      --add-flags "--ozone-platform=x11"
  '';

  meta = {
    description = "DeepSeek Harness Uncensored desktop application";
    homepage = "https://github.com/Water-Run/deepseek-harness-uncensored";
    license = lib.licenses.gpl3Plus;
    mainProgram = "deepseek-harness-uncensored";
    platforms = builtins.attrNames releases;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
