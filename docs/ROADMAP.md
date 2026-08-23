# Roadmap

Roadmap items are ordered by user value and safety dependency, not by marketing pressure.

## M0 — Public preview

Status: complete

- Deterministic policy reference core.
- 30 baseline evaluation tasks.
- TaskSpec schema and product specification.
- Native macOS proposal UI.
- Progressive disclosure: section titles by default, one detail section at a time.
- Local Codex CLI availability probe.
- Project-level MissionCompiler Skill POC.
- Security policy, public documentation, reproducible run script, and a CI definition ready to activate.

## M1 — Live read-only discovery

Exit criteria: the proposal card is derived from current host facts without changing project or global state.

- Launch and initialize Codex App Server locally.
- Dynamically list available models and reasoning efforts.
- Read collaboration modes, Skills, permission profiles, and configured MCP servers.
- Scan project instructions, Git state, build paths, and tests.
- Record fact source, timestamp, and confidence class.
- Display drift and unknowns without filling gaps by inference.

Plugin installation will not depend on App Server endpoints that remain marked as under development. The first implementation should prefer stable host and CLI surfaces.

## M2 — Approval-bound Codex execution

Exit criteria: one low-risk code task can be completed in an isolated workspace with evidence and a tested rollback.

- Compile TaskSpec into a Codex task.
- Create or select the approved workspace strategy.
- Stream progress and approvals into the native app.
- Enforce approved paths, permissions, network access, and stop conditions.
- Run a bounded repair loop.
- Verify required checks and generate an evidence report.
- Exclude red external actions from the first executable milestone.

## M3 — Capability trust and installation

Exit criteria: a missing trusted Skill or MCP can be proposed, inspected, approved, installed at a fixed version, verified, and removed.

- Capability registry with publisher, source, version, permissions, and health.
- Trust policy and provenance display.
- Exact-candidate approval.
- Post-install verification and uninstall path.
- Regression cases for untrusted and over-broad capabilities.

## M4 — Product learning loop

Exit criteria: recommendations improve from measured failures without silently rewriting safety policy.

- Opt-in, privacy-preserving outcome telemetry.
- Failed-task taxonomy and replayable eval cases.
- Recommendation quality metrics.
- Human-reviewed policy versioning.
- Additional engine adapters only after the Codex path is reliable.

## Release gates

No binary release should be presented as production-ready until it has signing, notarization, update integrity, a privacy statement, crash handling, and end-to-end verification on a clean macOS machine.
