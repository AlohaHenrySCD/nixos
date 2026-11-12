{
  pkgs,
  ...
}:
let
  fontSettings = import ../../../fonts.nix { inherit pkgs; };
in
{
  gtk = {
    enable = true;
    font = fontSettings.gtk;
    theme = {
      package = pkgs.everforest-gtk-theme;
      name = "Everforest-Dark";
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    # cursorTheme = {
    #   name = "Bibata-Modern-Ice";
    #   package = pkgs.bibata-cursors;
    # };
    gtk3.extraConfig = {
      gtk-im-module = "fcitx";
      gtk-application-prefer-dark-theme = true;
      # gtk-cursor-theme-name = "Bibata-Modern-Ice";
      gtk-button-images = true;
      gtk-cursor-blink = true;
      gtk-cursor-blink-time = 500;
      gtk-decoration-layout = "icon:minimize,maximize,close";
      gtk-enable-animations = true;
      gtk-menu-images = true;
      gtk-primary-button-warps-slider = true;
      gtk-sound-theme-name = "ocean";
      gtk-toolbar-style = 3;
      gtk-xft-dpi = fontSettings.gtkDpi;
    };

    gtk4.extraConfig = {
      gtk-im-module = "fcitx";
      gtk-cursor-blink = true;
      gtk-cursor-blink-time = 500;
      gtk-decoration-layout = "icon:minimize,maximize,close";
      # gtk-cursor-theme-name = "Bibata-Modern-Ice";
      gtk-enable-animations = true;
      gtk-primary-button-warps-slider = true;
      gtk-sound-theme-name = "ocean";
      gtk-xft-dpi = fontSettings.gtkDpi;
    };
  };
}
