---
name: missioncompiler
description: Compile a raw software task into an approval-ready Codex execution contract by inspecting the workspace read-only, choosing mode/model tier/capabilities/permissions, and defining verification and rollback. Use when the user explicitly asks for MissionCompiler, task optimization, or a safe plan before execution; do not use for ordinary explanations that do not request execution planning.
---

# MissionCompiler

Turn a user's goal into a safe, reviewable, verifiable execution contract, then carry it out only within the approved scope.

## Choose the phase

- **Compile phase:** Use by default. No current, specific TaskSpec has been approved.
- **Execute phase:** Use only when the user clearly approves the current proposal in this conversation and relevant environment facts have not drifted.
- **Recompile:** Return to Compile when the goal, files, permissions, capabilities, environment, or external actions change.

Approval of a proposal never pre-approves red external actions. Sending, publishing, production changes, payment, real orders, destructive remote changes, and regulatory submissions require approval immediately before each action.

## Compile phase

Remain read-only.

1. Preserve the raw request, explicit constraints, and prohibited actions.
2. Inspect facts that are available from the workspace instead of asking the user:
   - project root, Git state, branch, and uncommitted changes;
   - `AGENTS.md`, README, relevant docs, scripts, and project conventions;
   - tech stack plus test, lint, build, and visual-verification paths;
   - current Skills, plugins, MCP/tools, auth state, and permission boundaries when exposed by the host;
   - model and reasoning choices from the current host catalog when exposed.
3. Ask only for a material choice that cannot be discovered and would change the result or risk. Keep it narrow.
4. Compile normalized facts and apply [the decision policy](references/decision-policy.md). Recommend a model **tier**, then map it to a currently available model; never invent availability or silently substitute a model.
5. Resolve capabilities in this order: available trusted capability, installed capability, trusted fixed-version candidate, task-local method, ordinary execution without a new capability. A capability is optional unless it is genuinely required for access or materially changes success.
6. If a capability is missing, show purpose, publisher/source, version, permissions, and removal path. Mark unverifiable or unknown sources blocked. Do not install during Compile.
7. Define concrete deliverables, required acceptance checks, stop conditions, and rollback before recommending execution.
8. Present [the approval card](references/approval-card.md), then stop. Do not edit files, install capabilities, change config, create branches/worktrees, or perform external actions in the same turn.

Use [TaskSpec semantics](references/task-spec.md) when producing technical details. Keep raw JSON collapsed or omitted unless the user asks for it; the ordinary card should remain understandable without Agent terminology.

## Execute phase

1. Refresh Git state, relevant files, capability availability, and permission facts. Recompile if any approved assumption changed.
2. Protect user work. Never clean, overwrite, discard, auto-commit, or move pre-existing changes. Use the approved isolated worktree or snapshot strategy.
3. Install only capabilities explicitly included in the approved card, from the approved source and version. Verify installation health before use. Do not install an untrusted candidate even if the general proposal was approved.
4. Perform only the approved steps and mutations. Pause before every red external action for immediate approval.
5. Run the specified checks. Use a bounded repair loop; after two unsuccessful repair cycles for the same failure, stop and report the blocker unless the approved TaskSpec defines a different bound.
6. Review against the acceptance criteria, prohibited actions, and changed scope—not only code style.
7. Report completed changes, verification evidence, unmet criteria, remaining risk, and the exact rollback path. Do not claim completion while any required criterion is unverified.

## Invariants

- Facts are observed, user-stated, or explicitly marked uncertain; never present inference as a scan result.
- A model's confidence cannot override a user constraint, approval boundary, admin policy, or stop condition.
- Prefer no new capability when existing tools can complete the task safely.
- Never expose secret values. Check whether credentials exist or authentication is healthy without printing credentials.
- If the current host cannot enforce a recommended setting, say that it is advisory instead of claiming it was applied.
- Unknown scope, stale approval, or trust failure fails closed.
