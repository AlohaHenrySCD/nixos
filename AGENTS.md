# 授权与写入边界

- 读取配置、搜索、查看日志与状态，以及只读 `nix eval` 可直接执行，无需逐次询问。
- 未经用户明确许可，不得创建、修改、删除文件，也不得执行会产生间接写入的命令；执行 `nix eval` 时应加 `--no-write-lock-file` 等选项避免隐式改动。
- 用户明确要求修改指定文件即构成该范围内的写入许可，不自动扩展到其他文件。委派给 subagent 时，父 agent 可转达用户已授予的指定文件写权限，范围仍受同一限制。

# 架构与配置放置

从 `flake.nix` 追踪实际导入关系，优先修改现有归属模块；新增模块必须显式导入，避免重复声明，并核对跨平台兼容性而非仅凭目录名判断。始终编辑声明源文件，不直接改已部署产物。

- `flake.nix`：仅保留 inputs 与配置装配；`nixpkgs-kernel` 与 `nixos-apple-silicon` 为刻意固定版本（见 `hosts/asahi/kernel.nix`），不要顺手升级。
- `constants.nix` / `theme.nix`：共享用户与代理常量、Everforest 配色、字体、光标及 `theme.render` 模板工具；优先复用，避免在各模块硬编码。
- `overlays/default.nix` + `packages/`：本地自定义包统一通过 overlay 暴露为 `pkgs.<name>`，避免在业务模块中分散 `callPackage`。
- `configuration.nix`、`darwin-configuration.nix`、`modules/`：跨 NixOS/Darwin 的公共系统配置放 `modules/common/`；Linux 共享系统模块放 `modules/` 与 `configuration.nix`；macOS 系统配置放 `darwin-configuration.nix`。
- `hosts/<host>/`：主机专属系统配置放 `hosts/<host>/`，主机专属用户配置放 `hosts/<host>/home.nix`（通过 `flake.nix` 的 `hostHomeModules` 注入）；注意继承关系（如 `asahi-debug` 继承 `hosts/asahi` 并共用 `hosts/asahi/home.nix`）。
- `home/`：Home Manager 共享层为 `home/home.nix` 与 `home/modules/common/`，平台层分别为 `home/linux.nix` + `home/modules/linux/` 与 `home/darwin.nix`。
- `secrets/`：机密统一经 `sops-nix` 加密管理，不写入明文凭据。

# 配置与实现规范

- 优先通过 NixOS / nix-darwin / Home Manager 声明式管理配置、软件依赖、辅助脚本及 systemd 服务；优先使用原生模块或现成插件，避免不必要的自定义脚本。
- 按职责拆分模块。普通声明由选项名和取值说明用途，省去复述配置的注释。删除已注释停用的代码，历史版本从 Git 查阅。
- 文件从上到下依次放模块接口（`imports`、`options`）、常改的数据表和主声明、按主题分节的常规配置、底层适配与补丁。超过约 80 行用 `# ── <主题> ──` 分节。导入按组排序，保留影响合并结果的顺序；长包表和键位表按用途或键区分组。单处使用的辅助定义放在使用处的局部 `let`。
- 自定义数据表、特殊字符串和反直觉的环境变量、`overrideAttrs` 和源码补丁、用 `home.activation` 写可编辑文件，以及跨模块的隐式依赖，用 1–4 行说明原因与使用契约；临时适配注明何时可以移除。
- 不为普通修改自动创建备份副本；仅在用户明确要求保留旧配置时按指定方式备份或注释停用。
- 默认交互 shell 为 Fish，提供终端命令时优先使用 Fish 兼容语法。

# 快捷键与用法指南（`manual/`）

- 新增、修改或删除快捷键时，必须在同一次改动中同步更新 `manual/` 下对应工具的独立用法指南；增删指南时同步更新 `manual/shortcuts.md`，并在 `manual/task-index.md` 维护中英文用途关键词与章节直达链接。
- 编写标准：以方便查找和检索为准，顶部提供用途目录，正文按移动、查找、编辑等用途分节，用精简的“快捷键 / 用途”表格和常用操作序列呈现；重点覆盖 Helix、Mitos、Kitty、Fish、Niri，同时整理小工具、辅助命令、鼠标操作及跨工具组合用法。
- 压缩与准确度：将方向、首尾、前后、翻页、增减等相近操作合并为一行且按键与作用顺序一致；连续编号用范围表示，合并相同用法，仅在有区别时注明模式；不列内部 command/binding 字段或重复铺陈默认配置。核对默认快捷键与本地覆盖，保留必要的适用条件和配置源链接；涉及 `keyd` 时区分物理按键与应用收到的按键，未自动部署的配置须注明。

# 验证与交付

- 修改共享层或跨平台模块时，用 `nix eval --no-write-lock-file` 检查受影响的目标配置；新增或调整功能时，除 Nix 求值外还应检查必要依赖、相关服务状态及实际运行数据，未验证项须明确说明。
- 配置调整后不单独进行耗时构建验证；需要构建或应用改动时直接使用 `nixos-rebuild` / `darwin-rebuild`，不先额外运行一轮 `nix build`。关注二进制缓存和构建成本，不在未说明代价的情况下引入大型本地编译。
- 完成修改后，列出全部更改项、删除项、验证结果（含未验证项），以及是否需要 rebuild、重启服务或重新登录。
