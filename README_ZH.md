<div align="center">

# zhangshikang-work-plugins

### 个人工作流插件合集，兼容 Claude Code / Codex 等 AI Agent

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

[English](README.md) | 中文

</div>

## 插件

| 插件 | 说明 |
|------|------|
| [work-reporter](./work-reporter/) | 工作汇报写作助手 — OKR 周报自动生成 & 月度绩效自评改写 |

---

## 安装 / 更新 / 回退

**npx skills（推荐，支持 Claude Code / Codex / Cursor 等 50+ Agent）**

```bash
# 安装所有 skills
npx skills add zhangshikang067/zhangshikang-work-plugins

# 只安装指定 skill
npx skills add zhangshikang067/zhangshikang-work-plugins --skill okr-weekly-writer

# 指定安装到 Claude Code
npx skills add zhangshikang067/zhangshikang-work-plugins -a claude-code

# 指定安装到 Codex
npx skills add zhangshikang067/zhangshikang-work-plugins -a codex
```

更新或回退版本：

```bash
# 更新已安装的 skills 到最新版本
npx skills update

# 只更新全局安装的 skills
npx skills update -g

# 安装或回退到指定 tag
npx skills add 'zhangshikang067/zhangshikang-work-plugins#v1.1.0'
npx skills add 'zhangshikang067/zhangshikang-work-plugins#1.0.0'
```

使用 `#tag` 安装会固定到对应版本；需要回到最新版本时，重新使用不带 `#tag` 的安装命令。

**Claude Code**

在 Claude Code 会话中运行：

```
/install-plugin https://github.com/zhangshikang067/zhangshikang-work-plugins
```

或克隆后本地安装：

```bash
git clone https://github.com/zhangshikang067/zhangshikang-work-plugins.git \
  ~/.claude/plugins/zhangshikang-work-plugins
```

然后在会话中：

```
/install-plugin ~/.claude/plugins/zhangshikang-work-plugins
```

本地安装后可用 git 更新或回退：

```bash
cd ~/.claude/plugins/zhangshikang-work-plugins
git fetch --tags

# 更新到最新 main
git checkout main
git pull --ff-only

# 回退到指定 tag
git checkout 1.0.0
```

## 快速开始

安装后在对话中直接说：

| 你说 | 触发 |
|------|------|
| "帮我写周报" / "这周干了啥" | `okr-weekly-writer` — 扫描 git log，生成 OKR 对齐的周报 |
| "帮我写月度绩效" / "写个月度自评" | `monthly-performance-writer` — 从周报提炼，生成月度绩效自评 |

## 目录结构

```
zhangshikang-work-plugins/
├── work-reporter/                  # 工作汇报插件
│   ├── .claude-plugin/plugin.json  #   插件清单
│   ├── skills/
│   │   ├── monthly-performance-writer/
│   │   │   ├── SKILL.md            #     月度绩效 skill
│   │   │   └── references/         #     写法模板
│   │   └── okr-weekly-writer/
│   │       ├── SKILL.md            #     OKR 周报 skill
│   │       ├── scripts/            #     git log 扫描脚本
│   │       └── references/         #     OKR 模板
│   └── README.md
├── .gitignore
└── README.md                       # ← 你在这里
```

## License

MIT
