# TaskSpec semantics

Use these fields to keep the execution contract complete. Do not invent values solely to fill the shape.

## Source and intent

- `raw_prompt`: exact user request.
- `summary`: one-sentence outcome.
- `task_type`: `bug_fix`, `small_feature`, `code_review`, `test_repair`, `project_setup`, or `analysis`.
- `deliverables`: observable artifacts or results.
- `must_preserve`: behavior and user work that cannot change.
- `prohibited_actions`: explicit hard boundaries.
- `acceptance_criteria`: each criterion plus its verification method.

## Environment

Record the working directory, scan completeness, Git state, protected changes, stack, commands, available capabilities, and whether the model/permission catalog came from a current host query. Mark unavailable fields unknown rather than guessing.

## Normalized facts

Capture:

- clarity (`clear`, `partial`, `unclear`);
- estimated files and modules;
- whether files change;
- Git and dirty-worktree state;
- network, capability-install, and visual-check needs;
- rollback difficulty;
- risk tags and external actions;
- constraint conflicts and capability trust failures.

## Recommendation

Include mode, risk, model tier, reasoning effort, workspace strategy, reviewer need, approval timing, permissions, capability plan, steps, stop conditions, and execution disposition.

Use model tiers `fast`, `balanced`, or `strong`; resolve a real model only from the current host catalog. Use `read_only`, `current_workspace`, `isolated_worktree`, `snapshot_workspace`, or `external_only` for workspace strategy.

## Verification and rollback

Every required acceptance criterion needs a named check or reproducible method. Choose rollback before mutation: no rollback needed, discard an isolated worktree, restore a snapshot, or describe manual reversal for an external action.
