# 系统迁移与重装指南

换新机器或重装系统时按顺序照做即可。命令默认使用 Fish 语法。

**目录**：[1. 旧机先带走什么](#1-旧机先带走什么) · [2. 新机先起临时环境](#2-新机先起临时环境home-minimal) · [3. 切到完整系统](#3-切到完整系统) · [4. 切完收尾与常见坑](#4-切完收尾与常见坑)

---

## 1. 旧机先带走什么

仓库里已经存了全部系统配置，只有**私钥**和**本地用户数据**不在 Git 里：

| 类别 | 路径 | 说明 |
| --- | --- | --- |
| **SSH 私钥（必带）** | `~/.ssh/id_ed25519`、`id_ed25519_blog`、`id_ed25519_nixpkgs` | Git 推拉代码用（见 [ssh.nix](../home/modules/common/ssh.nix)） |
| **sops 密钥（必带）** | `~/.config/sops/age/keys.txt` | 解密 [secrets.yaml](../secrets/secrets.yaml)（如 DeepSeek API Key） |
| **Obsidian 笔记** | `~/Documents/obsidian` | 笔记本体不在仓库里，主题和插件会自动同步 |
| **Flatpak 应用数据** | `~/.var/app/<app-id>/` | Vesktop、qBittorrent、PrismLauncher、网易云、VLC、Haruna、Halloy、Bazecor 等登录态与存档 |
| **浏览器与微信** | `~/.config/chromium`、`~/.xwechat` | 书签、登录态与聊天记录 |
| **Clash 订阅** | Linux: `~/.local/share/io.github.clash-verge-rev.clash-verge-rev/`<br>macOS: `~/Library/Application Support/io.github.clash-verge-rev.clash-verge-rev/` | 订阅链接与配置，分流规则会自动同步 |
| **个人词库 / 本地源码** | `~/.local/share/fcitx5/rime/*.userdb`、`~/git/mitos` | 按需带走；`mitos` 用于本地编译 `ms` |

---

## 2. 新机先起临时环境（`home-minimal`）

新机器装完 Nix（开启 `flakes`）并拉下仓库后，**先别直接编完整系统**——先起 `home-minimal`，几秒就能拿到 `hx`、`fish`、`git`、`ssh`、`sops`/`age`、`nil`、`nixfmt` 和 `pi`（`pi-coding-agent`），方便改配置和让 AI 帮你适配新硬件。

1. 拉仓库（Linux 放 `/etc/nixos`，macOS 放 `~/my-nix`）：
   ```fish
   git clone <仓库地址> /etc/nixos
   ```
2. 拉起 `home-minimal`（自动识别当前架构，来源见 [home-minimal/default.nix](../home-minimal/default.nix)）：
   ```fish
   set system (nix eval --impure --raw --expr builtins.currentSystem)
   set profile "minimal-$system"
   nix run "/etc/nixos#homeConfigurations.$profile.config.programs.home-manager.package" -- \
       switch --flake "/etc/nixos#$profile"
   ```
   *(macOS 把路径里的 `/etc/nixos` 换成 `~/my-nix`。)*
3. 放回密钥并收紧权限：
   ```fish
   mkdir -p ~/.ssh ~/.config/sops/age
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/id_ed25519* ~/.config/sops/age/keys.txt
   ```

---

## 3. 切到完整系统

### 新 Linux 机器（如 `x86_64`）

1. 生成硬件配置并让 Git 看见新文件：
   ```fish
   nixos-generate-config --show-hardware-config > /etc/nixos/hosts/x86_64/hardware-configuration.nix
   git -C /etc/nixos add -N hosts/x86_64/hardware-configuration.nix
   ```
2. 按新机器情况补几项主机配置（参考 [hosts/asahi/](../hosts/asahi/default.nix)）：
   - 主机名：`networking.hostName`（要和 [flake.nix](../flake.nix) 里的配置名一致，`bd` 依赖它）
   - 显示器：进桌面后跑 `niri msg outputs`，可参考 [Asahi 的输出配置](../hosts/asahi/niri-outputs.kdl)，按需建 `hosts/<host>/niri-outputs.kdl`
   - 键盘映射：如需在内置/外接键盘启用 `keyd` 分层，用 `sudo keyd monitor` 查设备 ID，填进 `my.keyd.internalKeyboardIds`（见 [modules/keyd.nix](../modules/keyd.nix)）
   - 非 Btrfs 机器不要开 `services.btrfs.autoScrub`
3. 如有旧的 Flatpak 应用数据，**先复制到 `~/.var/app/<app-id>/`**（不覆盖已有文件）：
   ```fish
   cp -a --update=none <备份目录>/.var/app/* ~/.var/app/
   ```
4. 切换完整系统：
   ```fish
   sudo nixos-rebuild switch -L --flake /etc/nixos#x86_64
   ```
   切换时 `flatpak-sync.service` 会自动从 Flathub 补装 [flatpak.nix](../home/modules/linux/flatpak.nix) 声明的 14 个应用，另开终端看进度：
   ```fish
   journalctl --user -u flatpak-sync -f
   ```

### 重装 Asahi（Apple Silicon Linux）

1. 把新分区的硬件配置覆盖到 `hosts/asahi/hardware-configuration.nix`。
2. 直接切 `#asahi`：
   ```fish
   sudo nixos-rebuild switch -L --flake /etc/nixos#asahi
   ```
3. 注意：[flake.nix](../flake.nix) 里的 `nixpkgs-kernel` 和 `nixos-apple-silicon` 是刻意锁定的版本，别顺手 `nix flake update` 它们。

### 新 macOS（Apple Silicon）

1. 先装 Homebrew 和 Nix（开启 `flakes`），克隆仓库到 `~/my-nix`。
2. 如主机名不是 `macbook`，同步改 [flake.nix](../flake.nix) 的 `darwinConfigurations.<host>` 和 [home/darwin.nix](../home/darwin.nix) 里的 `bd`。
3. 首次切换（之后直接用 `bd`）：
   ```fish
   sudo nix run nix-darwin -- switch --flake ~/my-nix#macbook
   ```
4. 首次手动收尾（macOS 系统限制，做一次就行）：
   - 登录 Tailscale：`tailscale up --accept-dns=false --operator=alohahenry`
   - 在系统设置给 Raycast、LinearMouse、MonitorControl、Background Music 放行辅助功能/音频权限
   - 在 Clash Verge 导入订阅（已有分流规则会自动同步）

---

## 4. 切完收尾与常见坑

- **新文件报找不到**：Flake 只认 Git 追踪的文件，任何新建的 `.nix`/`.kdl` 都要先 `git -C /etc/nixos add -N <文件>`。
- **`ms` 找不到**：完整配置的默认编辑器是本地编译的 Mitos（`~/.cargo/bin/ms`）；还没编译前直接用 `hx`。
- **服务或快捷键没生效**：Linux 首次切换完重新登录一次 Niri，让 `cliphist`、`waybar`、`fcitx5` 和新主机名全部生效。
- **一条命令查核心服务状态（Linux）**：
  ```fish
  systemctl --user status flatpak-sync cliphist cliphist-images waybar --no-pager
  ```
- **后续日常更新**：直接跑 `bd`；清理旧代用 `nix-clean`。

[返回全部指南](shortcuts.md) · [按用途查找](task-index.md)
