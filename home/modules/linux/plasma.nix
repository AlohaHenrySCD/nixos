{
  config,
  inputs,
  theme,
  ...
}:
{
  xdg.dataFile."color-schemes/Everforest.colors".source =
    inputs.kde-everforest + "/Everforest.colors";
  programs.plasma = {
    enable = true;

    fonts = theme.fonts.plasma;

    configFile."plasma-localerc" = {
      Formats.LANG = "en_US.UTF-8";
      Translations.LANGUAGE = "en_US:en";
    };

    workspace.colorScheme = "Everforest";
    configFile."kdeglobals"."Icons"."Theme" = "Papirus";
    configFile."kcminputrc"."Mouse" = {
      cursorTheme = config.home.pointerCursor.name;
      cursorSize = config.home.pointerCursor.size;
    };
    configFile."kded5rc"."Module-gtkconfig".autoload = false;

    panels = [
      {
        location = "top";
        height = 32;
        floating = false;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
        ];
      }
    ];
  };
}
