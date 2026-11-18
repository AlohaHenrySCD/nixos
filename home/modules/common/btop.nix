{ ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "everforest-dark-medium";
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default";
      save_config_on_exit = false;
    };
  };

  xdg.configFile."btop/btop.conf".force = true;
}
