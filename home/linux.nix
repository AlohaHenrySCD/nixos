{
  pkgs,
  inputs,
  osConfig,
  ...
}:
let
  fontSettings = import ../fonts.nix { inherit pkgs; };
in
{
  imports = [
    ./modules/linux/packages.nix
  ];

  home.homeDirectory = "/home/alohahenry";
  home.sessionPath = [ "/home/alohahenry/.cargo/bin" ];

  fonts.fontconfig = fontSettings.fontconfig;

  programs.fish = {
    shellAliases = {
      bd = "sudo nixos-rebuild switch -L --impure --flake /etc/nixos#asahi";
      bd-debug = "sudo nixos-rebuild switch -L --impure --flake /etc/nixos#asahi-debug";
    };
    shellAbbrs = {
      nix-clean = "nix-collect-garbage && sudo nix-collect-garbage && sudo journalctl --vacuum-size=300M";
    };
    functions = {
      gbd = "git add /etc/nixos/ && git commit --message $argv[1] && git push && sudo nixos-rebuild switch -L --impure --flake /etc/nixos#asahi ";
    };
  };

  # Migrated to configuration.nix.
  /* i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-fluent
      (fcitx5-rime.override {
        rimeDataPkgs = [
          pkgs.rime-ice
        ];
      })
    ];
  }; */


}
