---
description: Measures the product against the EIID mapping. Metrics per node, autoresearch convergence, context fidelity, security basics.
allowed-tools: Read, Glob, Grep, Write, Edit, Bash
---

# Review

Review measures. Review does not fix. Every finding is a report entry with location, severity, and suggested fix. The user decides what to fix and when.

## Prerequisites

Read CLAUDE.md. If no EIID mapping exists, stop and suggest `/eiid:strategy` first.

Read `reference/concepts.md` for canonical definitions.

---

## 1. Tests

Check for test infrastructure. If found, run all configured test suites.

**Block while tests fail.** Ask whether to continue with remaining checks or stop to fix failures first.

If no test infrastructure exists, flag: "No tests found. Run `/eiid:build` to set up testing from the vision."

---

## 2. Metrics Per Node

Read the EIID mapping table from CLAUDE.md. For each node:

### Nodes with Metrics (Enrichment, Inference)
- **Can you measure it now?** Look for test sets, evaluation scripts, monitoring. If the infrastructure exists, run the measurement.
- **Compare against target.** Is the metric above, at, or below the target defined in the mapping?
- **Graduation check.** Has the graduation trigger fired? If the metric has consistently exceeded the target, flag: "Node [X] has exceeded its graduation target. Consider simplifying the implementation."

### Nodes with Signals (Interpretation, Delivery)
- **Ask the user.** "The mapping defines [signal] for [node]. What's the current state?"
- **Compare against expectation.** Flag if the signal suggests problems (high fatigue rate, low acceptance rate, long time-to-action).

### Missing Nodes
- Nodes in the mapping with no corresponding code: "Node [X] is in the mapping but not implemented."
- Code that doesn't trace to any node: "Files [X, Y, Z] don't map to any node in the EIID mapping."

---

## 3. Autoresearch Report

For nodes marked "autoresearch" in the mapping:

- **Is the loop running?** Check for experiment logs in `.eiid/decisions.md`.
- **Convergence.** Are improvements getting smaller? If the last 10 experiments produced less than 1% improvement, the loop is converging. Suggest graduation.
- **Divergence.** Are results getting worse or unstable? Flag and suggest reviewing the optimization target.
- **Not started.** If the node is marked autoresearch but no loop exists: "Node [X] is autoresearch-eligible but no loop is set up. Run `/eiid:build` to create it."

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

If context has drifted, suggest: "CLAUDE.md is stale. Run `/eiid:strategy` with context about what changed."

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

Write findings to `.eiid/report.md`:

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
