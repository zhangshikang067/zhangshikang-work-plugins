---
name: monthly-performance-writer
description: 改写、润色或起草中文月度绩效自评、绩效面谈材料。用户提供每周周报内容，skill 自动提取总结成月度绩效，经验深度分析，不足巧妙美化，帮你拿到好绩效。Use when the user asks to write/optimize/rewrite a monthly performance review, self-evaluation, or wants to summarize weekly reports into monthly performance format. Also use when the user says things like "帮我写月度绩效" "写个月度自评" "绩效自评怎么写" "把这几周周报总结成月度绩效" "帮我整理下月度绩效" or wants to polish existing performance review content.
---

# Monthly Performance Writer

把每周周报内容提取、聚合、升华成月度绩效自评。经验要写出深度和成长感，不足要包装成积极进取的姿态。目标是让领导看到你的产出和潜力。

## 文件定位

`SKILL.md` 同级目录只存放随插件更新的写法模板。用户运行时数据必须存放到稳定数据目录，避免 `npx skills update` 重装 skill 时丢失。

定位方式：

```bash
SKILL_DIR="${CLAUDE_PLUGIN_ROOT}/skills/monthly-performance-writer"
WORK_REPORTER_HOME="${WORK_REPORTER_HOME:-$HOME/.work-reporter}"
WEEKLY_OUTPUT_DIR="$WORK_REPORTER_HOME/weekly-reports"
FEEDBACK_DIR="$WORK_REPORTER_HOME/feedback"
```

首次读写用户数据前执行：

```bash
mkdir -p "$WEEKLY_OUTPUT_DIR" "$FEEDBACK_DIR"
```

在后续 Read/Write 操作中，将 `$SKILL_DIR` 和 `$WORK_REPORTER_HOME` 替换为实际解析出的路径。

改写时读取 `$SKILL_DIR/references/writing-guide.md` 获取详细的写法模板和完整示例。

## 工作流程

### 步骤一：初始化（确定月份与材料来源）

如果用户消息中已包含周报内容或周报文件路径，优先使用用户提供的材料，不强制读取历史归档。

执行"旧数据迁移"，把历史版本写在 skill 安装目录中的周报归档、领导反馈和 AI 建议复制到 `$WORK_REPORTER_HOME`。

先确定绩效月份。用户消息中已给出月份时直接使用；否则通过 `AskUserQuestion` 询问。月份默认取上月（如当前 5 月，默认写 4 月绩效）。

领导反馈如果用户已提供则直接使用；未提供时可在同一次交互中询问，允许跳过。

| 缺失项 | 问题 | header | 选项 |
|--------|------|--------|------|
| 月份 | 绩效对应的月份？ | 月份 | 本月 / 上月 / Other 输入 |
| 领导反馈 | 上级面谈反馈的改进建议？（没有可跳过） | 领导反馈 | 有，粘贴反馈内容（Other 输入）/ 没有反馈，跳过 |

只展示确实缺失的问题。

### 步骤二：自动读取周报归档

如果步骤一没有获得用户直接提供的周报材料，则从 `$WEEKLY_OUTPUT_DIR` 自动查找目标月份内的周报归档。

筛选规则：

1. 读取 `$WEEKLY_OUTPUT_DIR/*.md`。
2. 优先解析 front matter 中的 `period_start` 和 `period_end`。
3. 选择与目标月份有日期重叠的周报；例如目标月份为 2026-06，`period_start <= 2026-06-30` 且 `period_end >= 2026-06-01`。
4. 对缺少 front matter 的旧文件，尝试从文件名 `YYYY年第...周 MM-DD至MM-DD 周报.md` 解析日期范围。
5. 按 `period_start` 升序排列。

找到周报后，展示文件列表和简短摘要，让用户确认：

```markdown
## 已找到以下本月周报归档

1. `2026年第24周 06-10至06-16 周报.md`（2026-06-10 ~ 2026-06-16）
2. `2026年第24-25周 06-10至06-23 周报.md`（2026-06-10 ~ 2026-06-23）

将使用以上周报作为月度绩效材料。如有缺失，可以补充。
```

通过 `AskUserQuestion` 询问：

| 问题 | header | 选项 |
|------|--------|------|
| 是否使用这些周报生成月度绩效？ | 周报材料 | 使用这些周报 / 使用并补充（Other） / 不使用，重新提供（Other） |

如果未找到归档周报，或用户选择重新提供，再通过 `AskUserQuestion` 补齐周报内容：

| 缺失项 | 问题 | header | 选项 |
|--------|------|--------|------|
| 周报内容 | 请提供本月周报内容（粘贴、文件路径或口述） | 周报内容 | 直接粘贴（Other 输入）/ 提供文件路径（Other 输入）/ 口头描述（Other 输入） |

历史周报缺周时，明确提示用户补充，不要根据缺失周报静默编造。

### 步骤三：加载持久化数据

1. 执行 `git config user.name` 获取用户名。
2. 读取 `$FEEDBACK_DIR/{用户名}-manager-feedback.md`（如存在），获取历史领导反馈。
3. 如果文件不存在且用户也未提供反馈，"落实情况"部分跳过不写。

### 步骤四：提取与聚合

从周报中提取工作内容：

