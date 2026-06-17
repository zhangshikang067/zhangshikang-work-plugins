<div align="center">

# work-reporter

### Work Report Writing Assistant — One Plugin for Weekly Reports & Performance Reviews

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](../LICENSE)

English | [中文](README_ZH.md)

</div>

Two skills, each with its own focus: weekly reports are auto-generated from git logs, and performance reviews are distilled from weekly reports.

## okr-weekly-writer — OKR Weekly Report

**Trigger**: "Help me write a weekly report" / "What did I do this week" / "Write a biweekly report"

| Feature | Description |
|---------|-------------|
| Git log scanning | Automatically scans commit history across multiple projects and date ranges |
| OKR alignment | Categorizes work items to corresponding KRs based on user OKR files |
| Manual mode | Skip git scanning — dictate or paste work content directly |
| Persistent config | First-time setup saved; returning users can skip configuration |

**Flow**: Load config → Collect parameters (date/project/OKR) → Scan git log → Filter & aggregate → Confirm items → Generate report

## monthly-performance-writer — Monthly Performance Review

**Trigger**: "Help me write a monthly performance review" / "Write a monthly self-evaluation" / "Summarize weekly reports into performance review"

| Feature | Description |
|---------|-------------|
| Weekly report extraction | Extract, deduplicate, and aggregate work items from multiple weekly reports |
| In-depth experience analysis | Scenarios + insights + methodology — demonstrate depth of thinking |
| Weakness framing | Repackage as "discoveries made while pursuing higher standards" |
| Feedback loop | Automatically records manager feedback; generates "action items" next month |

**Flow**: Collect reports/month/feedback → Extract & aggregate → Confirm items → Generate review → Revise → Persist feedback records

## Output Examples

**Weekly Report**:
```
Recent OKR Progress or Plans

O1-KR2: Payment capability building
- Completed third-party payment channel integration and callback testing, passed acceptance on schedule...

Recent Substantive Thoughts and Insights
- While investigating occasional callback failures, discovered a race condition in the retry mechanism...
```

**Performance Review**:
```
Work Review

(1) Key Work Summary
- Completed full-stack payment module development, reduced API response time by 60%, supported business launch on schedule

(2) Experience and Areas for Improvement
Experience:
- By abstracting a unified adapter layer, isolated channel differences at the integration layer...

Areas for Improvement:
- While pursuing a faster delivery pace, identified that the code review process has room for further refinement
```

## Installation / Update / Rollback

**npx skills (Recommended — supports Claude Code / Codex / Cursor and 50+ agents)**

```bash
# Install all skills
npx skills add zhangshikang067/zhangshikang-work-plugins

# Install a specific skill
npx skills add zhangshikang067/zhangshikang-work-plugins --skill okr-weekly-writer

# Install to Claude Code / Codex only
npx skills add zhangshikang067/zhangshikang-work-plugins -a claude-code
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

```bash
# Install directly via GitHub URL
/install-plugin https://github.com/zhangshikang067/zhangshikang-work-plugins

# Or clone and install locally
git clone https://github.com/zhangshikang067/zhangshikang-work-plugins.git \
  ~/.claude/plugins/zhangshikang-work-plugins
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

## License

MIT
