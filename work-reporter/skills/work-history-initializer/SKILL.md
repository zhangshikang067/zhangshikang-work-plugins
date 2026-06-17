---
name: work-history-initializer
description: 初始化和导入 work-reporter 历史数据，包括历史 OKR 周报、双周报、月度绩效自评、领导反馈、OKR 文件和用户配置。Use when the user asks to import, initialize, migrate, backfill, or organize historical weekly reports, OKR reports, monthly performance reviews, manager feedback, or work-reporter data.
---

# Work Reporter History Initializer

把用户过去写过的 OKR 周报、双周报、月度绩效自评、领导反馈、OKR 文件整理进 work-reporter 的稳定数据目录。导入只做归档和元数据补齐，不改写用户原文。

## 文件定位

用户运行时数据必须存放到稳定数据目录，避免 `npx skills update` 重装 skill 时丢失。

```bash
WORK_REPORTER_HOME="${WORK_REPORTER_HOME:-$HOME/.work-reporter}"
CONFIG_DIR="$WORK_REPORTER_HOME/config"
OKR_DIR="$WORK_REPORTER_HOME/okr"
WEEKLY_OUTPUT_DIR="$WORK_REPORTER_HOME/weekly-reports"
MONTHLY_REVIEW_DIR="$WORK_REPORTER_HOME/monthly-reviews"
FEEDBACK_DIR="$WORK_REPORTER_HOME/feedback"
```

导入前执行：

```bash
mkdir -p "$CONFIG_DIR" "$OKR_DIR" "$WEEKLY_OUTPUT_DIR" "$MONTHLY_REVIEW_DIR" "$FEEDBACK_DIR"
```

## 支持的来源

- 用户粘贴的历史内容
- 单个本地文件路径，如 `.md`、`.txt`
- 一个包含多份历史材料的目录

不要删除、移动或改写用户原始文件。导入时复制到 `$WORK_REPORTER_HOME`。

## 工作流程

### 步骤一：确认导入来源和类型

如果用户已经提供路径或内容，直接使用。否则通过 `AskUserQuestion` 询问：

| 缺失项 | 问题 | header | 选项 |
|--------|------|--------|------|
| 导入来源 | 要导入哪些历史材料？ | 来源 | 粘贴内容（Other）/ 提供文件路径（Other）/ 提供目录路径（Other） |
| 数据类型 | 这些材料主要是什么类型？ | 类型 | 自动识别 / 历史周报 / 月度绩效 |

执行 `git config user.name` 获取作者名；失败时询问用户姓名。

### 步骤二：扫描和分类

对文件或目录中的 `.md`、`.txt` 文件进行分类：

| 类型 | 识别线索 | 目标目录 |
|------|----------|----------|
| 周报 / 双周报 | 文件名或正文包含 `周报`、`OKR`、`简述近期 OKR`、`本周`、`双周` | `$WEEKLY_OUTPUT_DIR` |
| 月度绩效 | 文件名或正文包含 `月度绩效`、`绩效自评`、`工作回顾`、`经验和不足` | `$MONTHLY_REVIEW_DIR` |
| 领导反馈 | 文件名或正文包含 `领导反馈`、`绩效提升建议`、`改进建议` | `$FEEDBACK_DIR` |
| OKR 文件 | 文件名或正文包含 `OKR`、`Objective`、`KR`，且不是周报正文 | `$OKR_DIR` |

分类不确定时，展示候选列表让用户确认，不要猜测导入。

### 步骤三：补齐时间元数据

优先从已有 front matter 读取元数据。缺失时按以下顺序推断：

1. 从文件名解析日期或月份。
2. 从正文标题或正文日期解析。
3. 仍无法确定时询问用户。

周报必须补齐：

- `period_start`
- `period_end`
- `period_label`

月度绩效必须补齐：

- `month`，格式 `YYYY-MM`
- `period_start`
- `period_end`

### 步骤四：规范文件名

周报文件名：

- 单周：`YYYY年第WW周 MM-DD至MM-DD 周报.md`
- 双周或跨周：`YYYY年第WW-WW周 MM-DD至MM-DD 周报.md`

月度绩效文件名：

- `YYYY年MM月 月度绩效.md`

领导反馈文件名：

- `{用户名}-manager-feedback.md`

OKR 文件名：

- `{用户名}-okr.md`

如目标文件已存在，通过 `AskUserQuestion` 询问：

| 问题 | header | 选项 |
|------|--------|------|
| 已存在同名历史数据，如何处理？ | 文件冲突 | 跳过 / 另存为 `-v2` / 覆盖 |

批量导入时，默认推荐"跳过"，避免覆盖已归档数据。

### 步骤五：写入归档文件

周报导入格式：

```markdown
---
type: weekly-report
author: 张三
period_start: 2026-06-10
period_end: 2026-06-16
period_label: 2026年第24周 06-10至06-16
source: imported
imported_at: 2026-06-17T20:30:00+08:00
---

历史周报原文...
```

月度绩效导入格式：

```markdown
---
type: monthly-performance-review
author: 张三
month: 2026-06
period_start: 2026-06-01
period_end: 2026-06-30
source: imported
imported_at: 2026-06-17T20:30:00+08:00
---

历史月度绩效原文...
```

如果原文已有 front matter，保留已有字段，只补齐缺失字段。正文不改写。

### 步骤六：输出导入结果

导入完成后展示清单：

```markdown
## 历史数据初始化完成

- 周报：3 份 -> ~/.work-reporter/weekly-reports/
- 月度绩效：2 份 -> ~/.work-reporter/monthly-reviews/
- OKR：1 份 -> ~/.work-reporter/okr/
- 领导反馈：1 份 -> ~/.work-reporter/feedback/

跳过：1 份（同名文件已存在）
需要人工确认：0 份
```

如果有未导入文件，说明原因和下一步需要用户补充的信息。

## 质量要求

- 不改写历史正文。
- 不删除用户原始文件。
- 不把用户数据写入 skill 安装目录。
- 不覆盖已有归档，除非用户明确选择覆盖。
- 无法确定日期或类型时必须询问用户。
