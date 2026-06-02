#!/usr/bin/env bash
# ============================================================
# update-skills.sh — 删除旧版 → 重新下载 → 重新安装
# 读取 skills-list.txt，逐行重放完整安装命令
# ============================================================
set -uo pipefail

LIST_FILE="${HOME}/git_repo/agent-skills/skills-list.txt"

if [ ! -f "$LIST_FILE" ]; then
    echo "❌ 找不到 $LIST_FILE"
    exit 1
fi

echo "=============================================="
echo "  Agent Skills 更新"
echo "=============================================="
echo ""

fail_count=0
total=0

while IFS= read -r args; do
    # 跳过空行和注释行
    [ -z "$args" ] && continue
    [[ "$args" =~ ^[[:space:]]*# ]] && continue

    total=$((total + 1))

    echo "----------------------------------------------"
    echo "  处理: $args"

    # 提取 skill 名
    skill=$(echo "$args" | sed -n 's/.*--skill[[:space:]]\+\([^[:space:]]\+\).*/\1/p')

    if [ -n "$skill" ]; then
        echo "  → 删除旧版 ~/.agents/skills/$skill"
        rm -rf "$HOME/.agents/skills/$skill"
        # 同时清理可能存在的项目本地安装
        rm -rf "$HOME/git_repo/.agents/skills/$skill" 2>/dev/null || true
    fi

    echo "  → 安装最新版"
    if SKILLS_CLONE_TIMEOUT_MS=600000 npx skills add $args -g -y </dev/null; then
        echo "  ✅ 成功"
    else
        echo "  ❌ 安装失败（网络问题？可重试）"
        fail_count=$((fail_count + 1))
    fi

    echo ""
done < "$LIST_FILE"

echo "=============================================="
echo "  更新完成: $((total - fail_count))/$total 成功"
[ "$fail_count" -gt 0 ] && echo "  ⚠ $fail_count 个失败（可重新运行本脚本重试）"
echo "=============================================="
