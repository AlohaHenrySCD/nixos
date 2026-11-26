{
  config,
  lib,
  pkgs,
  ...
}:
let
  obsidianVaultFiles = {
    "community-plugins.json" = pkgs.writeText "obsidian-community-plugins.json" (
      builtins.toJSON [
        "background-tray"
      ]
    );
    "plugins/background-tray/main.js" = pkgs.fetchurl {
      url = "https://github.com/Synaphi/background-tray/releases/download/1.09.14/main.js";
      hash = "sha256-oFFWYLnutOnr1oi85ZHtNK9SCIZyHMsW6pZAeJ9FS10=";
    };
    "plugins/background-tray/manifest.json" = pkgs.fetchurl {
      url = "https://github.com/Synaphi/background-tray/releases/download/1.09.14/manifest.json";
      hash = "sha256-/IbWCCLEwsZ8ggSxAvpeNBo6VA5KVFg0PWuTBqudwoQ=";
    };
    "plugins/background-tray/styles.css" = pkgs.fetchurl {
      url = "https://github.com/Synaphi/background-tray/releases/download/1.09.14/styles.css";
      hash = "sha256-Pj+HusIxpnMdNwWbOBZwgeebYzToMl2T3Kv6V9+Ng3Q=";
    };

    "themes/Everforest/theme.css" = pkgs.concatText "obsidian-everforest.css" [
      (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/0xglitchbyte/obsidian_everforest/0b125d77156e1965e0b9489caccece65034582fb/obsidian.css";
        hash = "sha256-Wc0isaAFy2pkkX5Y/+yuyiXLWHGrh5f8qEvagdPdr0U=";
      })
      (pkgs.writeText "everforest-heading.css" (builtins.readFile ../../obsidian-everforest-heading.css))
    ];
    # Upstream provides a legacy stylesheet without a theme manifest.
    "themes/Everforest/manifest.json" = pkgs.writeText "obsidian-everforest-manifest.json" (
      builtins.toJSON {
        name = "Everforest";
        version = "0.0.0+0b125d7";
        minAppVersion = "1.0.0";
        author = "0xglitchbyte";
        authorUrl = "https://github.com/0xglitchbyte";
      }
    );
  };
in
{
  # Obsidian 会在笔记库中更新插件和主题，激活时复制为用户可写的文件。
  home.activation.obsidianVaultFiles = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: source:
        "run install -Dm644 ${source} ${lib.escapeShellArg "${config.home.homeDirectory}/Documents/obsidian/.obsidian/${name}"}"
      ) obsidianVaultFiles
    )
  );
}
