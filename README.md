# Agent Skills 维护仓库

统一管理所有 Agent Skill 的来源、安装参数，换电脑 / 重装 WSL / 迁移环境时一键恢复。

## 文件说明

| 文件 | 用途 |
|------|------|
| `skills-list.txt` | Skill 来源清单（完整可重放命令 + 注释），每行一条 |
| `install-skills.sh` | **首次安装** — 读取清单，逐行 `npx skills add` |
| `update-skills.sh` | **更新** — 先 `rm -rf` 旧版，再重新安装最新版 |

## 快速使用

```bash
# 首次安装（换电脑 / 重装后）
bash ~/git_repo/agent-skills/install-skills.sh

# 更新全部 Skill
bash ~/git_repo/agent-skills/update-skills.sh
```

## 当前 Skill 列表

| Skill | 来源 | 用途 |
|-------|------|------|
| `guizang-ppt-skill` | [op7418/guizang-ppt-skill](https://github.com/op7418/guizang-ppt-skill) | 横向翻页网页 PPT |
| `huashu-design` | [alchaincyf/huashu-design](https://github.com/alchaincyf/huashu-design) | HTML 高保真原型 / 交互 Demo / 动画 |
| `find-skills` | [vercel-labs/skills](https://github.com/vercel-labs/skills) | Skills.sh 生态发现与安装 |

## 添加新 Skill

在 `skills-list.txt` 末尾追加一行（保留注释格式）：

```text
# Category — 作者 · 一句话描述
https://github.com/<owner>/<repo> --skill <skill-name>
```

然后运行 `bash update-skills.sh` 即可。

## 已知问题

- **大型仓库可能克隆超时**（如含大量 demo 资源的 Skill）。脚本已设置 600s 超时，若仍失败，可手动浅克隆后本地安装：

  ```bash
  git clone --depth 1 https://github.com/<owner>/<repo>.git /tmp/<name>
  npx skills add /tmp/<name> --skill <name> -g -y
  rm -rf /tmp/<name>
  ```
