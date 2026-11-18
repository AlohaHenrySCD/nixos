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
      sha256 = "5a2a70dac1fdad0bcfb9c783fbab544ca13eef3893ed7454cc728295cb78ba44";
    };
    x86_64-linux = {
      target = "x86_64-unknown-linux-gnu";
      sha256 = "d786e51c687744d65009bc0a8337a433720c67a742db8eb4e242d3a7eede093f";
    };
  };
  release = releases.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pigma";
  version = "0.3.0";

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
