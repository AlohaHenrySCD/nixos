{
  lib,
  stdenv,
  fetchurl,
  go,
  pkg-config,
  gtk3,
}:
let
  gtkBindings = fetchurl {
    name = "gotk3-ff349ae13f56.tar.gz";
    url = "https://codeload.github.com/gotk3/gotk3/tar.gz/ff349ae13f56";
    hash = "sha256-43CFmFJIxpqLQp436y6+4xorD2u9gxDcFUBQmF/MawQ=";
  };
in
stdenv.mkDerivation {
  pname = "waybar-niri-windows";
  version = "2.3.1";

  src = fetchurl {
    name = "waybar-niri-windows-2.3.1.tar.gz";
    url = "https://codeload.github.com/calico32/waybar-niri-windows/tar.gz/refs/tags/v2.3.1";
    hash = "sha256-C/GA8iuKfHbgvHJw5r9fS/Ru4QHvKnYGuOzk7AfYzN8=";
  };

  nativeBuildInputs = [
    go
    pkg-config
  ];
  buildInputs = [ gtk3 ];
  strictDeps = true;

  env = {
    CGO_ENABLED = "1";
    GOTOOLCHAIN = "local";
    GOPROXY = "off";
    GOSUMDB = "off";
  };

  postPatch = ''
    substituteInPlace module/module.go \
      --replace-fail \
      'i.calculateWindowSizes(column, scale, maxHeight-i.config.ColumnBorders)' \
      'i.calculateWindowSizes(column, scale*1.5, maxHeight-i.config.ColumnBorders)'
  '';

  buildPhase = ''
    runHook preBuild
    export GOCACHE="$TMPDIR/go-cache"
    export GOPATH="$TMPDIR/go"
    mkdir -p .deps/gotk3
    tar -xf ${gtkBindings} --strip-components=1 -C .deps/gotk3
    go mod edit -replace github.com/gotk3/gotk3=./.deps/gotk3
    go build -trimpath -ldflags="-s -w -buildid=" \
      -buildmode=c-shared -o waybar-niri-windows.so ./main
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 waybar-niri-windows.so "$out/lib/waybar-niri-windows.so"
    runHook postInstall
  '';

  meta = {
    description = "Niri window minimap for Waybar";
    homepage = "https://github.com/calico32/waybar-niri-windows";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
