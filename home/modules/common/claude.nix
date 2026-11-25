{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.claude-code = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
    mutableSettings = true;
    settings = {
      apiKeyHelper = "${pkgs.coreutils}/bin/cat ${config.sops.secrets.deepseek_api_key.path}";
      env = {
        ANTHROPIC_BASE_URL = "https://api.deepseek.com/anthropic";
        ANTHROPIC_MODEL = "deepseek-flash[1m]";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "deepseek-v4-pro[1m]";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "deepseek-flash[1m]";
        ANTHROPIC_DEFAULT_HAIKU_MODEL = "deepseek-flash";
        CLAUDE_CODE_SUBAGENT_MODEL = "deepseek-flash";
        CLAUDE_CODE_AUTO_COMPACT_WINDOW = "786432";
        API_TIMEOUT_MS = "600000";
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
      };
    };
  };
}
