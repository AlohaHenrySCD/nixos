# NixOS 与 macOS 配置

从 `flake.nix` 选择主机。完整系统同时加载主机配置和 Home Manager 用户配置。

| 目录或文件 | 用途 |
| --- | --- |
| `flake.nix` | 声明依赖，装配系统与独立 Home Manager 目标 |
| `constants.nix` | 用户名、代理地址等共享值 |
| `theme.nix` | Everforest 配色、字体、光标和配置模板渲染 |
| `overlays/`、`packages/` | 定义本地软件包，通过 overlay 加入软件包集合 |
| `modules/` | NixOS 共享系统配置，跨平台部分放在 `common/` |
| `hosts/` | 主机硬件、内核和主机专属用户配置 |
| `home/` | 完整用户环境，按共享、Linux、macOS 三层组织 |
| `home-minimal/` | 新机器可独立启用的最小命令行环境 |
| `secrets/` | 由 sops-nix 管理的加密配置 |
| `manual/` | 快捷键、工具用法和迁移步骤 |

| 目标 | 适用环境 |
| --- | --- |
| `asahi` | Apple 芯片 Mac 上的日常 NixOS 系统 |
| `asahi-debug` | 继承 Asahi 配置，使用本地 Linux 内核源码，需要 `--impure` |
| `x86_64` | x86_64 Linux 主机，安装时需生成该机的 `hardware-configuration.nix` |
| `macbook` | Apple 芯片 Mac 的 nix-darwin 系统 |
| `minimal-*` | 独立 Home Manager，支持 aarch64-linux、x86_64-linux 和 aarch64-darwin |

## 常用 Fish 命令

- `bd` 重建并切换当前系统。Linux 使用 `/etc/nixos`，macOS 使用 `~/my-nix`。
- `bd-debug` 在 Asahi 上重建并切换到本地调试内核。
- `nix-clean` 回收用户和 root 不再引用的 Nix 存储项，Linux 上还会按 300 MB 的限额清理归档日志。
- `nix fmt home/linux.nix` 用仓库指定的格式化器整理该文件，可替换为其他 Nix 文件。

[快捷键与工具用法](manual/shortcuts.md) · [系统迁移与重装](manual/migration.md)
