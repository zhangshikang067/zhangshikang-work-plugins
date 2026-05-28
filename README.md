# zhangshikang-work-plugins

> 个人工作流插件合集，兼容 Claude Code / Codex 等 AI Agent

## 插件

| 插件 | 说明 |
|------|------|
| [work-reporter](./work-reporter/) | 工作汇报写作助手 — OKR 周报自动生成 & 月度绩效自评改写 |

---

## 安装

**Claude Code**

```bash
# 克隆到插件目录
git clone https://github.com/zhangshikang/zhangshikang-work-plugins.git \
  ~/.claude/plugins/zhangshikang-work-plugins
```

或在 Claude Code 会话中：

```
/install-plugin /path/to/zhangshikang-work-plugins/work-reporter
```

**Codex**

```bash
git clone https://github.com/zhangshikang/zhangshikang-work-plugins.git \
  ~/.codex/plugins/zhangshikang-work-plugins
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
