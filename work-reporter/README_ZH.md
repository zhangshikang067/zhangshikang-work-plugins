<div align="center">

# work-reporter

### 工作汇报写作助手 — 一个插件搞定周报和绩效

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](../LICENSE)

[English](README.md) | 中文

</div>

三个 skill 各司其职：周报从 git log 自动生成并归档，绩效从已归档周报自动提炼，历史初始化负责把过往材料导入数据目录。

## okr-weekly-writer — OKR 周报

**触发**："帮我写周报" / "这周干了啥" / "写个双周报"

| 能力 | 说明 |
|------|------|
| git log 扫描 | 自动扫描多项目、多日期范围的 commit 记录 |
| OKR 对齐 | 支持多个周期 OKR 文件，按周报日期选择或让用户确认 |
| 手动模式 | 不扫 git，直接口述或粘贴工作内容 |
| 周报归档 | 用户确认最终版后自动保存到 `~/.work-reporter/weekly-reports/`，方便月底复用 |
| 配置持久化 | 首次配置后，老用户一步到位 |

**流程**：加载配置 → 交互采集参数（日期/项目/OKR）→ 扫描 git log → 过滤聚合 → 确认事项 → 改写生成 → 确认归档

## monthly-performance-writer — 月度绩效

**触发**："帮我写月度绩效" / "写个月度自评" / "把这几周周报总结成绩效"

| 能力 | 说明 |
|------|------|
| 周报提炼 | 自动读取已归档周报，也支持手动粘贴或指定文件 |
| 经验深度分析 | 场景 + 认知 + 方法论沉淀，体现思考深度 |
| 历史绩效参考 | 读取已归档月度绩效，保持表达风格和工作连续性 |
| 不足美化 | 包装为"追求更高标准时的发现"，展示进取心 |
| 反馈闭环 | 自动记录领导反馈，下月自动生成"落实情况" |

**流程**：确定月份 → 自动读取归档周报 → 补充反馈 → 提取聚合 → 确认事项 → 改写生成 → 修订 → 归档月度绩效与反馈

## work-history-initializer — 历史数据初始化

**触发**："导入历史周报" / "初始化历史绩效数据" / "把以前写过的月度绩效导入"

| 能力 | 说明 |
|------|------|
| 历史周报导入 | 将过往 OKR 周报、双周报整理到 `~/.work-reporter/weekly-reports/` |
| 月度绩效导入 | 将过往绩效自评整理到 `~/.work-reporter/monthly-reviews/` |
| 元数据补齐 | 为历史内容补齐作者、周期、导入时间等 front matter |
| 多 OKR 导入 | 保留 `okr-2026h1`、`okr-review-2025h2` 等语义化文件名 |
| 批量初始化 | 支持粘贴内容、单文件或目录导入，冲突时默认不覆盖 |

用户配置、OKR、周报归档、月度绩效归档和绩效反馈默认保存到 `~/.work-reporter/`。插件更新或回退只替换 skill 程序文件，不会删除这些运行时数据。

## 输出示例

**周报输出**：
```
简述近期 OKR 重要进展或规划

O1-KR2：支付能力建设
- 完成三方支付渠道接入与回调联调，按期通过验收...

简述近期实质性思考和分享
- 在排查回调偶发失败时，发现网络重试机制存在竞态...
```

**绩效输出**：
```
工作回顾

（1）主要工作快报
- 完成支付模块全链路开发，接口响应时间降低 60%，支撑业务侧按时上线

（2）经验和不足
经验：
- 通过抽象统一适配层，将渠道差异屏蔽在接入层...

不足：
- 在追求更快交付节奏的过程中，发现代码审查环节还有进一步精细化的空间
```

## 安装 / 更新 / 回退

**npx skills（推荐，支持 Claude Code / Codex / Cursor 等 50+ Agent）**

```bash
# 安装所有 skills
npx skills add zhangshikang067/zhangshikang-work-plugins

# 只安装指定 skill
npx skills add zhangshikang067/zhangshikang-work-plugins --skill okr-weekly-writer

# 指定安装到 Claude Code / Codex
npx skills add zhangshikang067/zhangshikang-work-plugins -a claude-code
npx skills add zhangshikang067/zhangshikang-work-plugins -a codex
```

更新或回退版本：

```bash
# 更新已安装的 skills 到最新版本
npx skills update

# 只更新全局安装的 skills
npx skills update -g

# 安装或回退到指定 tag
npx skills add 'zhangshikang067/zhangshikang-work-plugins#v1.3.3'
npx skills add 'zhangshikang067/zhangshikang-work-plugins#1.0.0'
```

使用 `#tag` 安装会固定到对应版本；需要回到最新版本时，重新使用不带 `#tag` 的安装命令。

如果你已经使用 `v1.2.0` 生成过周报归档或配置，更新前先迁移旧数据：

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
# 直接通过 GitHub URL 安装
/install-plugin https://github.com/zhangshikang067/zhangshikang-work-plugins

# 或克隆后本地安装
git clone https://github.com/zhangshikang067/zhangshikang-work-plugins.git \
  ~/.claude/plugins/zhangshikang-work-plugins
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

## License

MIT
