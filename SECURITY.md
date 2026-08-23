# Security policy

## Supported versions

Only the latest commit on `main` is supported during the public preview. No production-ready binary has been released.

## Report a vulnerability

Please use GitHub's private vulnerability reporting flow under **Security → Report a vulnerability**. Do not open a public Issue for a vulnerability that could expose data, execute commands unexpectedly, weaken approval boundaries, or install an untrusted capability.

Include the affected commit, minimal reproduction, impact, and whether the issue crosses a file, network, credential, capability-installation, or external-action boundary. Do not include live credentials or third-party private data.

## High-priority classes

- Execution outside an approved path or workspace.
- Network or external actions without the displayed approval.
- Secret values printed in logs or reports.
- Capability provenance or version checks that can be bypassed.
- Stale approvals reused after material environment drift.
- UI that presents a simulated action as a real completed action.
