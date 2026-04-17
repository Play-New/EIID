```
    ┌───────────────────────────────────────────────┐
    │                                               │
    │   ██████╗  ██╗      █████╗ ██╗   ██╗         │
    │   ██╔══██╗ ██║     ██╔══██╗╚██╗ ██╔╝         │
    │   ██████╔╝ ██║     ███████║ ╚████╔╝          │
    │   ██╔═══╝  ██║     ██╔══██║  ╚██╔╝           │
    │   ██║      ███████╗██║  ██║   ██║            │
    │   ╚═╝      ╚══════╝╚═╝  ╚═╝   ╚═╝            │
    │                                               │
    │   ██████╗  ██████╗  ██████╗ ██╗  ██╗         │
    │   ██╔══██╗██╔═══██╗██╔═══██╗██║ ██╔╝         │
    │   ██████╔╝██║   ██║██║   ██║█████╔╝          │
    │   ██╔══██╗██║   ██║██║   ██║██╔═██╗          │
    │   ██████╔╝╚██████╔╝╚██████╔╝██║  ██╗         │
    │   ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝         │
    │                                               │
    │   the real game is changing the game         │
    │                                               │
    └───────────────────────────────────────────────┘
```

Designs intelligence into products. Takes any input — a landing page, a SaaS, a pitch, a codebase — and shows where the intelligence should go, what to measure, and when to change approach. A Claude Code plugin.

### Install

1. Register the marketplace (once):

```bash
claude plugin marketplace add Play-New/playbook
```

2. Install the plugin:

```bash
claude plugin install playbook@playbook
```

3. Verify:

```bash
claude plugin list
```

You should see `playbook@playbook — Status: ✔ enabled`. Restart Claude Code after installing. Three commands become available: `/playbook:strategy`, `/playbook:build`, `/playbook:review`.

---

## 1. The problem

Writing code is cheap. The question "how do I build this?" has a commodity answer. The question that matters is: what shape should this product have, and does it get smarter from use?

Four failure modes:

1. **Building commodity as custom.** The component exists as a service. Building it is waste.
2. **No inference layer.** The product collects data and presents it but never detects patterns, predictions, or anomalies.
3. **No way to know if it works.** The most valuable component has no metric, no signal, no way to tell if it is improving or degrading.
4. **No World Model.** The product pushes value out but accumulates nothing from use. Every interaction could deepen understanding; instead it evaporates.

## 2. What it looks like

Before the theory, a concrete decomposition. PriceScope is a pricing intelligence tool for e-commerce sellers:

| Node | Layer | Evolution | What it does |
|------|-------|-----------|-------------|
| Price scraper | Enrichment | commodity | Collects competitor prices. Dozens of services exist. Buy it. |
| Product matcher | Enrichment | custom | Matches competitors to your SKUs. Specific to your catalog. Autoresearch: 12 experiments/hour. |
| Anomaly detector | Inference | custom | Flags unusual price changes. Autoresearch against labeled dataset. |
| Price recommendation | Interpretation | **genesis** | "Lower to 24.90, margin impact -2%, recovery in 3 days." Nobody does this. Invest here. |
| Alert dispatcher | Delivery | product | Sends the right insight at the right time. Ignored alerts = wrong threshold. |

One commodity node (buy it), two autoresearch nodes (optimize automatically), one genesis node (the reason the product exists), one delivery node where the Interface captures signal (ignored alerts tune the anomaly detector).

This is what Playbook produces. Now the theory behind it.

## 3. The model

Four layers. Value flows from raw data to user outcome and signal flows back.

| Layer | Role |
|-------|------|
| **Enrichment** | Where data enters. Normalizes inputs from every channel the user already uses. |
| **Inference** | Pattern detection, prediction, anomaly flagging. The compute is cheap; knowing what questions to ask is not. |
| **Interpretation** | Turns raw inference into something a person can act on. Context, comparison, explanation, recommended action. |
| **Delivery** | Returns the right insight through the right channel at the right moment. |

### The cycle

```
    Enrichment → Inference → Interpretation → Delivery
        ↑                                        │
        └───────── signal (through Interface) ────┘
```

What the user accepts, ignores, modifies, or asks for and doesn't get flows back to the earlier layers. A dashboard where users search for a competitor not tracked → Enrichment (coverage gap). An alert consistently ignored → Inference (precision is wrong). A recommendation edited before acceptance → Interpretation (the edit shows what the system got wrong).

### The interface

