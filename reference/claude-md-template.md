# CLAUDE.md Template

Strategy generates this file. It is the strategic context document of the product. An AI agent reading this file with no other context should know where the value is, what the product accumulates from use, what to build, what to measure, and when to change approach. Target: under 80 lines.

---

```markdown
# [Project Name]

## Business
**Client:** [who is paying]
**Value expected:** [the outcome user and product achieve together, in one sentence — not features]
**World Model:** [what the product accumulates from use, at what scope (per-user, per-org, aggregate, or mix), and where it lives in the nodes]
**Regulatory posture:** [AI Act role (provider/deployer/both/downstream provider of GPAI). GDPR role (controller/processor/joint — determines who owns DPIA, incident response, data subject rights). AI Act tier (prohibited/high-risk/limited-risk/minimal-risk) with Annex reference. GDPR basis for World Model accumulation. Art 22 automated decisions: yes/no. DPIA: required/not-required/done. Full analysis in `.playbook/regulatory-annex.md`.]

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
