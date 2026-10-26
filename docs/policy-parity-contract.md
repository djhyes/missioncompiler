# Issue #2: cross-language policy parity contract

This branch starts a non-executing parity contract. The public Swift ProposalCompiler.compile(TaskDraft) remains conservative and unchanged.

## Fixture contract v1

Source: `evals/tasks.json` (30 existing cases). Each entry has `id`, `facts`, and `expected`. Both languages MUST load the same file; never maintain independent copies.

Required facts: `task_type`, `clarity`. Optional non-negative integers: `estimated_files`, `estimated_modules`. Optional string arrays: `risk_tags`, `external_actions`. Optional booleans: `modifies_files`, `git_repo`, `dirty_worktree`, `requires_network`, `requires_capability_install`, `needs_visual_check`, `difficult_to_rollback`, `conflicts_with_constraint`, `untrusted_capability`.

Expected decision fields: `mode`, `risk_level`, `model_tier`, `reasoning_effort`, `workspace_strategy`, `reviewer`, `approval_timing`, `execution_disposition`, `plan_score`, `permissions`, `stop_conditions`. The existing 30 expectations only assert the first eight; add the final three as separately reviewed golden values. Do not regenerate golden values silently during CI.

## API boundary

Introduce a standalone `PolicyFacts: Codable, Sendable` validated value type and `PolicyDecision: Codable, Equatable, Sendable` with the eleven fields above. `PolicyEvaluator.decide(facts: PolicyFacts) throws -> PolicyDecision` must be deterministic, side-effect free, and match `decision_engine.decide`. Do NOT overload the public preview `compile(_ draft: TaskDraft)` with an implicitly executing dynamic policy. Add an explicit internal preview/test seam only if needed, preserving its Plan/Yellow/Medium behavior.

Do not infer structured facts from prompt keywords. Reject malformed types, unsupported task types, invalid clarity, and negative/bool-as-integer counts. Deduplicate risk tags and external actions; sort external permission names lexicographically. Block on constraint conflict OR untrusted capability, regardless of approval status. Red risk requires per-action approval unless blocked. A recommendation never grants execution permissions.

## CI acceptance

1. Python: run `python -m unittest discover -s tests` and compare all fixture fields, including exact ordered stop conditions and permissions.
2. Swift on macOS: run `swift test` with shared fixtures loaded by repository-relative path or SwiftPM resources.
3. Verify all 30 cases in each language, plus invalid-input tests, constraint-conflict tests, untrusted capability tests, and red-action approval tests.
4. Fail the PR on ANY mismatch, missing fixture, unexpected schema key, or failed test. Do not mark Swift validated based on Linux/Python results.
5. Keep existing `ProposalCompilerTests.testPublicPreviewFailsSafe` as a regression guard.

This document defines the contract, not evidence that the Swift implementation or CI already exists.
