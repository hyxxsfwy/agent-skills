#!/usr/bin/env bash
# ============================================================
# update-skills.sh — 删除旧版 → 重新下载 → 重新安装
# 读取 skills-list.txt，逐行重放完整安装命令
# ============================================================
set -euo pipefail

LIST_FILE="${HOME}/git_repo/agent-skills/skills-list.txt"

if [ ! -f "$LIST_FILE" ]; then
    echo "❌ 找不到 $LIST_FILE"
    exit 1
fi

echo "=============================================="
echo "  Agent Skills 更新"
echo "=============================================="
echo ""

while IFS= read -r args; do
    # 跳过空行和注释行
    [ -z "$args" ] && continue
    [[ "$args" =~ ^[[:space:]]*# ]] && continue

    echo "----------------------------------------------"
    echo "  处理: $args"

    # 提取 skill 名
    skill=$(echo "$args" | sed -n 's/.*--skill[[:space:]]\+\([^[:space:]]\+\).*/\1/p')

    if [ -n "$skill" ]; then
        echo "  → 删除旧版 ~/.agents/skills/$skill"
        rm -rf "$HOME/.agents/skills/$skill"
    fi

    echo "  → 安装最新版"
    npx skills add $args

    echo ""
done < "$LIST_FILE"

echo "=============================================="
echo "  全部 Skill 更新完成！"
echo "=============================================="
