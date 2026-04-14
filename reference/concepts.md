# Concepts

Canonical definitions. Every concept defined once. Commands and skills reference this file.

---

## The Four Layers (EIID)

Four layers that structure every intelligence-era product. Value flows from raw data to user outcome. Every component (node) traces to exactly one layer.

**Enrichment** — where data enters. Photos, voice notes, chat messages, forwarded emails, spreadsheets, APIs, scraped sources. People should not change how they work. Enrichment accepts data from every channel they already use and normalizes it for inference.

**Inference** — pattern detection, prediction, anomaly flagging. The compute is cheap. The hard part is knowing what questions to ask.

**Interpretation** — turns raw inference into something a person can act on. "Anomaly score 0.87" means nothing. "Orders dropped 30%, likely due to budget freeze, renewal in 45 days" is an insight. Context, comparison, explanation, recommended action.

**Delivery** — returns results through the channels people already use AND captures signal from how people respond. Triggered by conditions: threshold crossed, schedule, event, user request. The critical design choice is timing. Every delivery surface is also a sensor: what the user accepts, ignores, modifies, or asks for that doesn't exist is signal that feeds back into other layers. A conversational interface that composes itself from capabilities in real time captures richer signal than a static navigation — and creates a compound loop where every interaction makes the product more intelligent.

## Node

A component of the product that belongs to exactly one layer. The unit of decomposition, analysis, and measurement. Each node carries six fields:

- **Layer** — which layer it serves
- **Evolution** — where it sits on the Wardley axis (genesis, custom, product, commodity)
- **Metric / signal** — what you measure and the target value
- **Graduation** — when to change approach and what to change to (condition + direction)
- **Loop** — whether the node is optimizable automatically or requires human judgment
- **Feeds** — which other nodes this node enriches through use, and with what signal. Every Delivery node should declare this. Enrichment and Inference nodes may also feed each other. A node with no feeds is terminal — value flows out but nothing comes back. A node that feeds others creates a compound loop where the product improves from use.

## Evolution

Four stages on the Wardley axis. Each carries strategic meaning for the node.

- **Genesis** — new, uncertain, no established approach. This is where you create value. Invest here.
- **Custom** — understood in your domain but not standardized. Build it, but expect it to evolve.
- **Product** — well-understood, multiple approaches exist. Use existing solutions, adapt to your context.
- **Commodity** — standardized, many providers. Buy it. Building commodity is waste.

Evolution applies to every layer, including Delivery. A static dashboard is product. A conversational interface that composes itself from capabilities in real time — where the customer asks for something that doesn't exist and the system assembles it — is genesis. The difference matters: a product-stage interface is replaceable, a genesis-stage interface that accumulates a world model from every interaction is a compound moat.

## Metric vs Signal

**Metric** — measurable automatically with fast feedback. Accuracy, precision, recall, latency, coverage, cost per unit. Enables autoresearch: change the implementation, measure, keep or discard. Typical of Enrichment and Inference nodes.

**Signal** — observable by humans with slow feedback. Acceptance rate, time to action, satisfaction, fatigue rate. Requires manual review. Typical of Interpretation and Delivery nodes.

Every node has one or the other. A node with neither metric nor signal is flying blind.

## Autoresearch

Automated optimization loop for nodes with a clear metric and fast feedback. Based on Karpathy's autoresearch framework.

The mechanism has five fixed parts:

1. **One mutable file.** The agent can only change one file per node: the prompt, the config, or the logic file. Everything else is frozen. This prevents the agent from changing the evaluation to make the metric look better.
2. **One metric.** The node's metric from the playbook mapping, computed automatically against an evaluation set. One number, no ambiguity.
3. **Fixed time budget.** Each experiment must complete within a fixed time (evaluation included). This makes experiments comparable regardless of what the agent changed.
4. **Git as keep/discard.** `git commit` when the metric improves (new baseline). `git reset --hard` when it doesn't (clean revert). Improvements accumulate. Failures vanish.
5. **Autonomous loop.** The agent reads the code, forms a hypothesis, makes one change, measures, keeps or discards. No human in the loop. Runs until convergence or budget exhausted.

Works well on Enrichment and Inference nodes (clean metrics, fast evaluation). Partially applicable to Interpretation (prompt clarity, measurable against evaluation set).

A second form of autoresearch operates in production through Delivery. When an interface captures user behavior — what they accept, ignore, modify, or request — that signal flows back to other nodes and optimizes them continuously. The customer is the agent, the interface is the mutable surface, the usage is the measurement. This is not a sandbox experiment — it is the product improving itself through use. Delivery nodes that feed other nodes are running autoresearch at the speed of customer interaction.

The strategy identifies which nodes are autoresearch candidates. Build sets up the loop: creates the evaluation set, designates the mutable file, configures the metric. Review evaluates convergence and triggers cycles when a node is below target.

## Graduation

Nodes evolve. When a metric consistently exceeds its target, simplify the implementation. When volume exceeds a threshold, make it more robust. Graduation goes both directions:

- **Up** — simple approach hits limits, edge cases justify complexity
- **Down** — patterns stabilize, what was experimental becomes routine

Each node documents its graduation trigger: both the condition (when) and the direction (what changes). "When accuracy exceeds 95% for 2 weeks, replace with deterministic rules" is a complete trigger. "When accuracy exceeds 95%" is not — it says when but not where to go.

## Context Engineering

Every output of this plugin is structured context for AI agents. CLAUDE.md is the strategic context document of the product. If an agent reads it, it knows: where the value is, what to build, what to measure, when to change approach.

Context must stay faithful to reality (context fidelity). When the product evolves, the context updates. Stale context is worse than no context — it leads agents to optimize the wrong things.
