# CLAUDE.md Template

Strategy generates this file. It is the strategic context document of the product. An AI agent reading this file with no other context should know where the value is, what to build, what to measure, and when to change approach. Target: under 80 lines.

---

```markdown
# [Project Name]

## Business
**Client:** [who is paying]
**Value expected:** [the outcome, in one sentence — not features]

## Playbook

| Node | Layer | Evolution | Metric / Signal | Graduation | Loop |
|------|-------|-----------|-----------------|------------|------|
| [name] | Enrichment | [genesis/custom/product/commodity] | [what you measure, target] | [condition + direction] | [autoresearch/manual review/N/A] |
| ... | ... | ... | ... | ... | ... |

Multiple nodes per layer is normal. A product might have 3 Enrichment nodes and 2 Delivery nodes. Every node gets its own row.

## Stack
[detected or recommended, with rationale — only if code exists or is about to be written]

## Constraints
[one per line: budget, timeline, team size, compliance, existing commitments — only what actually constrains decisions]
```