The Interface is where Enrichment and Delivery coincide. It is not a layer. It is the surface where the product touches the user.

Every interaction through the Interface is simultaneously delivery (the product responds) and enrichment (the product learns). A recruiter editing a rewrite before accepting it is receiving value and generating the richest training signal in the system. A dashboard where users search for something not yet tracked is delivering what exists and revealing what is missing.

Not "does it need a UI?" but **does the interface learn?** A static dashboard is product-stage — replaceable. A chatbot is also product-stage — Intercom, Drift, Zendesk prove it. What makes an interface genesis is not the form but the composition: an interface that assembles responses from capabilities in real time, where no two interactions follow the same path, accumulates a World Model that a fixed-navigation interface cannot. When a customer asks for something the system can't compose, that gap is the roadmap. The judgment is whether filling it aligns with what the product should be.

### The World Model

The accumulated understanding of users built from every interaction that passes through the Interface. Every capability in isolation is replicable — card processing, document parsing, notification routing. The World Model is not. It exists only because of the history of interactions that built it. Richer Interface → deeper World Model → better responses → more use. The loop compounds.

### Nodes

Playbook decomposes a product into **nodes**, each belonging to exactly one layer. Five fields per node:

| Field | What it captures |
|-------|-----------------|
| **Layer** | Enrichment, inference, interpretation, or delivery |
| **Evolution** | Genesis (invest), custom (build), product (use existing), commodity (buy). |
| **Metric / Signal** | Metric: fast, automatic feedback (accuracy, precision, latency). Signal: slow, human observation (acceptance rate, fatigue, time to action). |
| **Graduation** | When to change approach (trigger) and what to change to (direction). Both required. |
| **Loop** | Autoresearch (automated optimization), manual review (human judgment), N/A (commodity). |

Challenges during decomposition:

- "We'll build a RAG system" → RAG is how, what is the what?
- Six features, no inference → where are the patterns?
- Commodity built custom → this exists as a service
- No genesis nodes → where is the new value?
- No World Model → every interaction could teach the product something; does the Interface capture it?
- Clean metric, no experiments → autoresearch explores spaces too large for humans; is there an optimization nobody looked for?

## 4. The method

Three commands. Together they form a cycle.

### 4.1 Strategy (`/playbook:strategy`)

Takes any input — brief, pitch, idea, codebase. Researches the problem space (searching for what would make the brief *wrong*, not for confirmation). Produces two outputs:

- **Strategic assessment** for people: where the value is, where the risk is, what to do first, what not to do.
- **CLAUDE.md** for agents: structured context — which nodes are genesis, which are commodity, what to measure, when to change approach.

### 4.2 Build (`/playbook:build`)

Vision conversation first: what does the user experience when this product is perfect? Then tests that encode the vision before any product code. The test suite is the plan.

Autoresearch optimizes nodes with clean metrics and fast feedback. It does not do human work faster — it explores optimization spaces too large and tedious for humans to attempt. Small 1% improvements compound over hundreds of iterations into results no human would find.

The mechanism: one mutable file, one metric, fixed time budget. Each experiment runs 3+ times — a single improvement means nothing. Confidence scoring (Median Absolute Deviation) separates real gains from noise. Backpressure checks (tests, types, lint) ensure the improvement doesn't break correctness. `git commit` when the gain is both real and correct. `git reset --hard` when it isn't.

When the Interface captures user behavior, it generates signal at the speed of customer interaction. This shares the principle of autoresearch (observe, hypothesize, change, measure) but not its rigor — Interface signal is observational, not controlled. Sandbox autoresearch produces proof. Interface signal produces direction. Both are valuable. They are not the same thing.

### 4.3 Review (`/playbook:review`)

Measures the product against the mapping. For each node: metric above, at, or below target? Graduation trigger fired? Autoresearch converging or diverging? Interface capturing signal? Context still faithful to the actual product?

When a node is below target and has an autoresearch loop, review runs an optimization cycle directly.

### 4.4 Graduation

Nodes evolve in both directions:

- **Up.** Simple approach hits limits. Rules need a model.
- **Down.** Patterns stabilize. Model becomes a lookup table.

Each node documents both the condition and the direction. "Accuracy >95% for 2 weeks → replace with deterministic rules" is complete. "Accuracy >95%" alone is not.

## 5. Examples

Three decompositions. Full detail in `reference/example.md`.

### 5.1 PriceScope — pricing intelligence for e-commerce