- **提取**：从每周周报中提取所有工作事项，去重合并
- **聚合**：将同一主题/项目的工作合并为一条，按重要性和影响力排序

```text
# 原始（第1周周报）
- 完成支付模块接口开发
- 修复支付回调偶发失败问题

# 原始（第3周周报）
- 支付模块性能优化，响应时间降低 40%

# 合并后
- 支付模块：完成接口开发与回调问题修复，并通过性能优化将响应时间降低 40%
```

### 步骤五：确认事项

展示提取结果让用户确认：

```markdown
## 本月提取到以下工作事项

**主要工作**
1. ...
2. ...

**可提炼的经验**
- ...

**领导反馈的改进建议（{数量}条）**
1. ...

---
如有遗漏或需要补充，请告诉我。确认后我开始改写。
```

通过 `AskUserQuestion` 询问确认。

### 步骤六：改写生成月度绩效

确认后按"输出结构"和 `writing-guide.md` 中的写法模板生成最终内容。

### 步骤七：用户修订

输出后询问用户是否需要调整。用户可能要求：
- 某部分再展开或精简
- 调整语气或措辞
- 补充或修改内容

反复修订直到用户满意，再进入步骤八。

### 步骤八：持久化

用户确认最终版本后，执行两件事：

**1. 更新领导反馈记录**

追加到 `$FEEDBACK_DIR/{用户名}-manager-feedback.md`：

```markdown
## {月份} 领导反馈

1. 建议内容...
2. 建议内容...
```

**2. 生成 AI 下月建议**

基于本月工作内容生成 2-3 条下月改进建议，保存到 `$FEEDBACK_DIR/{用户名}-ai-improvement-suggestions.md`，并在对话中展示：

```markdown
---
**下月改进建议（AI 生成，供参考）**

1. ...
2. ...

已保存，仅供参考，不影响绩效正文。
```

---

## 核心改写规则

详细写法模板和完整示例见 `$SKILL_DIR/references/writing-guide.md`，改写时务必读取并遵循。

### 主要工作快报

升华结构：围绕【目标/场景】，完成【动作/交付物】，达成【结果/影响】，为【后续】奠定基础。

- 结果前置，能量化就量化
- 体现业务价值，按重要性排序
- 跨周重复工作合并，体现持续推进

### 经验（深度分析）

写法框架：场景 + 认知 + 方法论沉淀。从具体工作提炼，体现思考深度，展示可复用的方法论。

### 不足（积极美化）

核心策略：把"不足"包装为"追求更高标准时的发现"。每条不足必须包含：场景背景 + 改进方向 + 已有行动。让领导感受到进取心和自我驱动力。

### 落实情况

用本月实际工作事项逐条回应上月领导反馈的建议。落实情况中提到的每项工作，必须能在"主要工作快报"中找到对应依据，不能凭空编造。

---

## 输出结构

```markdown
**工作回顾**
内容可以包括：

（1）主要工作快报

- ...
- ...

（2）经验和不足

经验：
- ...

不足：
- ...

**上月绩效提升建议的落实情况**

1. ...
2. ...
```

如果用户公司模板不同，沿用用户的标题和格式。

---

## 持久化文件

| 文件 | 内容 | 来源 |
|------|------|------|
| `$WORK_REPORTER_HOME/weekly-reports/*.md` | 已归档周报 | `okr-weekly-writer` 用户确认后自动保存，月度绩效默认读取 |
| `$WORK_REPORTER_HOME/feedback/{用户名}-manager-feedback.md` | 领导面谈反馈 | 用户提供，下月自动加载用于"落实情况" |
| `$WORK_REPORTER_HOME/feedback/{用户名}-ai-improvement-suggestions.md` | AI 生成的下月建议 | 基于本月工作自动生成，仅供参考 |

### 旧数据迁移

历史版本曾把用户数据写入 skill 安装目录。每次运行时先检查并复制旧数据：

```bash
mkdir -p "$WEEKLY_OUTPUT_DIR" "$FEEDBACK_DIR"

OLD_WEEKLY_OUTPUT_DIR="$(dirname "$SKILL_DIR")/okr-weekly-writer/outputs"
if [ -d "$OLD_WEEKLY_OUTPUT_DIR" ]; then
  for file in "$OLD_WEEKLY_OUTPUT_DIR"/*.md; do
    [ -e "$file" ] || continue
    target="$WEEKLY_OUTPUT_DIR/$(basename "$file")"
    [ -e "$target" ] || cp "$file" "$target"
  done
fi

for file in "$SKILL_DIR"/references/*-manager-feedback.md "$SKILL_DIR"/references/*-ai-improvement-suggestions.md; do
  [ -e "$file" ] || continue
  target="$FEEDBACK_DIR/$(basename "$file")"
  [ -e "$target" ] || cp "$file" "$target"
done
```

迁移只复制不存在的文件，不覆盖 `$WORK_REPORTER_HOME` 中已有数据。

---

## 检查清单

- 主要工作快报覆盖了本月核心产出，内容丰富
- 经验部分有深度分析，体现思考和方法论沉淀
- 不足部分包装积极，让领导感受到进取心和自我驱动力
- 落实情况每条有明确状态，未完成的写清后续计划
- 整体内容量充实，不单薄
- 没有编造不存在的工作或数据
- 语气自信但不夸张，专业且真实
