#!/usr/bin/env bash
# ============================================================
# install-skills.sh — 从头安装全部 Skill（换电脑/重装 WSL 后一键恢复）
# 读取 skills-list.txt，逐行安装
# ============================================================
set -uo pipefail

LIST_FILE="${HOME}/git_repo/agent-skills/skills-list.txt"

if [ ! -f "$LIST_FILE" ]; then
    echo "❌ 找不到 $LIST_FILE"
    exit 1
fi

echo "=============================================="
echo "  Agent Skills 一键安装"
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
    echo "  安装: $args"
    if SKILLS_CLONE_TIMEOUT_MS=600000 npx skills add $args -g -y </dev/null; then
        echo "  ✅ 成功"
    else
        echo "  ❌ 安装失败（网络问题？可重试）"
        fail_count=$((fail_count + 1))
    fi
    echo ""
done < "$LIST_FILE"

echo "=============================================="
echo "  安装完成: $((total - fail_count))/$total 成功"
[ "$fail_count" -gt 0 ] && echo "  ⚠ $fail_count 个失败（可重新运行本脚本重试）"
echo "=============================================="