| Node | Layer | Evolution | Metric / Signal | Graduation | Loop |
|------|-------|-----------|-----------------|------------|------|
| Price scraper | Enrichment | commodity | coverage 80%+ | coverage drops → build custom | N/A |
| Product matcher | Enrichment | custom | accuracy on test set | >95% stable → rules | autoresearch |
| Anomaly detector | Inference | custom | precision + recall | >10K SKUs → rules for known patterns | autoresearch |
| Price recommendation | Interpretation | **genesis** | acceptance rate | patterns repeat → auto-rules per category | manual review |
| Alert dispatcher | Delivery | product | fatigue rate <40% | fatigue >40% → reduce frequency | manual review |
| Dashboard | Delivery | product | usage frequency | 80% use only 2 views → cut the rest | N/A |

Genesis is in Interpretation. Two autoresearch nodes (product matcher, anomaly detector). The Interface captures signal through two surfaces: ignored alerts tune Inference, missing searches reveal Enrichment gaps.

### 5.2 TalentVoice — AI-augmented recruiting language

| Node | Layer | Evolution | Metric / Signal | Graduation | Loop |
|------|-------|-----------|-----------------|------------|------|
| Document ingester | Enrichment | commodity | ingestion success rate | new ATS breaks it → custom parser | N/A |
| Outcome linker | Enrichment | custom | linkage rate | >95% for an ATS → freeze connector | autoresearch |
| Bias pattern detector | Inference | custom | precision + recall | pattern universally known → blocklist | autoresearch |
| Rewrite recommendation | Interpretation | **genesis** | acceptance rate + outcome delta (30-90d) | >90% acceptance → auto-apply | manual review |
| Editor overlay | Delivery | product | time to action, dismissal rate | >50% auto-accepted → auto-apply | manual review |

Genesis is in Interpretation. Feedback is structurally slow (30-90 days). The moat is in Enrichment — the outcome linker is a data asset. The recruiter's edit before accepting a rewrite is the richest training signal in the system.

### 5.3 BrandLens — content governance and brand voice

| Node | Layer | Evolution | Metric / Signal | Graduation | Loop |
|------|-------|-----------|-----------------|------------|------|
| Content collector | Enrichment | commodity | coverage, freshness | no API → custom scraper | N/A |
| Style guide encoder | Enrichment | custom | rule coverage, conflict rate | conflicts at zero → stable | manual review |
| Compliance scorer | Inference | product | accuracy vs experts, FP rate | FP >15% → simplify rules | autoresearch |
| Consistency analyzer | Inference | **genesis** | cross-channel variance, drift latency | stable 6mo → reduce monitoring | autoresearch (weekly) |
| Writer guidance | Delivery | product | time to correction, acceptance rate | pass rate >95% → advisory mode | manual review |
| Governance dashboard | Delivery | product | usage frequency, drift response time | 80% use only 2 views → cut the rest | N/A |

Genesis is in Inference. Two autoresearch loops at different speeds. The Interface is densest in writer guidance (3 signal types) and governance dashboard (2 signal types).

### What the examples show together

| Pattern | PriceScope | TalentVoice | BrandLens |
|---------|-----------|-------------|-----------|
| Genesis layer | Interpretation | Interpretation | Inference |
| Feedback speed | days | 30-90 days | weekly |
| Enrichment | commodity | strategic asset | mixed |
| Autoresearch nodes | 2 (both fast) | 2 (not the genesis) | 2 (different speeds) |
| Interface signal density | 2 surfaces, 3 types | 1 surface, 2 types | 2 surfaces, 5 types |

Genesis is not always in the same layer. Autoresearch helps where feedback is fast, but the most valuable node often has the slowest feedback. A product whose Interface captures no signal builds no World Model.

## 6. References

- **Wardley, S.** Value chain mapping and evolution. Genesis-to-commodity axis, build-vs-buy decisions.
- **Choudary, S. P.** Platform dynamics and AI-driven industry restructuring. Where value accumulates when intelligence is a commodity input.
- **Karpathy, A.** Autoresearch. One mutable file, one metric, fixed time budget, git as keep/discard.
- **Cortés, D. & Lütke, T.** pi-autoresearch. Confidence scoring, backpressure checks, multi-metric tracking. Work nobody would attempt manually.
- **Dorsey, J.** From hierarchy to intelligence. The company as an intelligence: capabilities, interfaces, World Model. The compound loop where every interaction deepens understanding.

## License

MIT
