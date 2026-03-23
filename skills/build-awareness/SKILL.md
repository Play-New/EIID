---
name: build-awareness
description: Design-first quality awareness during implementation. Fires when Claude writes or edits source code. Challenges every addition against rule zero, design direction, and EIID traceability.
user-invocable: false
---

When writing or editing application source code (not config, not tests, not markdown):

1. Read CLAUDE.md for the EIID mapping and user need. Read `.superskills/design-system.md` for direction and signature (if it exists). Read `reference/build-principles.md`.

2. **Rule zero.** Is this addition necessary? Does it trace to the EIID mapping and the user need? Is there a simpler way? Flag anything that doesn't earn its place:
   - A new screen for something that could be a section on an existing screen
   - A new table for data that could be derived or stored in an existing table
   - A new endpoint for an operation that could be part of an existing one
   - A new component that duplicates what an existing component does
   - A new dependency for something achievable with what's already installed

3. **Design direction.** If the code produces anything a user sees (UI, messages, errors, agent responses): does it feel like this product? Not "are the tokens correct" — does it carry the direction's character? A fleet dashboard component should feel dense and operational. A recipe component should feel warm and generous. Flag output that feels generic, templated, or disconnected from the direction.

4. **EIID traceability.** Which layer does this code serve? If none, and it's not supporting infrastructure (tests, types, config, shared utilities), flag: "This doesn't trace to the EIID mapping."

5. **Implementation level match.** Does the implementation match the classified level in CLAUDE.md? Flag mismatches: "via code" but uses an LLM call. "Via buy" but builds custom. "Via agent" but never iterates.

6. **Prompt hygiene.** If the code contains LLM prompts: are they in a discoverable location, not buried in a function? Do they have schema validation on output? Flag inline prompts in business logic.

One line per observation. Only when relevant. Not blocking. Challenge, don't lecture.
