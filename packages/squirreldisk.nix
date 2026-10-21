{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  fontconfig,
  xdg-utils,
  alsa-lib,
  libGL,
  libxkbcommon,
  wayland,
  libX11,
  libXcursor,
  libXi,
  libXrandr,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "squirreldisk";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "adileo";
    repo = "squirreldisk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SyPxZPZso6gnu0xesD70FtFtDP9hrJk8DdtDzLzg6ys=";
  };

  cargoHash = "sha256-A4xRYpxjl2dF3PGag21hAKOZtJQjI9cLsCLnhSvTGUE=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [ alsa-lib ];

  postPatch = ''
    substituteInPlace src/settings.rs \
      --replace-fail 'auto_update: true,' 'auto_update: false,' \
      --replace-fail 'auto_install: true,' 'auto_install: false,' \
      --replace-fail 'cli_offered: false,' 'cli_offered: true,'
    # Fontconfig encodes a variable-font instance above the 16-bit face index.
    substituteInPlace src/i18n.rs \
      --replace-fail 'map(|b| (b, index))' 'map(|b| (b, index & 0xffff))'
  '';

  postInstall = ''
    install -Dm644 packaging/linux/squirreldisk.desktop \
      "$out/share/applications/squirreldisk.desktop"
    for size in 16 32 48 64 128 256 512 1024; do
      install -Dm644 "assets/icon/icon-$size.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/squirreldisk.png"
    done
    wrapProgram "$out/bin/squirreldisk" \
      --prefix PATH : ${
        lib.makeBinPath [
          fontconfig
          xdg-utils
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          libxkbcommon
          wayland
          libX11
          libXcursor
          libXi
          libXrandr
        ]
      }
  '';

  meta = {
    description = "Disk usage analyzer with an animated sunburst and treemap";
    homepage = "https://github.com/adileo/squirreldisk";
    license = lib.licenses.agpl3Only;
    mainProgram = "squirreldisk";
    platforms = lib.platforms.linux;
  };
})
