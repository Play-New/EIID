---
description: Takes the playbook mapping and builds. Vision conversation, tests that encode the vision, autonomous construction until tests pass. Sets up autoresearch loops for eligible nodes.
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, WebSearch, WebFetch
---

# Build

Read `reference/concepts.md` for the four layers, graduation, autoresearch, Interface, and World Model definitions.

## Detect Mode

**1. Does a strategy exist?** Check for CLAUDE.md with a playbook mapping table.

**2. Route:**
- **No playbook mapping** -> stop. "No strategy found. Run `/playbook:strategy` first."
- **playbook mapping exists + no built code** -> run **init mode**
- **playbook mapping exists + built code + user provided a target** -> run **extend mode**
- **playbook mapping exists + built code + no target** -> "Project has code. Provide a target to build."

---

## Init Mode

### 1. Vision

Before anything technical, read the **World Model** field in CLAUDE.md — the strategy declared what must accumulate. Then have the conversation:

**"Describe what user and product do together when this works. Not features — the loop. What does the user do? What does the product observe, learn, compose? What emerges from their interaction that neither could build alone? When is this loop at its richest?"**

Bridge: *"Your CLAUDE.md says the product accumulates [field content]. Where in the experience does that happen?"* If no capture path exists, strategy and vision are misaligned — resolve before continuing.

Collect descriptions, examples, references, screenshots. Then challenge:
- Complexity that doesn't serve the user. Four steps where two would work. A dashboard where a notification delivers the same value.
- Missing pieces. What happens on failure? What does the first experience look like with no data?
- Better patterns. The playbook mapping shows conversational delivery but they described a dashboard. Which actually serves the user?
- Contradictions. They want it minimal but described 6 surfaces. Which matters more?
- **Missing learning loop.** The experience is rich but the product learns nothing from it. The user does something; the product does something back; then the signal evaporates. A surface that captures no signal builds no World Model — even the most beautiful one is static product, not co-construction. What does the product observe in each interaction? Where does that observation flow?

When aligned: "Anything else, or should I show you what user and product would do together?"

### 2. Tests First

Write the complete test suite that encodes the vision before any product code.

Install test infrastructure per the product's shape: visual surfaces need browser tests, APIs need integration tests, agents need response structure tests, CLIs need output tests.

Write tests from the experience, not from implementation:

```
// Good: tests what user and product do together
test('seller arrives at overview, sees prices sorted by opportunity, biggest margin gap first')
test('when competitor drops >20%, push notification within 5 minutes')

// Good: tests what the product learns (the other half of the vision)
test('when seller edits a price recommendation, the edit is captured and feeds the interpretation layer')
test('when an alert is ignored 3+ times, the anomaly detector reduces confidence for that pattern')
test('when user searches for an untracked competitor, the query flows to the enrichment coverage map')

// Bad: tests the implementation
test('PriceTable component renders with sorting prop')
test('API returns 200 with price array')
```

Every Interface surface needs both kinds of test: what the user experiences AND what the product learns. A test suite that covers only the user-side encodes half the vision.

For nodes with metrics, tests verify the metric: `test('product matcher accuracy exceeds 90% on test set')`. The test set itself co-evolves — corrections users make through the Interface flow into it, so the metric tracks learning, not just static performance.

