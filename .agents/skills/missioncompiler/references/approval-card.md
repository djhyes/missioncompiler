# Approval card

Present one concise card in the user's language.

```markdown
## MissionCompiler 执行方案

状态：待批准 / 只读可继续 / 已阻塞

### 目标与交付物
<what will be true when done>

### 我会保护
- <user work and behavior that will not change>

### 推荐执行方式
- 方式：Direct / Plan
- 工作区：只读 / 当前工作区 / 独立 worktree / 快照 / 仅外部操作
- 模型：<tier and currently resolved model, or advisory tier>
- 验证：<tests, visual check, reviewer>

### 能力
- <existing capability and reason>
- <missing capability, source/version/permissions, or “无需新增能力”>

### 将要访问或修改
- 读取：<scope>
- 写入：<scope or none>
- 网络：<domains/services or none>
- 外部动作：<actions or none>

### 风险与审批
- <green/yellow/red/blocked and why>
- <which approval applies now and which actions still need later approval>

### 验收条件
1. <criterion → verification>

### 停止与回滚
- 停止：<conditions>
- 回滚：<strategy>

请选择：按此方案执行 / 修改方案 / 取消
```

Rules:

- Lead with outcome and impact, not Agent vocabulary.
- Give no more than three direct reasons for a recommendation.
- If blocked, replace the execution choice with the concrete resolution needed.
- Do not imply that proposal approval covers a later red external action.
- Do not claim a model, permission, capability, or worktree is active until it is actually observed or created.
