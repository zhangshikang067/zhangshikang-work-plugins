<div align="center">

# work-reporter

### Work Report Writing Assistant — One Plugin for Weekly Reports & Performance Reviews

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](../LICENSE)

English | [中文](README_ZH.md)

</div>

Three skills, each with its own focus: weekly reports are generated from git logs and archived, performance reviews are distilled from archived weekly reports, and history initialization imports past materials into the data directory.

## okr-weekly-writer — OKR Weekly Report

**Trigger**: "Help me write a weekly report" / "What did I do this week" / "Write a biweekly report"

| Feature | Description |
|---------|-------------|
| Git log scanning | Automatically scans commit history across multiple projects and date ranges |
| OKR alignment | Supports multiple period-specific OKR files and selects by report period or user confirmation |
| Manual mode | Skip git scanning — dictate or paste work content directly |
| Weekly archive | Saves the confirmed final weekly report to `~/.work-reporter/weekly-reports/` for month-end reuse |
| Persistent config | First-time setup saved; returning users can skip configuration |

**Flow**: Load config → Collect parameters (date/project/OKR) → Scan git log → Filter & aggregate → Confirm items → Generate report → Confirm archive

## monthly-performance-writer — Monthly Performance Review

**Trigger**: "Help me write a monthly performance review" / "Write a monthly self-evaluation" / "Summarize weekly reports into performance review"

| Feature | Description |
|---------|-------------|
| Weekly report extraction | Reads archived weekly reports automatically; also supports pasted content or file paths |
| In-depth experience analysis | Scenarios + insights + methodology — demonstrate depth of thinking |
| Historical review reference | Reads archived monthly reviews to keep writing style and continuity consistent |
| Weakness framing | Repackage as "discoveries made while pursuing higher standards" |
| Feedback loop | Automatically records manager feedback; generates "action items" next month |

**Flow**: Determine month → Read archived weekly reports → Add feedback → Extract & aggregate → Confirm items → Generate review → Revise → Archive monthly review and feedback

## work-history-initializer — History Initialization

**Trigger**: "Import historical weekly reports" / "Initialize historical performance data" / "Import previous monthly reviews"

| Feature | Description |
|---------|-------------|
| Historical weekly import | Imports past OKR weekly and biweekly reports into `~/.work-reporter/weekly-reports/` |
| Monthly review import | Imports past performance reviews into `~/.work-reporter/monthly-reviews/` |
| Metadata backfill | Adds author, period, import time, and other front matter without rewriting content |
| Multi-OKR import | Preserves semantic file names such as `okr-2026h1` and `okr-review-2025h2` |
| Batch initialization | Supports pasted content, single files, or directories; skips conflicts by default |

User config, OKRs, weekly report archives, monthly review archives, and performance feedback are saved under `~/.work-reporter/` by default. Updating or rolling back the plugin only replaces skill program files and does not delete runtime data.

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
npx skills add 'zhangshikang067/zhangshikang-work-plugins#v1.3.3'
npx skills add 'zhangshikang067/zhangshikang-work-plugins#1.0.0'
```

Installing with `#tag` pins that version. To return to the latest version, run the install command again without `#tag`.

If you have already generated archives or config with `v1.2.0`, migrate old data before updating:

```bash
SKILLS_ROOT="${SKILLS_ROOT:-$HOME/.agents/skills}"
mkdir -p ~/.work-reporter/config ~/.work-reporter/okr ~/.work-reporter/weekly-reports ~/.work-reporter/feedback
cp -n "$SKILLS_ROOT/okr-weekly-writer"/references/*-config.md ~/.work-reporter/config/ 2>/dev/null || true
cp -n "$SKILLS_ROOT/okr-weekly-writer"/references/*-okr.md ~/.work-reporter/okr/ 2>/dev/null || true
cp -n "$SKILLS_ROOT/okr-weekly-writer"/outputs/*.md ~/.work-reporter/weekly-reports/ 2>/dev/null || true
cp -n "$SKILLS_ROOT/monthly-performance-writer"/references/*-manager-feedback.md ~/.work-reporter/feedback/ 2>/dev/null || true
cp -n "$SKILLS_ROOT/monthly-performance-writer"/references/*-ai-improvement-suggestions.md ~/.work-reporter/feedback/ 2>/dev/null || true
```

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
