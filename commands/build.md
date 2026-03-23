---
description: Autonomous build loop. Reads strategy and design, checks readiness, decomposes into pieces, builds each with quality gates. Shared standards are deterministic (template + test). Unique pieces are generative (LLM + test).
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, WebSearch, WebFetch
---

# Build

Autonomous construction from strategy and design context. The loop builds one piece at a time, verifies each against quality gates, and advances only when gates pass.

Read `reference/shared-standards.md` for building block patterns. Read `reference/build-readiness-guide.md` for the readiness check.

## Detect Mode

Three modes. Detection order matters.

**1. Does a strategy exist?** Check for CLAUDE.md with an EIID mapping section.

**2. Route:**
- **No EIID mapping** → stop. Tell the user: "No strategy found. Run `/super:strategy` first."
- **EIID mapping exists + no built code** (empty src/ or app/) → run **init mode**
- **EIID mapping exists + built code + user provided a target** (feature, EIID layer, component, or ticket description) → run **extend mode**
- **EIID mapping exists + built code + no target** → tell the user: "Project has code. Provide a target to build: a feature description, an EIID layer to implement, or a specific component."

---

## Init Mode

First build from a fresh strategy. Produces the foundational codebase.

### 1. Readiness Check

Follow `reference/build-readiness-guide.md`. Three gates:

- **Strategy gate:** CLAUDE.md has EIID mapping with Approach fields. Each component has a strategic classification (automate/differentiate/innovate) and implementation level (code/buy/LLM call/workflow/agent).
- **Stack gate:** package.json exists with framework and core dependencies installed. If not, install the recommended stack from CLAUDE.md.
- **Design gate:** if any EIID layer is mapped to visual modality in `.superskills/design-system.md`, the design system must exist with at least Direction, Typography Scale, and Tokens sections. If no visual layers exist, skip this gate.

If any gate fails, tell the user what's missing and which command to run. Do not proceed.

### 2. Decompose

Read the EIID mapping. Produce a build plan — an ordered list of pieces to construct. The order follows dependencies, not EIID layer sequence.

**Shared standards first.** These are the building blocks that every project needs and that should work identically every time. Read `reference/shared-standards.md` for the full list. Order:

1. **Project scaffold** — directory structure, base config, env setup
2. **Database schema** — tables, RLS policies, types generation
3. **Auth** — login, signup, session, middleware, protected routes
4. **Layout shell** — sidebar/nav, page structure, responsive breakpoints (if visual layers exist)
5. **Settings** — user preferences, system configuration, prompt management (if applicable)

**Then EIID layers by priority.** From `.superskills/decisions.md` or the priority order in CLAUDE.md:

6. **Enrichment connectors** — data sources, webhooks, polling jobs, input parsing
7. **Inference pipeline** — pattern detection, predictions, anomaly flags
8. **Interpretation layer** — insight generation, framing, contextualization
9. **Delivery channels** — notifications, messages, email, real-time updates

**Then supporting pieces:**

10. **Visual surfaces** — dashboards, detail views, forms (only for layers mapped to visual modality)
11. **Agent runtime** — if any component uses agent/workflow/LLM call
12. **Background jobs** — scheduled tasks, cron, event-driven workflows

Each piece gets:
- **What:** concrete description tied to EIID mapping
- **Type:** `shared-standard` or `unique`
- **Acceptance criteria:** for shared standards, from `reference/shared-standards.md`. For unique pieces, derived from the EIID mapping + design system
- **Dependencies:** which pieces must exist first

Present the build plan. Wait for user confirmation. The user may reorder, skip, or add pieces.

### 3. Build Loop

For each piece in the confirmed plan, run the loop:

#### 3a. Pre-flight

- Read the piece's acceptance criteria
- If `shared-standard`: read the corresponding section in `reference/shared-standards.md` for the pattern and test expectations
- If `unique`: read CLAUDE.md for EIID context, `.superskills/design-system.md` for design context (if visual), any relevant reference files
- Check dependencies: are prerequisite pieces built and passing?

#### 3b. Write Tests First

Write acceptance tests before implementation. Tests define the outcome.

- For shared standards: tests verify the pattern works (auth redirects unauthenticated users, settings persist changes, schema matches expected tables)
- For unique pieces: tests verify the EIID behavior (enrichment connector receives and normalizes data, inference detects the specified pattern, delivery sends to the right channel)
- For visual surfaces: tests verify the design system compliance (correct tokens used, responsive behavior, accessibility basics — contrast, focus, labels, keyboard nav)

