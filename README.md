# auto_set_fcitx5_in_arch_hyprland

## 简介

这是一个为 Arch Linux 用户设计的自动化脚本，旨在简化 Fcitx5 输入法框架、雾凇拼音以及大模型联想词的配置过程。本脚本将自动执行大部分配置步骤，包括环境变量设置、Hyprland 自动启动配置、雾凇拼音的安装与优化，以及大模型联想词的集成。

## 功能特性

- **Fcitx5 基础配置**：设置 GTK_IM_MODULE、QT_IM_MODULE 和 XMODIFIERS 环境变量。
- **Hyprland 集成**：自动配置 Hyprland 以在启动时运行 Fcitx5。
- **雾凇拼音安装与优化**：克隆 `rime-ice` 仓库并应用优化配置（如调整候选词数量）。
- **大模型联想词集成**：下载并配置 `wanxiang-lts-zh-hans.gram` 大模型联想词，提升输入体验。
- **详细日志记录**：所有执行步骤和输出都将记录到 `/tmp` 目录下的日志文件中，方便排查问题。
- **临时文件清理**：脚本执行完毕后，会自动清理下载的临时文件。

## 安装与使用

**重要提示：**

1. **Arch Linux 环境**：本脚本专为 Arch Linux 设计。在运行脚本前，请确保您正在 Arch Linux 环境中操作。
2. **手动安装 Fcitx5 核心组件**：由于 `pacman` 命令需要 `sudo` 权限且无法在非 Arch Linux 环境中自动执行，脚本不会自动安装 Fcitx5 的核心软件包。请您在运行脚本前，手动执行以下命令安装所需软件包：

   ```bash
   sudo pacman -S fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool fcitx5-rime --noconfirm
   ```

3. **重启系统**：脚本执行完毕后，建议您重启系统以使所有配置生效。

### 步骤

1. **下载脚本**：

   ```bash
   git clone https://github.com/mcxiaochenn/auto_set_fcitx5_in_arch_hyprland.git
   cd auto_set_fcitx5_in_arch_hyprland/Script
   ```

2. **赋予执行权限**：

   ```bash
   chmod +x setup_fcitx5_rime.sh
   ```

3. **运行脚本**：

   ```bash
   ./setup_fcitx5_rime.sh
   ```

   脚本将引导您完成配置过程，并在执行过程中输出详细步骤和日志信息。

## 日志文件

脚本执行期间的所有输出和错误信息都将记录到 `/tmp` 目录下的一个日志文件中。日志文件的命名格式为 `fcitx5_rime_setup_YYYYMMDD_HHMMSS.log`，其中 `YYYYMMDD_HHMMSS` 是脚本执行的时间戳。脚本执行完毕后，会提示您日志文件的具体位置。

## 注意事项

- 本脚本会修改 `/etc/environment` 文件和 `~/.config/hypr/hyprland.conf` 文件。在运行脚本前，建议您备份这些文件。
- 脚本中的 `sed` 命令用于修改 `rime-ice` 的 `default.yaml` 文件。如果您有自定义的 `rime-ice` 配置，请在运行脚本前进行备份，或根据需要调整脚本内容。
- 大模型联想词文件 `wanxiang-lts-zh-hans.gram` 较大，下载可能需要一些时间，请耐心等待。

## 参考文献

- [Arch Linux 下 Fcitx5 雾凇拼音和大模型联想词一件套](https://linux.do/t/topic/537067)


## 📜 许可证
本项目采用 MIT 许可证（[完整条款]((LICENSE))）：
- 允许商用、私用、修改、分发
- 允许专利使用、再授权
- 无责任条款

只需保留 版权声明 和 许可证文件，即可自由使用。


## ⭐Star
[![Stars](https://starchart.cc/mcxiaochenn/auto_set_fcitx5_in_arch_hyprland.svg?variant=adaptive)](https://github.com/mcxiaochenn/auto_set_fcitx5_in_arch_hyprland)
