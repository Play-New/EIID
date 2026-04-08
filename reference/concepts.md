# Concepts

Canonical definitions. Every concept defined once. Commands and skills reference this file.

---

## EIID

Four layers that structure every intelligence-era product. Value flows from raw data to user outcome. Every component (node) traces to exactly one layer.

**Enrichment** — where data enters. Photos, voice notes, chat messages, forwarded emails, spreadsheets, APIs, scraped sources. People should not change how they work. Enrichment accepts data from every channel they already use and normalizes it for inference.

**Inference** — pattern detection, prediction, anomaly flagging. The compute is cheap. The hard part is knowing what questions to ask.

**Interpretation** — turns raw inference into something a person can act on. "Anomaly score 0.87" means nothing. "Orders dropped 30%, likely due to budget freeze, renewal in 45 days" is an insight. Context, comparison, explanation, recommended action.

**Delivery** — returns results through the channels people already use. Triggered by conditions: threshold crossed, schedule, event, user request. The critical design choice is timing. The web interface, when one exists, serves what messages cannot: visualizations that need space and configuration of the invisible layer. It is not the primary input surface.

## Node

A component of the product that belongs to exactly one EIID layer. The unit of decomposition, analysis, and measurement. Each node carries five fields:

- **Layer** — which EIID layer it serves
- **Evolution** — where it sits on the Wardley axis (genesis, custom, product, commodity)
- **Metric / signal** — what you measure and the target value
- **Graduation** — when to change approach (trigger condition)
- **Loop** — whether the node is optimizable automatically or requires human judgment

## Evolution

Four stages on the Wardley axis. Each carries strategic meaning for the node.

- **Genesis** — new, uncertain, no established approach. This is where you create value. Invest here.
- **Custom** — understood in your domain but not standardized. Build it, but expect it to evolve.
- **Product** — well-understood, multiple approaches exist. Use existing solutions, adapt to your context.
- **Commodity** — standardized, many providers. Buy it. Building commodity is waste.

## Metric vs Signal

**Metric** — measurable automatically with fast feedback. Accuracy, precision, recall, latency, coverage, cost per unit. Enables autoresearch: change the implementation, measure, keep or discard. Typical of Enrichment and Inference nodes.

**Signal** — observable by humans with slow feedback. Acceptance rate, time to action, satisfaction, fatigue rate. Requires manual review. Typical of Interpretation and Delivery nodes.

Every node has one or the other. A node with neither metric nor signal is flying blind.

## Autoresearch

For nodes with a clear metric and fast feedback: the automated optimization loop. Change the implementation (prompt, parameters, logic), measure the metric, keep if improved, discard if not. Repeat.

Works well on Enrichment and Inference nodes. Partially applicable to Interpretation (prompt clarity optimization). Not applicable to Delivery (feedback too slow, quality multi-dimensional).

The strategy identifies which nodes are autoresearch candidates. Build sets up the loop. Review evaluates convergence and triggers optimization cycles when a node is below target.

## Graduation

Nodes evolve. When a metric consistently exceeds its target, simplify the implementation. When volume exceeds a threshold, make it more robust. Graduation goes both directions:

- **Up** — simple approach hits limits, edge cases justify complexity
- **Down** — patterns stabilize, what was experimental becomes routine

Each node documents its graduation trigger: both the condition (when) and the direction (what changes). "When accuracy exceeds 95% for 2 weeks, replace with deterministic rules" is a complete trigger. "When accuracy exceeds 95%" is not — it says when but not where to go.

## Context Engineering

Every output of this plugin is structured context for AI agents. CLAUDE.md is the strategic context document of the product. If an agent reads it, it knows: where the value is, what to build, what to measure, when to change approach.

Context must stay faithful to reality (context fidelity). When the product evolves, the context updates. Stale context is worse than no context — it leads agents to optimize the wrong things.