Tests should be specific enough to fail meaningfully but not so brittle they break on implementation details. Test the behavior, not the code shape.

#### 3c. Implement

Build the piece. Follow the approach from the EIID mapping:

- **Code:** write deterministic implementation
- **Buy:** integrate the service (Supabase auth, Resend email, etc.)
- **LLM call:** write the prompt, schema validation on input and output, test with representative inputs
- **Workflow:** write the step sequence, each step independently testable
- **Agent:** write tools first (atomic, schema-validated), then the orchestration loop

For shared standards, follow the pattern in `reference/shared-standards.md` closely. Consistency matters more than novelty.

For unique pieces, implement with the design system tokens and patterns if visual. Follow Code Architecture principles from CLAUDE.md.

#### 3d. Verify

Run the acceptance tests. Also run:

1. `npm test -- --run` (full test suite, not just the new tests)
2. `npx tsc --noEmit` (type checking)
3. If visual: check token compliance against `.superskills/design-system.md`

**Gate:**
- All new acceptance tests pass → proceed
- Existing tests still pass (no regression) → proceed
- Type errors → fix before proceeding
- Any failure → iterate on implementation (3c), not on tests. Tests define the target. If a test is genuinely wrong, explain why before changing it.

Maximum 3 iterations per piece. If still failing after 3, stop and report:
- What was attempted
- What's failing and why
- Proposed path forward

The user decides whether to continue iterating, skip, or adjust.

#### 3e. Log

After each piece passes:
- Append to `.superskills/decisions.md`: what was built, which EIID layer, implementation approach
- If any assumption from the strategy was incorrect (e.g., "via buy" but no suitable service exists), note the deviation
- Mark the piece as complete in the build plan

### 4. Integration Check

After all pieces are built:

1. Run the full test suite
2. Run `npx tsc --noEmit`
3. If visual surfaces exist: verify cross-screen consistency (same tokens, same layout patterns, same component usage)
4. Check EIID coverage: does every layer in the mapping have corresponding code?
5. Check parity: if agent components exist, does every UI action have a corresponding tool?

Report the results. Flag gaps.

### 5. What's Next

Tell the user:

**Built:** [count] pieces, [test count] tests passing.
**Coverage:** [which EIID layers are implemented]
**Gaps:** [anything in the mapping not yet built]

**Next step:** run `/super:review` for a full quality audit, or provide a target to extend.

---

## Extend Mode

Add a feature or implement a specific piece on top of existing code.

### 1. Load Context

Read CLAUDE.md, `.superskills/decisions.md`, `.superskills/design-system.md`. Understand what exists.

### 2. Map Target to EIID

The user provided a target (feature description, EIID layer, component, ticket). Map it:

- Which EIID layer(s) does it touch?
- What's the strategic classification? (automate/differentiate/innovate)
- What's the implementation level? (code/buy/LLM call/workflow/agent)
- Does it depend on pieces not yet built?

If the target doesn't map to any EIID layer, flag it: "This doesn't trace to the EIID mapping. Is it supporting infrastructure, or should the strategy be refreshed?"

### 3. Readiness Check

Same three gates as init mode, scoped to what this target needs:
- Dependencies built and passing?
- If visual: design system covers this screen or component?
- If new EIID component: approach and level defined in CLAUDE.md?

### 4. Build Loop

Same loop as init mode (3a-3e), applied to the target piece(s).

### 5. Integration

Run full test suite after the target is built. Check that nothing else broke. Log to `decisions.md`.

---

## Rules

- **Tests before code.** Always. Tests define the outcome, implementation achieves it.
- **Shared standards are not creative.** Auth, settings, logging, error handling follow the pattern. Consistency beats novelty for building blocks.
- **Unique pieces earn creativity.** Interpretation visualizations, inference pipelines, agent conversation flows — these are where the product differentiates. The LLM generates, tests verify.
- **Three iterations max.** If it's not working after three attempts, stop. Report. Let the human decide.
- **No scope creep.** Build what's in the plan. If a new need surfaces during building, add it to the plan as a separate piece. Don't fold it into the current piece.
- **Log everything.** Every piece built gets a decision entry. Deviations from strategy get flagged.
- **The strategy is the source of truth.** If what you're building contradicts CLAUDE.md, stop and ask. Don't silently deviate.
