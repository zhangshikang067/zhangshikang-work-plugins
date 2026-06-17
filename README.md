<div align="center">

# zhangshikang-work-plugins

### Personal Workflow Plugin Collection for AI Coding Agents

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

English | [中文](README_ZH.md)

</div>

## Plugins

| Plugin | Description |
|--------|-------------|
| [work-reporter](./work-reporter/) | Work report writing assistant — OKR weekly report auto-generation & monthly performance review rewriting |

---

## Installation / Update / Rollback

**npx skills (Recommended — supports Claude Code / Codex / Cursor and 50+ agents)**

```bash
# Install all skills
npx skills add zhangshikang067/zhangshikang-work-plugins

# Install a specific skill
npx skills add zhangshikang067/zhangshikang-work-plugins --skill okr-weekly-writer

# Install to Claude Code only
npx skills add zhangshikang067/zhangshikang-work-plugins -a claude-code

# Install to Codex only
npx skills add zhangshikang067/zhangshikang-work-plugins -a codex
```

Update or roll back versions:

```bash
# Update installed skills to the latest version
npx skills update

# Update global skills only
npx skills update -g

# Install or roll back to a specific tag
npx skills add 'zhangshikang067/zhangshikang-work-plugins#v1.1.0'
npx skills add 'zhangshikang067/zhangshikang-work-plugins#1.0.0'
```

Installing with `#tag` pins that version. To return to the latest version, run the install command again without `#tag`.

**Claude Code**

In a Claude Code session, run:

```
/install-plugin https://github.com/zhangshikang067/zhangshikang-work-plugins
```

Or clone and install locally:

```bash
git clone https://github.com/zhangshikang067/zhangshikang-work-plugins.git \
  ~/.claude/plugins/zhangshikang-work-plugins
```

Then in the session:

```
/install-plugin ~/.claude/plugins/zhangshikang-work-plugins
```

After local installation, update or roll back with git:

```bash
cd ~/.claude/plugins/zhangshikang-work-plugins
git fetch --tags

# Update to latest main
git checkout main
git pull --ff-only

# Roll back to a specific tag
git checkout 1.0.0
```

## Quick Start

After installation, simply say:

| What you say | Triggered skill |
|-------------|-----------------|
| "Help me write a weekly report" / "What did I do this week" | `okr-weekly-writer` — scans git log, generates OKR-aligned weekly report |
| "Help me write a monthly performance review" / "Write a monthly self-evaluation" | `monthly-performance-writer` — extracts from weekly reports, generates performance review |

## Directory Structure

```
zhangshikang-work-plugins/
├── work-reporter/                  # Work report plugin
│   ├── .claude-plugin/plugin.json  #   Plugin manifest
│   ├── skills/
│   │   ├── monthly-performance-writer/
│   │   │   ├── SKILL.md            #     Monthly performance skill
│   │   │   └── references/         #     Writing templates
│   │   └── okr-weekly-writer/
│   │       ├── SKILL.md            #     OKR weekly report skill
│   │       ├── scripts/            #     Git log scanning scripts
│   │       └── references/         #     OKR templates
│   └── README.md
├── .gitignore
└── README.md                       # ← You are here
```

## License

MIT
