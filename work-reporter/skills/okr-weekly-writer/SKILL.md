---
name: okr-weekly-writer
description: 改写、润色或起草中文 OKR 周报、双周报、工作总结、述职材料和面向领导的进展汇报。可自动扫描 git commit log 生成周报，支持用户自定义 OKR 目标文件进行归类对齐。Use when the user asks to write/optimize/rewrite a weekly report, summarize weekly work, turn task lists into OKR/KR-aligned outcomes, auto-generate report from git logs, highlight work results without exaggeration, or write sections such as "简述近期OKR重要进展或规划" and "简述近期实质性思考和分享". Also use when the user says things like "帮我整理一下这周做了什么" "把最近的工作总结一下" "帮我写周报" "这周干了啥" "写个双周报" or wants to polish existing report content.
---

# OKR Weekly Report Writer

把零散的工作记录或 git commit log 改成清晰、可信、方便领导阅读的 OKR 周报。输出要让工作成果、推进进度、风险处理和后续动作一眼能看懂。

## 文件定位

`SKILL.md` 同级目录只存放随插件更新的脚本和模板。用户运行时数据必须存放到稳定数据目录，避免 `npx skills update` 重装 skill 时丢失。

定位方式：

```bash
SKILL_DIR="${CLAUDE_PLUGIN_ROOT}/skills/okr-weekly-writer"
WORK_REPORTER_HOME="${WORK_REPORTER_HOME:-$HOME/.work-reporter}"
CONFIG_DIR="$WORK_REPORTER_HOME/config"
OKR_DIR="$WORK_REPORTER_HOME/okr"
WEEKLY_OUTPUT_DIR="$WORK_REPORTER_HOME/weekly-reports"
```

首次读写用户数据前执行：

```bash
mkdir -p "$CONFIG_DIR" "$OKR_DIR" "$WEEKLY_OUTPUT_DIR"
```

`$SKILL_DIR/references/` 仅用于读取插件内置模板，如 `okr-example.md`；不要把用户配置、OKR 或周报写入 skill 安装目录。

## 工作流程

### 阶段一：加载用户配置

1. 执行 `git config user.name` 获取当前 git 用户名。
2. 执行"旧数据迁移"，把历史版本写在 `$SKILL_DIR/references/` 和 `$SKILL_DIR/outputs/` 的用户数据复制到 `$WORK_REPORTER_HOME`。
3. 检查 `$CONFIG_DIR/{用户名}-config.md` 是否存在。
   - **存在** → 读取 `repo_root` 和 `author`，跳过配置。
   - **不存在** → 首次配置：通过交互询问代码仓库根目录路径。`author` 优先使用 `git config user.name`，检测失败则询问。配置完成后写入文件持久保存。

### 阶段二：交互式采集参数

如果用户消息中已包含明确参数（如"扫描 operate 项目，上周的"），直接使用，跳过交互。

否则根据当前状态弹出 `AskUserQuestion`。核心原则：**老用户一步到位，新用户逐步引导**。

**场景 A：老用户（有 config + 有 OKR）** — 一次弹出 4 个问题：

| 问题 | header | 选项 |
|------|--------|------|
| 选择日期范围？ | 日期范围 | 近 14 天 / 本周 / 上周 |
| 选择项目范围？（仓库：{repo_root}） | 项目范围 | 扫描全部 / Other 输入项目名 |
| 检测到你的 OKR「{用户名}-okr.md」，包含：{O1:..., O2:...}，是否使用？ | OKR | 使用 / 更新（Other 输入新内容覆盖）/ 跳过 |
| 是否有补充工作内容？ | 补充 | 无补充 / 有补充（Other 输入） |

**场景 B：新用户（无 config 或无 OKR）** — 缺什么问什么，合并到一次交互中：
- 缺 config → 加入"请输入代码仓库根目录路径"（Other 输入）
- 缺 OKR → 加入"是否提供 OKR？"（提供文件路径 / 直接粘贴 / 跳过）
- 始终包含：日期范围、项目范围、补充说明

**手动模式**：如果用户说"手动模式"、"不扫 git"、"我直接说"，跳过阶段三的 git 扫描，直接进入阶段五让用户提供工作内容。在交互中也可以加入"跳过 git 扫描，直接输入内容"选项。

### 阶段三：扫描 git log

执行 `$SKILL_DIR/scripts/scan-commits.sh`，传入从配置和交互中收集的参数：

