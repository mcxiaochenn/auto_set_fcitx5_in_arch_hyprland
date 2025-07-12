#!/bin/bash

LOG_FILE="/tmp/fcitx5_rime_setup_$(date +%Y%m%d_%H%M%S).log"
TEMP_FILES=()

# 将所有输出重定向到日志文件
exec 3>&1 1>$LOG_FILE 2>&1

echo "$(date): 脚本开始执行"

# 函数：记录步骤并执行命令
execute_step() {
    STEP_DESC=$1
    COMMAND=$2
    echo "\n--- 步骤：$STEP_DESC ---"
    echo "执行命令：$COMMAND"
    eval $COMMAND
    if [ $? -ne 0 ]; then
        echo "错误：$STEP_DESC 失败。请检查日志文件 $LOG_FILE 获取详细信息。"
        exit 1
    fi
}

# 函数：清理临时文件
cleanup() {
    echo "\n--- 清理临时文件 ---"
    for file in "${TEMP_FILES[@]}"; do
        if [ -f "$file" ] || [ -d "$file" ]; then
            echo "删除临时文件：$file"
            rm -rf "$file"
        fi
    done
}

# 注册清理函数，确保脚本退出时执行
trap cleanup EXIT

# 步骤 1: 安装 Fcitx5
# 注意：此步骤依赖于 Arch Linux 的 pacman 包管理器，无法在当前 Ubuntu 环境中执行。
# 请在 Arch Linux 环境中手动执行或确保 pacman 可用。
execute_step "安装 Fcitx5" "echo '请在 Arch Linux 环境中手动执行此步骤：sudo pacman -S fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool fcitx5-rime --noconfirm'"

# 步骤 2: 配置环境变量
execute_step "配置环境变量" "echo -e 'export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS=\"@im=fcitx\"' | sudo tee -a /etc/environment"

# 步骤 3: 配置 Hyprland 自动启动 Fcitx5
execute_step "配置 Hyprland 自动启动 Fcitx5" "mkdir -p ~/.config/hypr && echo 'exec-once = fcitx5 --replace -d' >> ~/.config/hypr/hyprland.conf"

# 步骤 4: 雾凇拼音
RIME_DIR="$HOME/.local/share/fcitx5/rime"
RIME_ICE_DIR="$RIME_DIR/rime-ice"
mkdir -p "$RIME_DIR"
if [ ! -d "$RIME_ICE_DIR" ]; then
    execute_step "克隆雾凇拼音仓库" "cd \"$RIME_DIR\" && git clone https://github.com/iDvel/rime-ice --depth=1"
else
    echo "雾凇拼音仓库已存在，跳过克隆。"
fi

# 步骤 4.1: 雾凇优化
execute_step "优化雾凇拼音配置" "sed -i 's/# \\(- { when: \\(paging\\|has_menu\\), accept: \\(comma\\|period\\), send: Page_\\(Up\\|Down\\) }\\)/\\1/' \"$RIME_ICE_DIR/default.yaml\" && sed -i 's/page_size: 5/page_size: 9/' \"$RIME_ICE_DIR/default.yaml\""

# 步骤 5: 语言大模型
LMDG_URL="https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram"
LMDG_FILE="wanxiang-lts-zh-hans.gram"
execute_step "下载语言大模型文件" "wget -P \"$RIME_DIR\" $LMDG_URL"
TEMP_FILES+=("$RIME_DIR/$LMDG_FILE")

execute_step "创建 rime_ice.custom.yaml 文件" "cat <<EOF > \"$RIME_DIR/rime_ice.custom.yaml\"
patch:
  grammar:
    language: wanxiang-lts-zh-hans
    collocation_max_length: 5
    collocation_min_length: 2
  translator/contextual_suggestions: true
  translator/max_homophones: 7
  translator/max_homographs: 7
EOF"

# 将输出重定向回终端
exec 1>&3 2>&3

echo "\n$(date): 脚本执行完毕。"
echo "日志文件已保存至：$LOG_FILE"

read -p "是否重启系统以使配置生效？(y/n): " REBOOT_CHOICE
if [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]]; then
    sudo reboot
else
    echo "请在方便时手动重启系统。"
fi


