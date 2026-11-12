{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  alsa-lib,
}:
let
  releases = {
    aarch64-linux = {
      target = "aarch64-unknown-linux-gnu";
      sha256 = "9f390337da0d488b09744b5644461b588f43fac79b13b2ca69628c620700c738";
    };
    x86_64-linux = {
      target = "x86_64-unknown-linux-gnu";
      sha256 = "1cbaa8713cb23a655e544230d11d28e2164131889663f052e4674686f8667b42";
    };
  };
  release = releases.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pigma";
  version = "0.2.15";

  src = fetchurl {
    url = "https://github.com/akirco/pigma/releases/download/v${finalAttrs.version}/pigma-${release.target}.tar.gz";
    inherit (release) sha256;
  };

  sourceRoot = ".";
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    alsa-lib
    stdenv.cc.cc.lib
  ];
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 pigma "$out/bin/pigma"
    runHook postInstall
  '';

  meta = {
    description = "Terminal player for NetEase Cloud Music and local audio";
    homepage = "https://github.com/akirco/pigma";
    mainProgram = "pigma";
    platforms = builtins.attrNames releases;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
