{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,
  alsa-lib,
  glib-networking,
  libayatana-appindicator,
  openssl,
  webkitgtk_4_1,
}:
let
  inlangModules = [
    {
      url = "https://cdn.jsdelivr.net/npm/@inlang/plugin-message-format@4/dist/index.js";
      file = fetchurl {
        name = "plugin-message-format-index.js";
        url = "https://cdn.jsdelivr.net/npm/@inlang/plugin-message-format@4.5.4/dist/index.js";
        hash = "sha256-haXOnXFFMPbPLlSR+mEYtXWTluJ/LLZz4zT6St7KerM=";
      };
    }
    {
      url = "https://cdn.jsdelivr.net/npm/@inlang/plugin-m-function-matcher@2/dist/index.js";
      file = fetchurl {
        name = "plugin-m-function-matcher-index.js";
        url = "https://cdn.jsdelivr.net/npm/@inlang/plugin-m-function-matcher@2.3.0/dist/index.js";
        hash = "sha256-p+bEEwevxks/NBFvIg6SXwrTrKRyMehJ8IAFGi+0Wag=";
      };
    }
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pomotroid";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "Splode";
    repo = "pomotroid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ENpB364AJ8abDiocNyVpVS2kbRk41Bd0fAGfvY+Zsq0=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";
  cargoHash = "sha256-8hwg/kysxm7bNE0CrUh5bqVAHNAU5poqcHsouyDV1wU=";

  npmDeps = fetchNpmDeps {
    name = "pomotroid-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-hF+8G/RM+0PwWn/rvJCR0DfuCcsYoGBYAg3R955Iq0I=";
  };

  postPatch = ''
    substituteInPlace project.inlang/settings.json ${
      lib.concatMapStringsSep " " (m: "--replace-fail ${m.url} ${m.file}") inlangModules
    }
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    glib-networking
    libayatana-appindicator
    openssl
    webkitgtk_4_1
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libayatana-appindicator ]})
  '';

  meta = {
    description = "Simple and visually pleasing Pomodoro timer";
    homepage = "https://github.com/Splode/pomotroid";
    license = lib.licenses.mit;
    mainProgram = "pomotroid";
    platforms = lib.platforms.linux;
  };
})
