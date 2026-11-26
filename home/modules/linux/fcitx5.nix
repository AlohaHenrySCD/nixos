{ osConfig, theme, ... }:
{
  home.sessionVariables = {
    # GLFW 通过 IBus 协议连接 Fcitx5。
    GLFW_IM_MODULE = "ibus";
    SDL_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
  };

  home.file.".local/share/fcitx5/rime/default.custom.yaml".source = ../../rime-default.custom.yaml;
  home.file.".local/share/fcitx5/rime/rime_ice.custom.yaml".text = ''
    patch:
      "switches/@1/reset": 1
      "engine/processors/@before 0": lua_processor@*raw_on_symbol
  '';
  home.file.".local/share/fcitx5/rime/lua/raw_on_symbol.lua".source = ../../rime-raw-on-symbol.lua;

  xdg.configFile."fcitx5/config".source = ../../fcitx5.conf;
  # Leave Ctrl+Shift+U available for Kitty scrollback.
  xdg.configFile."fcitx5/conf/unicode.conf".text = ''
    DirectUnicodeMode=
  '';
  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Font=${theme.fonts.fcitx}
    Theme=everforest
    DarkTheme=everforest
    UseDarkTheme=False
    UseAccentColor=False
  '';
  xdg.dataFile."fcitx5/themes/everforest/theme.conf".text = theme.render ../../fcitx5-everforest.conf;
  xdg.configFile."fcitx5/conf/rime.conf".text = ''
    # Commit the typed pinyin when switching away from Rime.
    SwitchInputMethodBehavior=Commit raw input
  '';

  # 系统输入法包包含 NixOS 配置的 Rime 等附加组件。
  systemd.user.services.fcitx5-daemon = {
    Unit = {
      Description = "Fcitx5 input method editor";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service.ExecStart = "${osConfig.i18n.inputMethod.package}/bin/fcitx5";
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
