# Public launch plan

## Positioning

MissionCompiler is not a prompt optimizer and not another general agent. It is the approval and verification layer between a non-technical user's goal and a coding agent.

One-line pitch:

> Say what you want. MissionCompiler turns it into a safe, approval-ready, verifiable agent task.

Chinese pitch:

> 你只说想完成什么，MissionCompiler 负责把它编译成安全、可审批、可验收的 Agent 任务。

## Truthful launch claims

Use:

- Public preview for macOS.
- Native proposal UI and deterministic policy core.
- 30 baseline policy evaluations.
- Detects local Codex CLI availability.
- Real Codex execution is the next milestone.

Do not use:

- “Automatically completes any task.”
- “Automatically chooses and installs every plugin.”
- “Production-ready.”
- “Official OpenAI product.”
- Any completed-task claim based only on the web prototype.

## Sequence

### Phase 1 — Credibility

- Publish the repository, screenshot, roadmap, architecture, and evaluation data.
- Open focused issues for App Server discovery, TaskSpec parity, and execution safety.
- Invite real task examples and failure cases before inviting code contributions.

### Phase 2 — Builder feedback

- Post a short demo to GitHub, Hacker News “Show HN”, V2EX, 即刻, and relevant agent-builder communities.
- Ask one concrete question: “Which task would you trust this to plan, but not yet execute?”
- Convert recurring answers into anonymized eval cases.

### Phase 3 — Executable milestone

- Record an end-to-end demo only after M2 passes on a clean test repository.
- Publish evidence: changed files, tests, approval boundaries, and rollback.
- Package a signed and notarized preview before asking non-technical users to install it.

## First launch post

### Chinese

我在做一个叫 MissionCompiler 的 macOS 工具：普通用户只说想完成什么，它先把任务整理成目标、权限、风险、能力、验收和回滚，再交给 Codex 执行。

这次公开的是诚实的第一步：原生方案界面、确定性安全策略和 30 个评测任务。真实 Codex 执行还没有启用，也不会把交互样机冒充成成品。

我最想知道的是：哪类任务你愿意先让它“规划并解释”，但暂时还不愿意让它自动执行？

### English

I am building MissionCompiler, a macOS approval layer for coding agents. You describe the outcome; it compiles the mission into goals, permissions, risk, capabilities, acceptance checks, and rollback before an agent is allowed to act.

This public preview includes the native proposal UI, a deterministic policy core, and 30 baseline evaluations. Real Codex execution is deliberately not enabled yet.

What task would you trust it to plan and explain today, but not yet execute automatically?

## Metrics for the first month

- Real task examples submitted.
- Policy failures reproduced as evals.
- Proposal cards users understand without opening technical details.
- M1 live-discovery completion rate.
- Zero claims that exceed the shipped capability.

Stars and traffic are secondary to evidence that users understand and trust the approval boundary.
