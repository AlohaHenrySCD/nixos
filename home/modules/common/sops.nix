{ config, ... }:
{
  sops = {
    # 注意:请在迁移系统时手动迁移keys.txt
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets/secrets.yaml;
    secrets.deepseek_api_key = { };
  };
}
