---
name: eiid-awareness
description: EIID strategic awareness during planning. Fires when Claude enters plan mode or proposes architecture changes. Checks alignment with EIID mapping, flags missing nodes, surfaces graduation triggers.
user-invocable: false
---

When planning changes to the codebase:

If CLAUDE.md doesn't exist, stop. No context to check against.

1. Read CLAUDE.md for the EIID mapping table.
2. **Node trace:** does this change serve a node in the mapping? Which layer? If none, flag: potential scope creep.
3. **Evolution check:** does the node's evolution justify the investment? Building custom for a commodity node is waste. Buying for a genesis node means you're not creating value.
4. **Missing layers:** does the mapping cover all four EIID layers? If an entire layer is absent, flag it.
5. **Graduation check:** has a graduation trigger fired? If a node's metric has consistently exceeded its target, suggest revisiting the approach.
6. **Autoresearch opportunity:** if the change touches an Enrichment or Inference node with a clean metric and no autoresearch loop, flag the opportunity.
7. **Context fidelity:** does the change mean CLAUDE.md needs updating? New nodes, changed evolution, fired graduation triggers?

One line per observation. Only when relevant. Not blocking. Brief.
