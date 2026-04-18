---
description: Measures the product against the playbook mapping. Metrics per node, autoresearch convergence, context fidelity.
allowed-tools: Read, Glob, Grep, Write, Edit, Bash
---

# Review

Review measures and reports. The user decides what to fix and when. One exception: for autoresearch-eligible nodes below target, review runs an optimization cycle directly. The system improves itself where it can.

## Prerequisites

Read CLAUDE.md. If no playbook mapping exists, stop and suggest `/playbook:strategy` first.

Read `reference/concepts.md` for canonical definitions.

---

## 1. Tests

Check for test infrastructure. If found, run all configured test suites.

**Block while tests fail.** Ask whether to continue with remaining checks or stop to fix failures first.

If no test infrastructure exists, flag: "No tests found. Run `/playbook:build` to set up testing from the vision."

---

## 2. Interface & World Model

Comes before Node Metrics — a node can be on-target statically while contributing nothing to the World Model.

For every node that touches humans:

- **Signal captured?** What does the product observe — accepts, ignores, modifications, requests for what doesn't exist?
- **Where does it flow?** An ignored alert feeding the anomaly detector, an edit feeding the interpretation layer. Captured-but-not-routed = sensor disconnected.
- **Compounding?** Is the node's state actually changing from use? Identical after 10K interactions as after 10 → no accumulation.
- **One-way surfaces.** Human-facing surfaces delivering value but observing nothing are the most costly gaps — the delivery is replicable, the accumulated state isn't.
- **World Model drift.** Does the CLAUDE.md World Model field still describe reality? Gap between declared and captured → flag.
- **Regulatory drift.** Rights surfaces exist and reach the accumulated state? Declared GDPR basis still valid (no purpose creep, retention honored)? Did the AI Act tier shift (new feature moved into Annex III)? Annex older than 6 months or predates a material change → flag regeneration.

---

## 3. Metrics Per Node

Read the playbook mapping table from CLAUDE.md. For each node:

### Nodes with Metrics
Nodes where the mapping defines a quantifiable metric (accuracy, coverage, latency, precision, recall — regardless of layer):
- **Can you measure it now?** Look for test sets, evaluation scripts, monitoring. If the infrastructure exists, run the measurement.
- **Compare against target.** Is the metric above, at, or below the target defined in the mapping?
- **Is it growing from use?** If the node's state is changing from captured signal, mark it **enriching**. A metric held by a static implementation is not the same as one held by learning.
- **Graduation check.** Has the graduation trigger fired? If the metric has consistently exceeded the target, flag: "Node [X] has exceeded its graduation target. Consider the next step documented in the trigger."

### Nodes with Signals
Nodes where the mapping defines a human-observable signal (acceptance rate, fatigue, time to action — regardless of layer):
- **Ask the user.** "The mapping defines [signal] for [node]. What's the current state?"
- **Compare against expectation.** Flag if the signal suggests problems.

### Missing Nodes
- Nodes in the mapping with no corresponding code: "Node [X] is in the mapping but not implemented."
- Code that doesn't trace to any node: "Files [X, Y, Z] don't map to any node in the playbook mapping."

---

## 4. Autoresearch Report

For nodes marked "autoresearch" in the mapping:

- **Is the loop set up?** Check: is there a designated mutable file, an evaluation set, and a metric? If any is missing: "Node [X] is autoresearch-eligible but the loop is incomplete. Run `/playbook:build` to set it up."
- **Convergence.** Read experiment logs in `.playbook/report.md`. Are improvements getting smaller? If the last 10 experiments produced less than 1% improvement, the loop is converging. Suggest graduation.
- **Divergence.** Are results getting worse or unstable? Flag and suggest reviewing the mutable file scope or evaluation set quality.
- **Below target.** If the loop exists and the metric is below target, run an autoresearch cycle: read the mutable file, form a hypothesis based on previous experiments, make one change, evaluate, `git commit` or `git reset --hard`. Log the experiment. The system improves itself, not just reports.

---

## 5. Context Fidelity

The CLAUDE.md must reflect the actual product. Check:

- **Nodes vs code.** Every node in the mapping should have corresponding source files. Every significant source file should trace to a node. Flag mismatches.
- **Evolution accuracy.** Has a genesis node become commodity (competitors launched similar solutions)? Has a commodity node required custom work? Flag stale evolution classifications.
- **Stack match.** Does the Stack section in CLAUDE.md match the actual dependencies in package.json?
- **World Model drift.** Does the CLAUDE.md World Model field still describe what the product actually accumulates? (Detailed Interface/signal checks live in section 2; this is the high-level drift check against the declared World Model.)
- **Staleness indicators:**
  - Dependencies in package.json not reflected in CLAUDE.md (3+ untracked)
  - Source files that don't map to any node (5+ unmapped files)
  - Nodes documented but empty in the codebase
  - Graduation triggers that have fired but the approach hasn't changed

If context has drifted, suggest: "CLAUDE.md is stale. Run `/playbook:strategy` with context about what changed."

---

## Output

Write findings to `.playbook/report.md`:

```
## Review — [date]

### Test Results
[passed/failed/skipped]

### Interface & World Model
[for each human-facing surface: what signal is captured? Is it flowing back to earlier layers? Is a World Model accumulating in this node? Which surfaces are still one-way — delivering value but observing nothing — and therefore contributing no state a competitor couldn't replicate?]

This section comes before Node Metrics because a node can be on-target by static metrics while contributing zero to the World Model. Static fitness is not the same as co-construction health.

### Node Metrics
| Node | Layer | Metric/Signal | Target | Actual | Status | Loop |
|------|-------|---------------|--------|--------|--------|------|
| ... | ... | ... | ... | ... | on track / below / needs setup / graduated / enriching | autoresearch / manual / N/A |

Status values: **on track** (metric at or above target), **below** (metric under target), **needs setup** (infrastructure missing), **graduated** (metric consistently exceeds target, approach should change per the graduation trigger), **enriching** (the node's state is actively growing from Interface signal — World Model is compounding here, not just static metric holding).

### Autoresearch
[convergence status per node, experiments run, improvement trend]

### Context Fidelity
[mismatches between CLAUDE.md and actual codebase]

### Plugin World Model
[what the plugin is accumulating from this project, feeding future strategy runs:
- classification overrides (user changed evolution/layer/loop — what and why)
- challenge outcomes (which challenges changed the user's plan, which were dismissed)
- research failures (which lenses produced no useful signal for this domain)
- context drift patterns (what drifted and why — informs future CLAUDE.md generation)

The plugin is co-constructing with its users too: every review sharpens the next strategy. This log is its World Model.]

### Recommendations
[what to do next: graduate nodes, update context, set up autoresearch, capture interface signal, build world model]
```

Print a summary at the end:
```
Tests:      [passed/failed/skipped]
Interface:  [X/Y human-facing nodes capturing signal; World Model drift if any]
Nodes:      [measured/total] measured, [graduated] ready for graduation
Context:    [fidelity status]
```
