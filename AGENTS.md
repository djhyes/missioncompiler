# MissionCompiler contributor instructions

## Product truth

- Treat this repository as a public preview, not a production-ready executor.
- Never claim that the app drives Codex, installs capabilities, or modifies projects until those paths exist and have end-to-end tests.
- Preserve the separation between language-model normalization and deterministic policy.
- Red external actions always require action-time approval.

## Interface

- Keep the default UI calm and non-technical.
- Show proposal section titles first; reveal details with progressive disclosure.
- Keep the technical inspector hidden by default.
- Use native macOS controls, adaptive colors, keyboard access, and semantic labels.

## Changes

- Make the smallest change that satisfies the issue.
- Do not modify global Codex configuration during tests or demos.
- Do not add dependencies without documenting purpose, source, permissions, and removal path.
- Update tests and public capability claims together.

## Verification

Run before reporting completion:

```bash
swift test
PYTHONPATH=src python3 -m unittest discover -s tests -v
PYTHONPATH=src python3 -m missioncompiler.cli eval evals/tasks.json
```

For UI changes, also run `./script/build_and_run.sh --verify` and inspect the real window.
