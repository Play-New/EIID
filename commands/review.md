---
description: Measures the product against the playbook mapping. Metrics per node, autoresearch convergence, context fidelity, security basics.
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

## 2. Metrics Per Node

Read the playbook mapping table from CLAUDE.md. For each node:

### Nodes with Metrics
Nodes where the mapping defines a quantifiable metric (accuracy, coverage, latency, precision, recall — regardless of layer):
- **Can you measure it now?** Look for test sets, evaluation scripts, monitoring. If the infrastructure exists, run the measurement.
- **Compare against target.** Is the metric above, at, or below the target defined in the mapping?
- **Graduation check.** Has the graduation trigger fired? If the metric has consistently exceeded the target, flag: "Node [X] has exceeded its graduation target. Consider the next step documented in the trigger."

### Nodes with Signals
Nodes where the mapping defines a human-observable signal (acceptance rate, fatigue, time to action — regardless of layer):
- **Ask the user.** "The mapping defines [signal] for [node]. What's the current state?"
- **Compare against expectation.** Flag if the signal suggests problems.

### Missing Nodes
- Nodes in the mapping with no corresponding code: "Node [X] is in the mapping but not implemented."
- Code that doesn't trace to any node: "Files [X, Y, Z] don't map to any node in the playbook mapping."

---

## 3. Autoresearch Report

For nodes marked "autoresearch" in the mapping:

- **Is the loop set up?** Check: is there a designated mutable file, an evaluation set, and a metric? If any is missing: "Node [X] is autoresearch-eligible but the loop is incomplete. Run `/playbook:build` to set it up."
- **Convergence.** Read experiment logs in `.playbook/report.md`. Are improvements getting smaller? If the last 10 experiments produced less than 1% improvement, the loop is converging. Suggest graduation.
- **Divergence.** Are results getting worse or unstable? Flag and suggest reviewing the mutable file scope or evaluation set quality.
- **Below target.** If the loop exists and the metric is below target, run an autoresearch cycle: read the mutable file, form a hypothesis based on previous experiments, make one change, evaluate, `git commit` or `git reset --hard`. Log the experiment. The system improves itself, not just reports.

---

## 4. Context Fidelity

The CLAUDE.md must reflect the actual product. Check:

- **Nodes vs code.** Every node in the mapping should have corresponding source files. Every significant source file should trace to a node. Flag mismatches.
- **Evolution accuracy.** Has a genesis node become commodity (competitors launched similar solutions)? Has a commodity node required custom work? Flag stale evolution classifications.
- **Stack match.** Does the Stack section in CLAUDE.md match the actual dependencies in package.json?
- **Staleness indicators:**
  - Dependencies in package.json not reflected in CLAUDE.md (3+ untracked)
  - Source files that don't map to any node (5+ unmapped files)
  - Nodes documented but empty in the codebase
  - Graduation triggers that have fired but the approach hasn't changed

If context has drifted, suggest: "CLAUDE.md is stale. Run `/playbook:strategy` with context about what changed."

---

## 5. Security

Compact security check. Report findings, do not fix.

### Secrets
- Hardcoded API keys, passwords, tokens in source files
- `.env` files in .gitignore?
- Secrets in git history (common patterns: `sk-`, `AKIA`, `ghp_`, `password =`)

### OWASP Basics
Scan source files for the most common vulnerabilities:
1. API routes without auth checks
2. Unsanitized user input in queries or templates
3. Unescaped user content rendered as HTML
4. Missing input validation on user-facing endpoints
5. Debug mode or overly permissive CORS in production config

### Blocking Rules
**Block** on: credentials in source code, SQL/NoSQL injection, XSS, auth bypass on protected routes. Everything else: severity level in the report.

---

## Output

Write findings to `.playbook/report.md`:

```
## Review — [date]

### Test Results
[passed/failed/skipped]

### Node Metrics
| Node | Layer | Metric/Signal | Target | Actual | Status | Loop |
|------|-------|---------------|--------|--------|--------|------|
| ... | ... | ... | ... | ... | on track / below / needs setup / graduated | autoresearch / manual / N/A |

### Autoresearch
[convergence status per node, experiments run, improvement trend]

### Context Fidelity
[mismatches between CLAUDE.md and actual codebase]

### Security
| Severity | File:line | Issue | Fix |
|----------|-----------|-------|-----|
| ... | ... | ... | ... |

### Recommendations
[what to do next: graduate nodes, update context, set up autoresearch, fix security]
```

Print a summary at the end:
```
Tests:      [passed/failed/skipped]
Nodes:      [measured/total] measured, [graduated] ready for graduation
Context:    [fidelity status]
Security:   [blocking count] blocking
```
