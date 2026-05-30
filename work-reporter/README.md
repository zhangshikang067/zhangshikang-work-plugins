# work-reporter

> 工作汇报写作助手 — 一个插件搞定周报和绩效

两个 skill 各司其职：周报从 git log 自动生成，绩效从周报自动提炼。

## okr-weekly-writer — OKR 周报

**触发**："帮我写周报" / "这周干了啥" / "写个双周报"

| 能力 | 说明 |
|------|------|
| git log 扫描 | 自动扫描多项目、多日期范围的 commit 记录 |
| OKR 对齐 | 按用户 OKR 文件自动归类到对应 KR |
| 手动模式 | 不扫 git，直接口述或粘贴工作内容 |
| 配置持久化 | 首次配置后，老用户一步到位 |

**流程**：加载配置 → 交互采集参数（日期/项目/OKR）→ 扫描 git log → 过滤聚合 → 确认事项 → 改写生成

## monthly-performance-writer — 月度绩效

**触发**："帮我写月度绩效" / "写个月度自评" / "把这几周周报总结成绩效"

| 能力 | 说明 |
|------|------|
| 周报提炼 | 从多周周报中提取、去重、聚合工作事项 |
| 经验深度分析 | 场景 + 认知 + 方法论沉淀，体现思考深度 |
| 不足美化 | 包装为"追求更高标准时的发现"，展示进取心 |
| 反馈闭环 | 自动记录领导反馈，下月自动生成"落实情况" |

**流程**：收集周报/月份/反馈 → 提取聚合 → 确认事项 → 改写生成 → 修订 → 持久化反馈记录

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

## 安装

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

**Claude Code**

```bash
# 直接通过 GitHub URL 安装
/install-plugin https://github.com/zhangshikang067/zhangshikang-work-plugins

# 或克隆后本地安装
git clone https://github.com/zhangshikang067/zhangshikang-work-plugins.git \
  ~/.claude/plugins/zhangshikang-work-plugins
/install-plugin ~/.claude/plugins/zhangshikang-work-plugins
```

## License

MIT
