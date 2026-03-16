---
name: eiid-awareness
description: EIID strategic awareness during planning. Fires when Claude enters plan mode or proposes architecture changes. Checks alignment with EIID mapping, flags scope creep, surfaces missed opportunities.
user-invocable: false
---

When planning changes to the codebase:

1. Read CLAUDE.md for the EIID mapping and user need. Read `.superskills/report.md` for the Project Profile (if it exists).
2. **User need check:** does this change trace back to the user need defined in CLAUDE.md? If not, why are we building it?
3. **EIID layer:** which layer does it support? (enrichment / inference / interpretation / delivery / none). No layer? Potential scope creep. Flag it.
4. **Evolution check:** is this component commodity (automate — don't build what you can buy), judgment-dependent (differentiate — enhance with better information), or new coordination (innovate — build it)? Check the Approach field: if it says "via agent", building coded infrastructure may be premature. If it says "via code", an agent-based approach may not meet volume or determinism requirements.
4b. **Implementation level check:** does the implementation match the classified level? An LLM call that uses tool loops is under-classified (should be workflow or agent). An agent that never iterates is over-classified (should be LLM call or workflow). Flag mismatches.
4c. **Parity check:** if the change adds a new user-facing action in the UI, is there a corresponding tool for agents? Missing parity means agents cannot do what users can.
5. **Delivery check:** does this reach the user where they already are, or does it require context-switching? If `.superskills/design-system.md` contains an EIID Interface Map, verify the delivery channel matches the documented modality. Building a web notification system when the map specifies WhatsApp as the delivery channel is scope creep.
5b. **Interface modality check:** if the change adds a new page, screen, or visual component, check which EIID layer it serves. If `.superskills/design-system.md` has an EIID Interface Map and that layer is mapped to conversational or notification modality, flag: "EIID layer [X] is mapped to [modality]. Adding a visual surface may be out of scope."
6. **Profile check:** does the Project Profile flag any recurring patterns relevant to this change? (e.g., "new API routes tend to lack auth checks" — remind about auth if adding a route.)
7. Surface missed opportunities from the 11-question scan only when clearly relevant to the current change.
8. **Staleness nudge:** compare CLAUDE.md against the actual codebase. If any of these are true, suggest "CLAUDE.md may be stale. Consider running `/super:strategy` to refresh it."
   - Dependencies in package.json not reflected in the Stack or Technology Constraints section (3+ untracked deps)
   - Source files that don't map to any documented EIID layer (5+ unmapped files)
   - EIID layers documented but empty in the codebase, or developed in code but missing from CLAUDE.md
   - A component's approach has shifted (e.g., classified as "innovate" but commodity alternatives now exist, or classified as "automate" but was custom-built)
   - A component marked "via agent" has been implemented as code, or vice versa, without updating the strategy
   - A component's implementation level has shifted (e.g., an LLM call grew tool loops, or an agent was simplified to a fixed pipeline)

One line per observation. Only when relevant. Not blocking. Brief.
