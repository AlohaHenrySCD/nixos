{
  lib,
  rustPlatform,
  makeWrapper,
  niri,
  systemd,
}:
rustPlatform.buildRustPackage {
  pname = "quit-focused-app";
  version = "0.1.0";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./Cargo.toml
      ./Cargo.lock
      ./src
    ];
  };
  cargoLock.lockFile = ./Cargo.lock;
  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram "$out/bin/quit-focused-app" \
      --prefix PATH : ${lib.makeBinPath [ niri systemd ]}
  '';
  meta = {
    description = "Quit the focused Niri application completely";
    mainProgram = "quit-focused-app";
    platforms = lib.platforms.linux;
  };
}
