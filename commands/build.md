---
description: Takes the EIID mapping and builds. Vision conversation, tests that encode the vision, autonomous construction until tests pass. Sets up autoresearch loops for eligible nodes.
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, WebSearch, WebFetch
---

# Build

Read `reference/concepts.md` for EIID, graduation, autoresearch, and target feeling definitions.

## Detect Mode

**1. Does a strategy exist?** Check for CLAUDE.md with an EIID mapping table.

**2. Route:**
- **No EIID mapping** -> stop. "No strategy found. Run `/eiid:strategy` first."
- **EIID mapping exists + no built code** -> run **init mode**
- **EIID mapping exists + built code + user provided a target** -> run **extend mode**
- **EIID mapping exists + built code + no target** -> "Project has code. Provide a target to build."

---

## Init Mode

### 1. Vision

Before anything technical, have a conversation:

**"Describe what this product should do. Not features — the experience. What does the user see, feel, do? When is this product perfect?"**

Collect descriptions, examples, references, screenshots. Then challenge:
- Complexity that doesn't serve the user. Four steps where two would work. A dashboard where a notification delivers the same value.
- Missing pieces. What happens on failure? What does the first experience look like with no data?
- Better patterns. The EIID mapping shows conversational delivery but they described a dashboard. Which actually serves the user?
- Contradictions. They want it minimal but described 6 surfaces. Which matters more?

When aligned: "Anything else, or should I show you what I'd build?"

### 2. Tests First

Write the complete test suite that encodes the vision before any product code.

Install test infrastructure per the product's shape: visual surfaces need browser tests, APIs need integration tests, agents need response structure tests, CLIs need output tests.

Write tests from the experience, not from implementation:

```
// Good: tests the experience
test('seller arrives at overview, sees prices sorted by opportunity, biggest margin gap first')
test('when competitor drops >20%, push notification within 5 minutes')

// Bad: tests the implementation
test('PriceTable component renders with sorting prop')
test('API returns 200 with price array')
```

For nodes with metrics, tests verify the metric: `test('product matcher accuracy exceeds 90% on test set')`.

Run the tests. They should all fail (the product doesn't exist yet) but be syntactically valid. Write the test plan to `.eiid/build-plan.md`.

### 3. Build Loop

Autonomous until all tests pass.

**Order:** Start from commodity nodes (low risk, clear implementation), then custom, then genesis. Infrastructure before intelligence before surfaces.

For each piece:
1. Re-read CLAUDE.md before starting (context drifts on long builds).
2. Build with full context: EIID mapping, target feeling, vision.
3. Run the full test suite. Track which tests flip from failing to passing.
4. On regression: revert, analyze, try differently. Maximum 5 attempts per piece.
5. On stuck after 5 iterations: log what was tried, skip, continue.

For Interpretation/Delivery nodes with visual surfaces: make design decisions here, guided by the target feeling. Typography, color, layout, tokens — these emerge from what the node needs to communicate, not from a separate design phase.

### 4. Autoresearch Setup

For nodes marked "autoresearch" in the EIID mapping:

1. **Define what changes** — the prompt, embedding approach, parameters, detection logic. Scope it to one variable at a time.
2. **Define what you measure** — the node's metric from the mapping. Must be computable automatically.
3. **Define keep/discard** — commit if the metric improves, revert if not.
4. **Run the loop** — change, measure, keep or discard. Log each experiment to `.eiid/decisions.md`.

This is the bridge between strategy and continuous optimization. The strategy identified the node as autoresearch-eligible. Build makes it real.

### 5. Report

Present results and write to `.eiid/report.md`:
- Tests: passed / total / skipped (with reasons)
- EIID coverage: which layers are implemented
- Autoresearch: which loops are set up, baseline metrics
- Skipped pieces: what failed, what was tried

Update `.eiid/decisions.md` with what was learned during build.

---

## Extend Mode

Add a feature or build a piece on top of existing code.

### 1. Vision
Same conversation, scoped to the change. What does the user experience today, and what should change?

### 2. Tests First
Write new tests encoding the change. Run the full existing suite first to confirm the baseline.

### 3. Build
Same autonomous loop. New tests pass, old tests don't break.

### 4. Report
Full test results. Log to decisions.md.

---

## Rules

- Vision before plan. The user describes perfection in their own words. Build understands it before proposing anything.
- Tests are the plan. They encode the vision, track progress, and gate quality.
- Autonomous after vision approval. Log, don't ask.
- All tests pass or skip with reason. Not "mostly pass."
- Five iterations max per piece, then skip and report.
- The strategy is truth. If what you're building contradicts CLAUDE.md, stop and report.
- Context drift is real. On builds with 5+ pieces, re-read CLAUDE.md before each piece.