```bash
bash "$SKILL_DIR/scripts/scan-commits.sh" "$REPO_ROOT" "$AUTHOR" "$SINCE" "$UNTIL" $PROJECTS
```

脚本输出的 `=== 项目名 ===` 标注仅用于中间过程的事项归组，最终周报中不出现。

**日期解析规则**：
- "近 14 天" → `--since="14 days ago"`
- "本周" → 本周一 ~ 明天
- "上周" → 上周一 ~ 上周五
- "Other" → 支持 `YYYY-MM-DD` 格式或自然语言描述

如果扫描结果为空，提示用户检查配置，不要直接生成空周报。

### 阶段四：过滤与聚合

**过滤**掉低信息量提交：

| 过滤模式 | 示例 |
|----------|------|
| 单词无内容 | `stash`、`doc`、`version` |
| 纯版本号 | `1.0.1`、`v2.3` |
| 空泛动词 | `修改`、`更新`、`调整`（后无具体内容） |

保留所有有实质工作描述的 commit。

**聚合**同一项目中主题相关的 commit 为一条工作事项：

```
# 原始
c4129222 支付渠道接入
2f7e08ce 调试支付回调

# 合并后
支付渠道接入：完成对接与回调联调
```

### 阶段五：确认事项

过滤聚合完成后，**先展示事项清单让用户确认**：

```markdown
## 采集到以下工作事项

**项目A**
- 事项1：...
- 事项2：...

---
如有遗漏或需要补充，请告诉我。确认无误后我开始改写。
```

通过 `AskUserQuestion` 询问：

| 问题 | header | 选项 |
|------|--------|------|
| 以上是采集到的工作事项，是否有遗漏或需要调整？ | 确认事项 | 确认开始改写 / 需要补充（Other） / 需要删减（Other） |

用户确认后才进入改写。这是两步流程的关键——避免改写完发现遗漏重要工作。

### 阶段六：改写生成周报

有 OKR 文件时，根据归类建议将事项映射到对应 KR。没有 OKR 时按项目/模块分组。

### 阶段七：输出与最终确认

按"推荐输出结构"生成最终周报。输出中不出现项目名/仓库名等内部来源标注。

输出后通过 `AskUserQuestion` 询问用户是否还需要调整：

| 问题 | header | 选项 |
|------|--------|------|
| 这版周报是否确认归档？ | 最终确认 | 确认并归档 / 需要调整（Other） |

用户要求调整时，按反馈修订后再次确认。只有用户确认最终版本后，才进入归档。

### 阶段八：归档最终周报

用户确认最终周报后，保存到 `$WEEKLY_OUTPUT_DIR`。只保存最终确认版本，不保存 git log 原始扫描结果或中间事项清单。

保存前执行：

```bash
mkdir -p "$WEEKLY_OUTPUT_DIR"
```

**文件名规则**：

- 单周：`YYYY年第WW周 MM-DD至MM-DD 周报.md`
  - 示例：`2026年第24周 06-10至06-16 周报.md`
- 双周或跨周：`YYYY年第WW-WW周 MM-DD至MM-DD 周报.md`
  - 示例：`2026年第24-25周 06-10至06-23 周报.md`

周次以用户选择的周期语义为准：

- 用户选择"本周"、"上周"等单周周期时，使用单周格式。
- 用户选择"双周"、"近 14 天"或自定义跨周范围时，使用起止周范围格式。
- `YYYY` 取周期开始日期所在年份，`WW` 使用 ISO 周序号。

作者、完整起止日期、生成时间等信息不放进文件名，写入 front matter：

```markdown
---
type: weekly-report
author: 张三
period_start: 2026-06-10
period_end: 2026-06-23
period_label: 2026年第24-25周 06-10至06-23
created_at: 2026-06-17T20:30:00+08:00
---

最终周报正文...
```

如果目标文件已存在，通过 `AskUserQuestion` 询问：

| 问题 | header | 选项 |
|------|--------|------|
| 已存在同名周报，如何处理？ | 文件冲突 | 覆盖旧版本 / 另存为 `-v2` / 放弃保存 |

选择另存时，如果 `-v2` 也存在，依次尝试 `-v3`、`-v4`，直到找到未占用文件名。

---

## 配置、OKR 与周报持久化

### 用户配置

保存在 `$CONFIG_DIR/{git用户名}-config.md`，格式：

```markdown
# 用户配置

## repo_root
/home/user/code

## author
张三
```

首次使用时交互采集并写入。用户说"更换仓库路径"时可触发重新配置。

### OKR 文件

