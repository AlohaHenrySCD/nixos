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

  programs.kitty = {
    settings.restore_session_after_logout = true;
    # Compensate for Niri's touchpad scroll-factor 0.2 inside the terminal.
    settings.touch_scroll_multiplier = 5.0;
    keybindings = {
      "esc" =
        "combine : send_text all \\x1b : launch --type=background ${pkgs.fcitx5}/bin/fcitx5-remote -c";
    };
  };

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
