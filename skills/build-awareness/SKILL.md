---
name: build-awareness
description: Quality awareness during implementation. Fires when Claude writes or edits source code. Checks EIID traceability, target feeling, and context fidelity.
user-invocable: false
---

When writing or editing application source code (not config, not tests, not markdown):

If CLAUDE.md doesn't exist, stop. No context to check against.

1. Read CLAUDE.md for the EIID mapping table and target feeling.
2. **Node trace:** which node does this code serve? If none, and it's not supporting infrastructure (tests, types, config, shared utilities), flag it.
3. **Target feeling:** if the code produces anything a user perceives — UI, agent responses, notifications, CLI output, error messages — does it contribute to or undermine the target feeling?
4. **Context fidelity:** does this code change what CLAUDE.md says about the product? A new data source means the Enrichment layer needs updating. A new delivery channel means the Delivery layer needs updating. Flag when CLAUDE.md should be refreshed.

One line per observation. Only when relevant. Not blocking. Challenge, don't lecture.
