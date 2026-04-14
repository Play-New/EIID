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

Value chain decomposition for intelligence-era products. A Claude Code plugin.

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
4. **Terminal delivery.** The product pushes value out but captures nothing back. It does not learn from the people using it.

## 2. The model

Four layers. Value flows from raw data to user outcome and signal flows back.

| Layer | Role |
|-------|------|
| **Enrichment** | Where data enters. Normalizes inputs from every channel the user already uses. |
| **Inference** | Pattern detection, prediction, anomaly flagging. The compute is cheap; knowing what questions to ask is not. |
| **Interpretation** | Turns raw inference into something a person can act on. Context, comparison, explanation, recommended action. |
| **Delivery** | Returns the right insight through the right channel at the right moment. Captures signal from how people respond. |

### The cycle

```
    Enrichment → Inference → Interpretation → Delivery
        ↑                                        │
        └──────── Feeds (backward signal) ────────┘
```

What the user accepts, ignores, modifies, or asks for and doesn't get flows back to the earlier layers. A dashboard where users search for a competitor not tracked → Enrichment (coverage gap). An alert consistently ignored → Inference (precision is wrong). A recommendation edited before acceptance → Interpretation (the edit shows what the system got wrong).

### The world model

The accumulated understanding of users built from every interaction. Every capability in isolation is replicable — card processing, document parsing, notification routing. The world model is not. It exists only because of the history of interactions that built it.

The product with the richest feedback loop builds the deepest world model. The deepest world model produces better responses. Better responses generate more use. The loop compounds.

### The interface question

Not "does it need a UI?" but **does the interface learn?**

A static dashboard is product-stage Delivery — replaceable. A conversational interface that composes itself from capabilities in real time is genesis-stage Delivery — it accumulates a world model. When a customer asks for something the system can't compose, that gap is the roadmap. The judgment is whether building it aligns with what the product should be.

### Nodes

Playbook decomposes a product into **nodes**, each belonging to exactly one layer. Six fields per node:

| Field | What it captures |
|-------|-----------------|
| **Layer** | Enrichment, inference, interpretation, or delivery |
| **Evolution** | Genesis (invest), custom (build), product (use existing), commodity (buy). A static dashboard is product. A composable interface is genesis. |
| **Metric / Signal** | Metric: fast, automatic feedback (accuracy, precision, latency). Signal: slow, human observation (acceptance rate, fatigue, time to action). |
| **Graduation** | When to change approach (trigger) and what to change to (direction). Both required. |
| **Loop** | Autoresearch (automated optimization), manual review (human judgment), N/A (commodity). |
| **Feeds** | Backward signal: which nodes this enriches through use, against the EIID direction. Every node that touches humans should declare this. `—` if terminal. |

Challenges during decomposition:

- "We'll build a RAG system" → RAG is how, what is the what?
- Six features, no inference → where are the patterns?
- Commodity built custom → this exists as a service
- No genesis nodes → where is the new value?
- Delivery with no Feeds → the product doesn't learn from use
- All capabilities, no compound loop → what gets smarter over time?

## 3. The method

Three commands. Together they form a cycle.

### 3.1 Strategy (`/playbook:strategy`)

Takes any input — brief, pitch, idea, codebase. Researches the problem space (searching for what would make the brief *wrong*, not for confirmation). Produces two outputs:

- **Strategic assessment** for people: where the value is, where the risk is, what to do first, what not to do.
- **CLAUDE.md** for agents: structured context — which nodes are genesis, which are commodity, what to measure, when to change approach, what signal flows back.

### 3.2 Build (`/playbook:build`)

Vision conversation first: what does the user experience when this product is perfect? Then tests that encode the vision before any product code. The test suite is the plan.

Two forms of autoresearch:

```
    Sandbox (Karpathy)                Production (through Delivery)

    agent changes one file            customer uses the interface
    run evaluation                    system composes response
    metric improves?                  customer got what they wanted?
      yes → commit                      yes → reinforce
      no  → reset                       no  → gap (roadmap signal)
    repeat until convergence          feeds back to other nodes
```

Sandbox autoresearch works where feedback is fast — a product matcher testing accuracy can run 12 experiments per hour. Production autoresearch runs at the speed of customer interaction — every use is an experiment.

### 3.3 Review (`/playbook:review`)

Measures the product against the mapping. For each node: metric above, at, or below target? Graduation trigger fired? Autoresearch converging or diverging? Feeds declared and implemented? Context still faithful to the actual product?

When a node is below target and has an autoresearch loop, review runs an optimization cycle directly.

### 3.4 Graduation

Nodes evolve in both directions:

- **Up.** Simple approach hits limits. Rules need a model.
- **Down.** Patterns stabilize. Model becomes a lookup table.

Each node documents both the condition and the direction. "Accuracy >95% for 2 weeks → replace with deterministic rules" is complete. "Accuracy >95%" alone is not.

## 4. Examples

Three decompositions. Full detail in `reference/example.md`.

