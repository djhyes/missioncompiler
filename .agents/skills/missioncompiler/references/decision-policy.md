# Decision policy

Apply hard boundaries before convenience or cost.

## Risk

- **Green:** local read-only; no network, install, mutation, or external action.
- **Yellow:** workspace writes, limited network reads, or a trusted fixed-version capability install.
- **Red:** authentication, database migration, payment, production, secrets, security-sensitive work, trading, personal data, destructive work, sending, publishing, external writes, real orders, or regulatory submission.
- **Blocked:** the proposal conflicts with a user constraint or requires an untrusted capability.

Yellow operations can be approved with the proposal. Red external actions require approval immediately before each action. Blocked work requires a changed plan or new trust evidence; general approval does not bypass it.

## Plan score

Add:

- 2 for at least 4 files;
- 2 for at least 2 modules;
- 2 for partially clear requirements, 4 for unclear requirements;
- 1 for network;
- 2 for capability installation;
- 1 for visual verification;
- 3 for difficult rollback;
- 1 for a dirty worktree when files will change;
- 1 for a small feature;
- 2 for project setup;
- 3 for external actions;
- 4 for authentication, database migration, payment, production, regulatory, secrets, security-sensitive, or trading work.

Use Plan at 4 points or for any listed high-risk domain. Otherwise use Direct.

## Model tier

- `strong + high`: high-risk domain, score at least 7, or unclear requirements.
- `balanced + medium`: file mutation, score at least 3, or network.
- `fast + low`: remaining simple, local, read-only tasks.

Resolve tiers against the current host model catalog. Do not hardcode model slugs.

## Workspace

- No file mutation and no external action: read-only.
- External action or capability installation without project edits: external-only.
- Non-Git mutation: snapshot workspace.
- Git mutation with Plan, dirty state, or more than one file: isolated worktree.
- Clean, one-file Direct mutation: current workspace.

Use a reviewer for file mutations, capability installation, or red work.
