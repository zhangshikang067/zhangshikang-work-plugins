# zhangshikang-work-plugins

个人工作插件合集，兼容 Claude Code 和 Codex 等 AI Agent。

## 插件列表

### work-reporter

工作汇报写作助手，包含两个 skill：

| Skill | 说明 |
|-------|------|
| `monthly-performance-writer` | 月度绩效自评改写，自动从周报提取工作、美化不足、沉淀经验 |
| `okr-weekly-writer` | OKR 周报/双周报自动生成，支持 git commit 扫描和 OKR 归类对齐 |

## 安装

### Claude Code

```bash
# 方式一：克隆到插件目录
git clone <repo-url> ~/.claude/plugins/zhangshikang-work-plugins

# 方式二：在 Claude Code 中添加插件路径
claude plugin add /path/to/zhangshikang-work-plugins/work-reporter
```

### Codex

```bash
# 克隆到 Codex 插件目录
git clone <repo-url> ~/.codex/plugins/zhangshikang-work-plugins
```

## 使用

安装后，在对话中直接触发：

- "帮我写月度绩效" → 触发 `monthly-performance-writer`
- "帮我写周报" / "这周干了啥" → 触发 `okr-weekly-writer`

## 开发

```
zhangshikang-work-plugins/
├── work-reporter/                  # 插件
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── skills/
│   │   ├── monthly-performance-writer/
│   │   │   ├── SKILL.md
│   │   │   └── references/
│   │   └── okr-weekly-writer/
│   │       ├── SKILL.md
│   │       ├── scripts/
│   │       └── references/
│   └── README.md
└── README.md
```