### 4.1 PriceScope — pricing intelligence for e-commerce

| Node | Layer | Evolution | Metric / Signal | Graduation | Loop | Feeds |
|------|-------|-----------|-----------------|------------|------|-------|
| Price scraper | Enrichment | commodity | coverage 80%+ | coverage drops → build custom | N/A | — |
| Product matcher | Enrichment | custom | accuracy on test set | >95% stable → rules | autoresearch | — |
| Anomaly detector | Inference | custom | precision + recall | >10K SKUs → rules for known patterns | autoresearch | — |
| Price recommendation | Interpretation | **genesis** | acceptance rate | patterns repeat → auto-rules per category | manual review | user modifies recommendation before acting → recommendation quality |
| Alert dispatcher | Delivery | product | fatigue rate <40% | fatigue >40% → reduce frequency | manual review | ignored alerts → anomaly detector (precision), action timing → routing rules |
| Dashboard | Delivery | product | usage frequency | 80% use only 2 views → cut the rest | N/A | searches without results → price scraper (coverage gap), recommendation outcomes → price recommendation |

Genesis is in Interpretation. Two sandbox autoresearch nodes (product matcher, anomaly detector). Two Delivery sensors feeding signal back to Enrichment and Inference.

### 4.2 TalentVoice — AI-augmented recruiting language

| Node | Layer | Evolution | Metric / Signal | Graduation | Loop | Feeds |
|------|-------|-----------|-----------------|------------|------|-------|
| Document ingester | Enrichment | commodity | ingestion success rate | new ATS breaks it → custom parser | N/A | — |
| Outcome linker | Enrichment | custom | linkage rate | >95% for an ATS → freeze connector | autoresearch | — |
| Bias pattern detector | Inference | custom | precision + recall | pattern universally known → blocklist | autoresearch | — |
| Rewrite recommendation | Interpretation | **genesis** | acceptance rate + outcome delta (30-90d) | >90% acceptance → auto-apply | manual review | user edits rewrite before accepting → rewrite quality (the edit shows what was wrong) |
| Editor overlay | Delivery | product | time to action, dismissal rate | >50% auto-accepted → auto-apply | manual review | dismissed suggestions → bias detector (false positive) |

Genesis is in Interpretation. Feedback is structurally slow (30-90 days). The moat is in Enrichment — the outcome linker is a data asset. The recruiter's edit before accepting a rewrite is the richest training signal in the system.

### 4.3 BrandLens — content governance and brand voice

| Node | Layer | Evolution | Metric / Signal | Graduation | Loop | Feeds |
|------|-------|-----------|-----------------|------------|------|-------|
| Content collector | Enrichment | commodity | coverage, freshness | no API → custom scraper | N/A | — |
| Style guide encoder | Enrichment | custom | rule coverage, conflict rate | conflicts at zero → stable | manual review | — |
| Compliance scorer | Inference | product | accuracy vs experts, FP rate | FP >15% → simplify rules | autoresearch | — |
| Consistency analyzer | Inference | **genesis** | cross-channel variance, drift latency | stable 6mo → reduce monitoring | autoresearch (weekly) | — |
| Writer guidance | Delivery | product | time to correction, acceptance rate | pass rate >95% → advisory mode | manual review | corrections before flags → compliance scorer, rejected suggestions → style guide encoder, new patterns → consistency analyzer |
| Governance dashboard | Delivery | product | usage frequency, drift response time | 80% use only 2 views → cut the rest | N/A | drift alerts ignored → consistency analyzer, filter patterns → content collector |

Genesis is in Inference. Two autoresearch loops at different speeds. Writer guidance feeds 3 nodes, governance dashboard feeds 2. The Delivery layer is the densest sensor despite being product-stage.

### What the examples show together

| Pattern | PriceScope | TalentVoice | BrandLens |
|---------|-----------|-------------|-----------|
| Genesis layer | Interpretation | Interpretation | Inference |
| Feedback speed | days | 30-90 days | weekly |
| Enrichment | commodity | strategic asset | mixed |
| Autoresearch nodes | 2 (both fast) | 2 (not the genesis) | 2 (different speeds) |
| Delivery nodes with Feeds | 2 | 1 | 2 |
| Total nodes fed by Delivery | 3 | 1 | 5 |

Genesis is not always in the same layer. Autoresearch helps where feedback is fast, but the most valuable node often has the slowest feedback. A product where Delivery feeds no other node does not learn from use.

## 5. References

- **Wardley, S.** Value chain mapping and evolution. Genesis-to-commodity axis, build-vs-buy decisions.
- **Choudary, S. P.** Platform dynamics and AI-driven industry restructuring. Where value accumulates when intelligence is a commodity input.
- **Karpathy, A.** Autoresearch. One mutable file, one metric, fixed time budget, git as keep/discard.
- **Dorsey, J.** From hierarchy to intelligence. The company as an intelligence: capabilities, interfaces, proactive intelligence, world model. The compound loop where every interaction deepens understanding.

## License

MIT
