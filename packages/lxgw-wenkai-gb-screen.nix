{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lxgw-wenkai-gb-screen";
  version = "1.530";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v${finalAttrs.version}/LXGWWenKaiGBScreen.ttf";
    hash = "sha256-DfQAmsnc5us7jLTE6Q3me7l0XomSolXAOljdX+Px5QM=";
  };

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    install -Dm644 "$src" "$out/share/fonts/truetype/LXGWWenKaiGBScreen.ttf"
    runHook postInstall
  '';

  meta = {
    description = "LXGW WenKai GB font optimized for screen reading";
    homepage = "https://github.com/lxgw/LxgwWenKai-Screen";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
