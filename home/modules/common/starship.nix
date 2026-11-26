{ theme, ... }:
{
  programs.starship = {
    enable = true;
    settings = (builtins.fromTOML (builtins.readFile ../../starship.toml)) // {
      palettes.everforest = theme.palette;
    };
  };
}
