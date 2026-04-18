# Concepts

Canonical definitions. Every concept defined once. Commands and skills reference this file.

---

## The Four Layers (EIID)

Four layers that structure every intelligence-era product. Value flows forward from raw data to user outcome; signal flows back from every interaction to earlier layers. Both flows are required — a product that only delivers and never observes builds no World Model, no matter how sophisticated its inference. Every component (node) traces to exactly one layer.

**Enrichment** — where data enters. Photos, voice notes, chat messages, forwarded emails, spreadsheets, APIs, scraped sources. People should not change how they work. Enrichment accepts data from every channel they already use and normalizes it for inference.

**Inference** — pattern detection, prediction, anomaly flagging. The compute is cheap. The hard part is knowing what questions to ask.

**Interpretation** — turns raw inference into something a person can act on. "Anomaly score 0.87" means nothing. "Orders dropped 30%, likely due to budget freeze, renewal in 45 days" is an insight. Context, comparison, explanation, recommended action.

**Delivery** — returns results through the channels people already use. Triggered by conditions: threshold crossed, schedule, event, user request. What makes Delivery part of an Interface — rather than a dead-end surface — is whether the channel also captures signal from how users respond (accept, ignore, modify, request-and-don't-get). The critical design choices are timing and what the surface observes.

## Node

A component of the product that belongs to exactly one layer. The unit of decomposition, analysis, measurement, and signal capture — every node either delivers value, generates signal for the World Model, or both. Each node carries five fields:

- **Layer** — which layer it serves
- **Evolution** — where it sits on the Wardley axis (genesis, custom, product, commodity)
- **Metric / signal** — what you measure and the target value
- **Graduation** — when to change approach and what to change to (condition + direction)
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

Automated optimization loop for nodes with a clear metric and fast feedback. Based on Karpathy's autoresearch framework, extended by Shopify (Cortés, Lütke).

Autoresearch does not do human work faster. It explores optimization spaces too large and tedious for humans to attempt. Small improvements of 1% compound over hundreds of iterations into results no human would find. Shopify tracked 40+ metrics across engineering teams and documented a 65% build speedup and 300x faster unit tests — optimizations that nobody would have searched for manually (see [shopify.engineering/autoresearch](https://shopify.engineering/autoresearch) and [github.com/davebcn87/pi-autoresearch](https://github.com/davebcn87/pi-autoresearch)).

The mechanism:

1. **One mutable file.** The agent can only change one file per node: the prompt, the config, or the logic file. Everything else is frozen. This prevents the agent from changing the evaluation to make the metric look better.
2. **One metric.** The node's metric from the playbook mapping, computed automatically against an evaluation set. One number, no ambiguity.
3. **Fixed time budget.** Each experiment must complete within a fixed time (evaluation included). This makes experiments comparable regardless of what the agent changed.
4. **Confidence scoring.** A single improvement means nothing. Each experiment runs 3+ times. Improvement is accepted only if statistically significant — Median Absolute Deviation separates real gains from noise.
5. **Backpressure checks.** After a benchmark passes, run correctness checks (tests, types, lint). If correctness breaks, reject the improvement even if the metric improved. The metric gets better AND the system stays correct.
6. **Git as keep/discard.** `git commit` when the improvement is both real (confidence) and correct (backpressure). `git reset --hard` when it isn't. Improvements accumulate. Failures vanish.
7. **Autonomous loop.** The agent reads the code, forms a hypothesis, makes one change, measures, validates, keeps or discards. No human in the loop. Runs until convergence (improvements < 1% over 10 experiments) or budget exhausted.

Works well on Enrichment and Inference nodes (clean metrics, fast evaluation). Partially applicable to Interpretation (prompt clarity, measurable against evaluation set).

The strategy identifies which nodes are autoresearch candidates. Build sets up the loop: creates the evaluation set, designates the mutable file, configures the metric. Review evaluates convergence and triggers cycles when a node is below target.

## Interface

The Interface is where Enrichment and Delivery coincide. It is not a layer. It is not a node. It is the surface where the product touches the user.

Every interaction through the Interface is simultaneously delivery (the product responds) and enrichment (the product learns). A recruiter editing a rewrite before accepting it is receiving value and generating the richest training signal in the system. A dashboard where a user searches for a competitor not yet tracked is delivering what exists and revealing what is missing.

When the Interface captures what users accept, ignore, modify, and ask for that doesn't exist, every interaction feeds Enrichment and Inference. When the Interface captures nothing, the product is blind to its own users.

When the Interface is both sensor and surface, it generates signal at the speed of customer interaction. The customer uses the product, the product observes the response, the observation feeds earlier layers. This shares the principle of autoresearch (observe, hypothesize, change, measure) but not its rigor. Sandbox autoresearch is controlled experimentation: one variable, confidence scoring, backpressure. Interface signal is observational: confounded variables, no controlled conditions, correlation not causation. Both are valuable. They are not the same thing. Sandbox autoresearch produces proof. Interface signal produces direction.

A static dashboard is product-stage — replaceable. A chatbot is also product-stage — Intercom, Drift, Zendesk prove it. What makes an interface genesis is not the form (visual, conversational, voice) but the composition: an interface that assembles responses from capabilities in real time, where no two interactions follow the same path, accumulates a World Model that a fixed-navigation interface cannot. When a customer asks for something the system can't compose from its capabilities, that gap is the roadmap. The judgment is whether filling it aligns with what the product should be.

## World Model

The World Model is the accumulated understanding of users built from every interaction that passes through the Interface. It is not a layer. It is not a field. It is the state that the product accumulates over time.

Concretely: in PriceScope, the World Model is the set of learned weights in the anomaly detector (tuned by which alerts got acted on), the coverage map in the price scraper (expanded by which searches returned nothing), and the category-specific recommendation patterns (refined by which suggestions sellers modified before accepting). No single table or model — it is distributed across nodes, accumulated from use. A competitor can replicate every node. They cannot replicate the state those nodes reached through 10,000 seller interactions.

Every capability in isolation is replicable. The World Model is not. It exists only because of the specific history of interactions that built it.

The strategic question is: does this product build a World Model? A product where every interaction deepens understanding compounds. A product that pushes value out and captures nothing back is replicable regardless of how sophisticated its inference is.

Scope matters: World Models accumulate per-user (churn resistance), per-org (account stickiness), aggregate (network effects / cold-start advantage), or as a layered mix. The strategy must name the scope — a World Model without a declared scope is designing the wrong defensibility.

## Graduation

Nodes evolve. When a metric consistently exceeds its target, simplify the implementation. When volume exceeds a threshold, make it more robust. Graduation goes both directions:

- **Up** — simple approach hits limits, edge cases justify complexity
- **Down** — patterns stabilize, what was experimental becomes routine

Each node documents its graduation trigger: both the condition (when) and the direction (what changes). "When accuracy exceeds 95% for 2 weeks, replace with deterministic rules" is a complete trigger. "When accuracy exceeds 95%" is not — it says when but not where to go.

## Regulatory posture

AI-native products built for the EU operate under GDPR (Regulation (EU) 2016/679) and the AI Act (Regulation (EU) 2024/1689, phased 2025-2027). Compliance is by-design: what you accumulate, at what scope, and what decisions the product makes are regulatory choices at strategy time, not launch time.

**AI Act role.** Provider (develops and markets the AI system under own name — Art 3(3)) or deployer (uses an AI system under its authority — Art 3(4)), or both. Building a SaaS on Claude/GPT/Gemini and shipping it under your own brand makes you provider of the resulting AI system and downstream provider of the GPAI-integrated system (Art 25, Art 53(1)(b)). Role determines which obligations apply — provider obligations are far heavier.

**AI Act tier.** Prohibited (Art 5, do not build), high-risk (Annex III: biometrics, critical infrastructure, education, employment/HR, essential private/public services, law enforcement, migration, justice — requires risk management, human oversight, transparency, accuracy docs, data governance, conformity assessment), limited-risk (Art 50 transparency for chatbots, deepfakes, emotion/biometric categorisation), minimal-risk (default). Misidentifying the tier is the most expensive mistake in the design space.

**GDPR basis.** The World Model is personal data processing and needs a lawful basis per Art 6 (consent, contract, legitimate interest with documented three-part test, legal obligation, vital interest, public task). Signal capture at the Interface is separate processing and may need its own basis. Special categories (Art 9) require stricter basis. Per-user World Model scope combined with decisions that have legal or similarly significant effects triggers Art 22 (right to human intervention).

**DPIA.** Required before large-scale profiling, special categories, systematic monitoring, innovative technology, or combinations thereof (Art 35 + EDPB/WP248 criteria) — which describes most high-risk AI Act products.

Compliance is part of the design space. Strategy produces a dedicated Regulatory Annex (`reference/regulatory-annex-template.md`) that cites articles, documents reasoning, and grounds findings in specific research — readable by legal counsel, updated with the state of the law at the date of analysis.

## Context Engineering

Every output of this plugin is structured context for AI agents. CLAUDE.md is the strategic context document of the product. If an agent reads it, it knows: where the value is, what the product accumulates from use (the World Model), what to build, what to measure, when to change approach.

Context must stay faithful to reality (context fidelity). When the product evolves, the context updates. Stale context is worse than no context — it leads agents to optimize the wrong things.

## Plugin World Model

The plugin is a product too, and it follows its own principle: user and plugin co-construct. Every strategy run, every build, every review leaves signal — what the user overrode, what challenges changed their plan, which research lenses produced nothing useful for a given domain, where CLAUDE.md drifted from reality. The plugin accumulates this into its own World Model, feeding future runs on similar projects.

This is not autoresearch — there is no controlled loop, no confidence scoring, no keep/discard. It is structured journaling that makes the next run better informed. But it embodies the same principle the plugin preaches: a tool that pushes value out and captures nothing back builds no World Model, and the playbook plugin is no exception.

What gets logged to `.playbook/report.md`:

- **Classification overrides** — user changed a node's evolution, layer, or loop. The override and the reasoning are recorded. Pattern: if "document ingester" is overridden to commodity in 10 consecutive projects, future runs should default to commodity for that archetype.
- **Challenge outcomes** — which challenge changed the user's plan, which was dismissed. Pattern: if "no inference layer" fires in 60% of projects and changes the plan 80% of the time, it is a high-value challenge.
- **Research failures** — which lens produced no useful signal for this domain. Pattern: if "graduation precedent" consistently fails for creative domains, skip it there.
- **Context drift** — what CLAUDE.md said versus what review found. Pattern: which types of nodes drift fastest.

The plugin reads prior reports when running strategy refresh or review. The compound loop is: strategy → build → review → strategy. Whether the logging produces useful signal is observable over time: if strategy refresh makes fewer mistakes that review catches, the loop is working.