Run the tests. They should all fail (the product doesn't exist yet) but be syntactically valid.

### 3. Build Loop

Autonomous until all tests pass.

**Order:** Start from commodity nodes (straightforward, clear implementation), then custom, then genesis. Infrastructure before intelligence before surfaces. Build signal-capture alongside delivery in every node that touches humans — not after.

For each node:
1. Re-read CLAUDE.md before starting (context drifts on long builds).
2. Build with full context: playbook mapping, value expected, World Model, regulatory posture, vision. The declared World Model tells you what signal this node must capture; the regulatory posture constrains how (lawful basis, retention, data subject rights surfaces, human oversight if high-risk) — honor both, from day one, not retrofitted.
3. Run the full test suite. Track which tests flip from failing to passing.
4. On regression: revert, analyze, try differently.
5. When iterations stop producing new approaches: log what was tried, skip the node, continue.

For Interpretation/Delivery nodes with visual surfaces: make design decisions here, guided by the value expected. What the node needs to communicate AND what it needs to observe determines the choices. Every Interface surface is both attuatore and sensore — the visual, the interaction, and the signal-capture are designed together, not sequenced.

For every node that touches humans — Delivery always, Enrichment and Interpretation when users interact — ask: does this surface capture signal? Accepts, ignores, modifies, requests-for-what-doesn't-exist are the raw material of the World Model. Match capture to the declared World Model and regulatory posture: consent collection + withdrawal if GDPR consent; human oversight and transparency indicators if AI Act high-risk. Signal capture, lawful basis, and rights surfaces are built alongside delivery, not after.

### 4. Autoresearch Setup

For nodes marked "autoresearch" in the playbook mapping, set up the loop per the Karpathy framework (see `reference/concepts.md`):

1. **Evaluation set.** The loop needs labeled data to measure against. A product matcher needs correct matches. An anomaly detector needs labeled anomalies. If no evaluation set exists, creating it is the first step. Start small (50-100 labeled examples), expand as the loop runs.
2. **Mutable file.** Designate exactly one file the agent can change for this node: the prompt file, the config, or the logic file. Everything else is frozen.
3. **Metric.** The node's metric from the mapping, computed automatically against the evaluation set. One number.
4. **Time budget.** Set a fixed time per experiment (evaluation included). Short enough to run many experiments, long enough to produce a real measurement.
5. **Run the loop.** The agent reads the mutable file, forms a hypothesis, makes one change, runs the evaluation. Each experiment runs 3+ times — a single improvement means nothing. Accept only if statistically significant (Median Absolute Deviation separates real gains from noise).
6. **Backpressure.** After a benchmark passes, run correctness checks (tests, types, lint). If correctness breaks, reject the improvement even if the metric improved. The metric gets better AND the system stays correct.
7. **Keep or discard.** `git commit` when the improvement is both real (confidence) and correct (backpressure). `git reset --hard` when it isn't. No human in the loop. Log each experiment (hypothesis, change, result, confidence score) to `.playbook/report.md`.

The loop runs autonomously until convergence (improvements < 1% over 10 experiments) or until the time budget for the session is exhausted. Small 1% gains compound over hundreds of iterations into results no human would find.

### 5. Report

Write results to `.playbook/report.md`:
- Tests: passed / total / skipped (with reasons)
- Layer coverage: which layers are implemented
- Autoresearch: which loops are set up, baseline metrics
- Skipped nodes: what failed, what was tried
- Decisions: non-obvious choices made during build

---

## Extend Mode

Add a feature or build a node on top of existing code.

### 1. Vision
Same conversation, scoped to the change. What do user and product do together today, and what should the interaction look like after this change? What does the user do differently? What does the product observe or learn differently? What part of the World Model deepens?

### 2. Tests First
Write new tests encoding the change. Run the full existing suite first to confirm the baseline.

### 3. Build
Same autonomous loop. New tests pass, old tests don't break.

### 4. Report
Full test results. Log to `.playbook/report.md`.

---

## Rules

- Vision before plan. User and product describe co-construction together — what the user does, what the product learns, what emerges from their interaction. Build understands both sides before proposing anything.
- Tests are the plan. They encode both halves of the vision — user-side experience and product-side learning — track progress, and gate quality. A test suite that only tests what the user sees is incomplete.
- Autonomous after vision approval. Log, don't ask.
- All tests pass or skip with reason. Not "mostly pass."
- When iterations stop producing new approaches, skip and report.
- The strategy is truth. If what you're building contradicts CLAUDE.md, stop and report.
- Context drift is real. On builds with 5+ nodes, re-read CLAUDE.md before each node.
- Every defect found manually becomes an automated test. If you catch it by hand twice, the process is broken. This applies to the product code, to the tests themselves, and to the playbook mapping. The system catches its own mistakes or it doesn't work.
