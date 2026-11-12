# 用户授权规则

- 读取配置、搜索、查看日志和状态等只读操作直接执行，无需逐次询问。
- 默认允许执行 `nix eval` 求值操作，无需逐次请求许可。
- 在用户明确许可前，不得写入文件，包括创建、修改、删除文件，以及命令产生的间接写入。
- `nix eval` 的默认许可仅涵盖求值，不包含文件写入；应使用 `--no-write-lock-file` 等适用选项避免隐式写入。需要写入时，必须先获得用户明确许可。
- 用户明确要求写入某个文件即视为对该次指定写入的许可，不扩展为其他文件写入的许可。

# 配置与协作约定

- 优先通过 NixOS / Home Manager 声明式管理配置、软件依赖、辅助脚本及 systemd 服务；获得写入许可后，修改对应声明源文件。配置放在职责对应的模块，主机专属设置放在对应 host 配置中，不重复添加，也不将独立功能堆入顶层配置。
- 配置保持格式清晰、结构易读，少写注释，避免冗余说明。
- 不为普通修改自动创建备份副本；用户明确要求保留旧配置时，按指定方式备份或注释停用。
- 优先使用原生模块或现成插件，避免不必要的自定义脚本。
- 默认交互 shell 为 Fish，提供终端命令时优先使用 Fish 兼容语法。
- 新增或调整功能时，除 Nix 求值外，还应检查必要依赖、相关服务状态及实际运行数据；未验证的部分应明确说明。
- 配置调整后，不要单独进行耗时构建验证；需要构建或应用改动时，直接使用 `nixos-rebuild`，不先额外运行一轮 `nix build`。关注二进制缓存和构建成本，不在未说明代价的情况下引入大型本地编译。
- 完成修改后，列出全部更改项、删除项和验证结果，以及是否需要 rebuild、重启服务或重新登录。

# Configuration placement

- Trace imports from flake.nix and modify the existing owning module. New modules
  require an explicit import; avoid duplicate declarations.
- Keep shared NixOS configuration in configuration.nix and modules/. Put
  host-specific settings under hosts/<host>/, accounting for host inheritance.
- Home Manager configuration belongs under home/: common settings are shared
  across platforms, while Linux and Darwin settings belong in their respective
  layers. Put host-specific user settings in the host's Home Manager configuration.
- Choose placement by responsibility and intended scope. Prefer focused modules
  for new features; keep flake.nix focused on dependencies and configuration wiring.
- Edit declarative sources rather than deployed files. Verify actual imports and
  platform compatibility instead of relying on directory names alone.