保存在 `$OKR_DIR/{git用户名}-okr.md`，按用户名隔离，多人共用 skill 各自独立。

首次提供时交互采集并写入（支持提供文件路径 / 直接粘贴 / 跳过）。后续使用时在阶段二中确认。

OKR 文件格式参考 `$SKILL_DIR/references/okr-example.md`。用户提供的 OKR 不需要严格遵循模板——只要包含 O 和 KR 的信息就能用于归类。

### 周报归档

保存在 `$WEEKLY_OUTPUT_DIR`，用于后续 `monthly-performance-writer` 自动读取本月周报材料。归档内容必须是用户确认后的最终周报正文。

### 旧数据迁移

历史版本曾把用户数据写入 skill 安装目录。每次运行时先检查并复制旧数据：

```bash
mkdir -p "$CONFIG_DIR" "$OKR_DIR" "$WEEKLY_OUTPUT_DIR"

for file in "$SKILL_DIR"/references/*-config.md; do
  [ -e "$file" ] || continue
  target="$CONFIG_DIR/$(basename "$file")"
  [ -e "$target" ] || cp "$file" "$target"
done

for file in "$SKILL_DIR"/references/*-okr.md; do
  [ -e "$file" ] || continue
  target="$OKR_DIR/$(basename "$file")"
  [ -e "$target" ] || cp "$file" "$target"
done

if [ -d "$SKILL_DIR/outputs" ]; then
  for file in "$SKILL_DIR"/outputs/*.md; do
    [ -e "$file" ] || continue
    target="$WEEKLY_OUTPUT_DIR/$(basename "$file")"
    [ -e "$target" ] || cp "$file" "$target"
  done
fi
```

迁移只复制不存在的文件，不覆盖 `$WORK_REPORTER_HOME` 中已有数据。

---

## 改写规则

每个事项按此结构改写：

```text
原始事项：做了什么
优化表达：围绕【目标/场景】，完成【动作/交付物】，解决/保障/推动【结果】，当前【状态/风险/后续】。
```

常用动词：推进、完成、支持、保障、打通、梳理、排查、修复、验证、沉淀、优化、闭环

只有用户确实是辅助角色时才用"配合"，其他情况优先用"支持完成""协助推进""完成验证""保障上线"等。

常用结果词：稳定性、准确性、可用性、兼容性、时效、效率、转化、体验、上线质量、风险前置、问题闭环

常用阻塞表达：
- "因 X 暂不具备条件，已先完成 Y，后续待 Z 后继续验证闭环。"
- "当前主要风险在于 X，已通过 Y 方式前置处理，后续重点跟进 Z。"

## 好周报的特点

优先体现：
- **对齐 OKR**（如果有 OKR 文件）：清晰标签如 `O1-KR4：AI 测评`
- **结果前置**：写"完成开发与调试，支持能力落地"，不只写"做了开发"
- **能量化就量化**：数量、比例、金额、完成状态、日期、覆盖范围
- **风险可见**：写清阻塞和处理方式
- **后续动作明确**：写具体跟进动作，不写空泛表态

避免：
- 只列任务不写结果
- 每条都用"配合"开头，显得被动
- 没有依据地写"大幅提升""显著优化"
- 隐藏阻塞——写清应对方式比假装完成更可信

## 推荐输出结构

```markdown
**简述近期 OKR 重要进展或规划**

本周 OKR 重点推进工作如下：

**O1-KR2：xxx**

- ...

**O1-KR4：xxx**

- ...

**简述近期实质性思考和分享**

本周在 ... 过程中，进一步感受到 ...

后续会 ...

同时也意识到 ...
```

没有 OKR 文件时，KR 标题替换为项目/模块名。用户公司模板不同时沿用用户的标题。

## 思考与分享写法

建议回答 2-4 个问题：

- 本周哪类工作最难、风险最高？
- 做了什么判断或取舍？
- 从重复问题中总结出了什么规律？
- 哪些依赖还需要继续跟进？
- 在哪些能力上有进步：问题定位、风险识别、跨团队沟通、交付质量、数据意识？

思考要具体，根据用户实际工作内容生成，不要套用固定模板。

## 最终检查清单

- 领导能在 1 分钟内看懂重点
- 每个 KR（或项目组）都有明确进展或当前状态
- 重要工作没有被平淡措辞削弱
- 没有编造数据
- 阻塞问题写了应对方式或下一步
- 思考部分体现判断，不只是态度
- 整体语气专业、真实、克制
