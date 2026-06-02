#!/usr/bin/env bash
# ============================================================
# install-skills.sh — 从头安装全部 Skill（换电脑/重装 WSL 后一键恢复）
# 读取 skills-list.txt，逐行安装
# ============================================================
set -euo pipefail

LIST_FILE="${HOME}/git_repo/agent-skills/skills-list.txt"

if [ ! -f "$LIST_FILE" ]; then
    echo "❌ 找不到 $LIST_FILE"
    exit 1
fi

echo "=============================================="
echo "  Agent Skills 一键安装"
echo "=============================================="
echo ""

while IFS= read -r args; do
    # 跳过空行和注释行
    [ -z "$args" ] && continue
    [[ "$args" =~ ^[[:space:]]*# ]] && continue

    echo "----------------------------------------------"
    echo "  安装: $args"
    npx skills add $args
    echo ""
done < "$LIST_FILE"

echo "=============================================="
echo "  全部 Skill 安装完成！"
echo "=============================================="
