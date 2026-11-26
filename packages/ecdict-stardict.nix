{
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation {
  pname = "ecdict-stardict";
  version = "1.0.28";
  src = fetchurl {
    url = "https://github.com/skywind3000/ECDICT/releases/download/1.0.28/ecdict-stardict-28.zip";
    hash = "sha256-xwfQ897W7Hm5ZGbaShV04HRwPaWvnBIPutl/nLCMbyw=";
  };
  nativeBuildInputs = [ unzip ];
  dontUnpack = true;
  installPhase = ''
    mkdir -p "$out"
    unzip -q "$src" -d "$out"
  '';
}
