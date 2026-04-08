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
    │   the real game is to change the game         │
    │                                               │
    │   enrichment ── inference ──┐                  │
    │                             │                  │
    │              interpretation ─── delivery       │
    │                                               │
    │   data in ·········· value out                │
    │                                               │
    └───────────────────────────────────────────────┘
```

A Claude Code plugin that decomposes intelligence-era products into a value chain, identifies where the real value sits, and produces structured context that tells both people and agents where to invest effort.

```bash
claude plugin marketplace add Play-New/playbook
```

---

## 1. The problem

The architecture of most software products does not reflect that intelligence is now a commodity input. Teams ship dashboards, CRUD, and forms — the same things they shipped a decade ago, just faster. The question "how do I build this?" has a cheap answer. The question "where does the intelligence go, and what is it worth?" does not.

Three failure modes recur:

1. **Building commodity as custom.** Teams invest engineering effort in components that exist as services. Embedding search, document parsing, notification routing — these are solved problems. Building them is waste.
2. **No inference layer.** The product collects data and presents it, but never asks what patterns, predictions, or anomalies live inside it. The intelligence layer is absent.
3. **No way to know if it works.** The most valuable component — the one that creates the product's reason to exist — has no metric, no signal, no way to tell if it is improving or degrading.

## 2. The model

Every intelligence-era product moves data from raw input to user value through four layers:

| Layer | Role | Example |
|-------|------|---------|
| **Enrichment** | Where data enters. Normalizes inputs from every channel the user already uses. | Price scraping, document parsing, voice transcription |
| **Inference** | Pattern detection, prediction, anomaly flagging. The compute is cheap; knowing what questions to ask is not. | Anomaly detection, matching, classification |
| **Interpretation** | Turns raw inference into something a person can act on. "Anomaly score 0.87" means nothing. "Orders dropped 30%, likely budget freeze, renewal in 45 days" is an insight. | Recommendations, explanations, suggested actions |
| **Delivery** | Returns the right insight through the right channel at the right moment. The critical design choice is timing. | Push notifications, digests, dashboards, agent responses |

Playbook decomposes a product into **nodes**, each belonging to exactly one layer. Every node carries five fields:

| Field | What it captures |
|-------|-----------------|
| **Layer** | Enrichment, inference, interpretation, or delivery |
| **Evolution** | Where the node sits on the Wardley axis: genesis (new, uncertain — invest here), custom (understood but not standardized), product (multiple approaches exist), commodity (buy it) |
| **Metric / Signal** | What you measure and the target. Metric for things with fast, automatic feedback (accuracy, precision, latency). Signal for things requiring human observation (acceptance rate, fatigue, time to action) |
| **Graduation** | When to change approach AND what to change to. Both the condition and the direction. "Accuracy >95% for 2 weeks: replace with deterministic rules" is complete. "Accuracy >95%" is not — it says when but not where to go |
| **Loop** | Whether the node can be optimized automatically (autoresearch), requires human judgment (manual review), or is commodity (N/A) |

The decomposition is then challenged. A pitch that says "we'll build a RAG system" gets: RAG is how, what is the what? A brief with six features but no inference layer gets: where are the patterns? A commodity node built custom gets: this exists as a service, buy it. No genesis nodes gets: where are you creating new value?

## 3. The method

Playbook operates in three phases. Each is a command; together they form a cycle.

### 3.1 Strategy (`/playbook:strategy`)

Takes any input — a raw brief, a pitch deck, an idea in conversation, an existing codebase. Reads what exists, researches the problem space (searching for what would make the brief *wrong*, not for confirmation), and produces the decomposition.

Two outputs. A **strategic assessment** for the people deciding: where the value is, where the risk is, what to do first, what not to do. And a **CLAUDE.md** for the agents building: structured context that says exactly which nodes are genesis (invest here), which are commodity (buy, don't build), what to measure, and when to change approach.

This is context engineering. If an AI agent reads the CLAUDE.md tomorrow with zero prior knowledge, it knows where to invest effort and where not to. Stale context is worse than no context, so the document is treated as a living artifact, not a one-time deliverable.

### 3.2 Build (`/playbook:build`)

Starts with a vision conversation: what does the user experience when this product is perfect? Then encodes that vision as tests before writing any product code. The test suite *is* the plan — it tracks progress and gates quality.

For nodes marked "autoresearch" in the mapping, build sets up an automated optimization loop based on Karpathy's framework:

1. **One mutable file.** The agent can only change one file per node (prompt, config, or logic). Everything else is frozen. This prevents the agent from changing the evaluation to make the metric look better.
2. **One metric.** Computed automatically against an evaluation set. One number, no ambiguity.
3. **Fixed time budget.** Each experiment completes within a fixed window, making experiments comparable.
4. **Git as keep/discard.** `git commit` when the metric improves. `git reset --hard` when it doesn't. Improvements accumulate. Failures vanish.

An Enrichment node matching products to SKUs can run 12 experiments per hour this way. An Interpretation node generating pricing recommendations cannot — the signal (did the seller accept it?) takes days. The mapping captures this distinction explicitly.

### 3.3 Review (`/playbook:review`)

Measures the product against the mapping. For each node: is the metric above, at, or below target? Has a graduation trigger fired? For autoresearch nodes: is the loop converging, diverging, or not set up? For the mapping as a whole: does it still match the product?

When a node is below target and has an autoresearch loop, review doesn't just report — it runs an optimization cycle. The system improves itself where it can.

Two skills fire automatically between explicit commands. **Playbook awareness** activates during planning: does this change serve a node? Is the evolution classification still accurate? Has a graduation trigger fired? **Build awareness** activates during implementation: does this code trace to a node? Does it change what the CLAUDE.md says about the product?

### 3.4 Graduation

Nothing in the mapping is permanent. Nodes evolve in both directions:

- **Up.** A simple approach hits limits, edge cases justify complexity. A rules-based classifier needs a model.
- **Down.** Patterns stabilize, what was experimental becomes routine. A model-based classifier becomes a lookup table.

Each node documents both the condition ("when accuracy exceeds 95% for 2 weeks") and the direction ("replace with deterministic rules"). A trigger without a direction is incomplete.

## 4. Example

A pricing intelligence tool for e-commerce sellers. Full decomposition in `reference/example.md`.

| Node | Layer | Evolution | Metric / Signal | Graduation | Loop |
|------|-------|-----------|-----------------|------------|------|
| Price scraper | Enrichment | commodity | coverage 80%+ | if coverage drops, build custom | N/A (buy) |
| Product matcher | Enrichment | custom | accuracy on test set | >95% stable: switch to rules | autoresearch |
| Anomaly detector | Inference | custom | precision + recall | >10K SKUs: rules for known patterns | autoresearch |
| Price recommendation | Interpretation | genesis | acceptance rate | patterns repeat: auto-rules per category | manual review |
| Alert dispatcher | Delivery | product | fatigue rate <40% | fatigue >40%: reduce frequency | manual review |

The genesis node — price recommendation — is where the product creates value that doesn't exist elsewhere. Two nodes (product matcher, anomaly detector) have clean metrics and fast feedback: autoresearch applies directly. One node (price scraper) is commodity: dozens of services exist, building it is waste. The mapping makes these distinctions explicit and actionable.

## 5. References

- **Wardley, S.** Value chain mapping and evolution. The foundation for positioning components on the genesis-to-commodity axis and making build-vs-buy decisions based on evolutionary stage rather than intuition.
- **Choudary, S. P.** Platform dynamics and AI-driven industry restructuring. The lens for understanding how intelligence as a commodity input changes where value accumulates in a product.
- **Karpathy, A.** Autoresearch: automated experimentation with one mutable file, one metric, fixed time budget, and git as keep/discard mechanism. The operational model for nodes with clean metrics and fast feedback.

## License

MIT
