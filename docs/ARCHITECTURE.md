# Architecture

MissionCompiler separates probabilistic understanding from enforceable policy.

## Current public preview

```text
Raw mission
  → TaskDraft
  → conservative ProposalCompiler
  → collapsible approval card

Normalized facts
  → Python deterministic policy engine
  → mode / risk / model tier / workspace / approval / stop conditions
```

The native macOS app currently detects whether the local Codex CLI is available and generates a conservative preview proposal. It does not start App Server or execute a task.

## Target architecture

```text
Mission input
  → Read-only environment scanner
  → Normalizer
  → TaskSpec
  → Deterministic policy engine
  → Capability resolver and trust gate
  → Approval card
  → Engine adapter
  → Bounded execution
  → Verification and independent review
  → Evidence report and rollback
```

### Environment scanner

Collects time-stamped facts about the repository, Git state, project instructions, build and test paths, available models, Skills, plugins, MCP servers, authentication health, and effective permission profiles. Unknown values remain unknown.

### Normalizer

Uses a model to convert the raw mission plus observed facts into the TaskSpec schema. It cannot redefine policy meanings or grant permissions.

### Deterministic policy engine

Computes risk, Plan or Direct mode, model tier, reasoning effort, workspace strategy, reviewer requirements, approval timing, and stop conditions. The Python implementation is the current reference core.

### Capability resolver

Prefers an already available trusted capability. Installation is considered only when required, source and version are verifiable, permissions are minimal, removal is known, and the user approves the exact candidate.

### Engine adapter

Codex is the first target. The deep desktop integration will use Codex App Server for authentication, history, approvals, and streamed events. CI or unattended jobs should use the Codex SDK instead. Adapter interfaces must keep future engines possible without weakening the shared policy layer.

### Verifier

Determines completion from TaskSpec acceptance criteria, project checks, visual evidence where relevant, and an independent review. A task cannot mark itself complete solely from model text.

## Trust boundaries

- Source code and credentials stay local by default.
- The preview never changes global Codex configuration.
- A proposal approval has a scope and expires when material facts drift.
- Publishing, sending, payments, real orders, destructive remote changes, and production writes require immediate approval at the action boundary.
- Unknown capability provenance fails closed.

## Current implementation map

| Area | Path |
| --- | --- |
| Swift proposal models and compiler | `Sources/MissionCompilerCore/` |
| Native macOS UI | `Sources/MissionCompilerApp/` |
| Python reference policy | `src/missioncompiler/decision_engine.py` |
| TaskSpec schema | `schemas/task-spec.schema.json` |
| Policy evaluations | `evals/tasks.json` |
| Project-level Skill POC | `.agents/skills/missioncompiler/` |
