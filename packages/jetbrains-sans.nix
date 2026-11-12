{
  lib,
  stdenvNoCC,
  fetchurl,
  python3,
}:

stdenvNoCC.mkDerivation {
  pname = "jetbrains-sans";
  version = "1.308";

  src = fetchurl {
    url = "https://www.jetbrains.com/_assets/rr/JetBrainsSans_wght_-BrB9S76b.ttf";
    hash = "sha256-PODC5qO8QffqecF9XcM7LPklKriaDg/X97yQrbgjGrI=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ (python3.withPackages (ps: [ ps.fonttools ])) ];
  installPhase = ''
    runHook preInstall
    install -Dm644 "$src" "$out/share/fonts/truetype/JetBrainsSans.ttf"
    python3 - "$out/share/fonts/truetype/JetBrainsSans.ttf" <<'PY'
    import sys
    from fontTools.ttLib import TTFont

    font = TTFont(sys.argv[1])
    for record in font["GSUB"].table.FeatureList.FeatureRecord:
        if record.FeatureTag in {"liga", "clig", "dlig", "hlig", "calt"}:
            record.Feature.LookupListIndex = []
            record.Feature.LookupCount = 0
    font.save(sys.argv[1])
    PY
    runHook postInstall
  '';

  meta = {
    description = "JetBrains Sans proportional typeface without optional ligatures";
    homepage = "https://www.jetbrains.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
