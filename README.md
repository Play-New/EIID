```
    ███████╗██╗██╗██████╗
    ██╔════╝██║██║██╔══██╗
    █████╗  ██║██║██║  ██║
    ██╔══╝  ██║██║██║  ██║
    ███████╗██║██║██████╔╝
    ╚══════╝╚═╝╚═╝╚═════╝
```

A Claude Code plugin that answers one question: **where is the value in your product?**

```bash
claude plugin marketplace add Play-New/EIID
```

---

## The problem

AI made it cheap to write code. It did not make it cheap to know what to build.

Most AI-assisted products are the same software we built in 2015, typed faster. Same dashboards, same CRUD, same forms. The architecture does not reflect that intelligence is now a commodity input.

The hard question is not "how do I build this?" It is "where does the intelligence go, and what is it worth?"

## What EIID does

Every intelligence-era product moves data from raw input to user value through four layers:

```
ENRICHMENT         where data enters
INFERENCE          patterns, predictions, anomalies
INTERPRETATION     raw signals become actionable insight
DELIVERY           the right insight, right channel, right moment
```

EIID decomposes your product into **nodes** across these layers. For each node, five fields:

```
Value expected
  |
  +-- Node
  |     |-- Layer           enrichment / inference / interpretation / delivery
  |     |-- Evolution       genesis / custom / product / commodity
  |     |-- Metric          what you measure, what the target is
  |     |-- Graduation      when to change approach
  |     +-- Loop            autoresearch / manual review / N/A
  |
  +-- Node
  |     |-- ...
  |
  +-- Node
        |-- ...
```

Then it challenges what it finds. A pitch that says "we'll build a RAG system" gets the question: RAG is how, what is the what? A brief with six features but no inference layer gets: where are the patterns? A commodity node built custom gets: this exists as a service, buy it.

The output is a CLAUDE.md that any AI agent can read and know exactly where to invest effort.

## How it works

Give it anything: a raw brief, a pitch deck, an idea in conversation, an existing codebase. The plugin reads what you have, researches the problem space, and produces the decomposition.

| Command | What it does |
|---------|------|
| `/eiid:strategy` | Decomposes the product into nodes. Challenges assumptions. Identifies which nodes can be automatically optimized. Outputs CLAUDE.md. |
| `/eiid:build` | Vision conversation, tests that encode it, autonomous construction. Sets up optimization loops for eligible nodes. |
| `/eiid:review` | Measures each node against its metric. Checks whether the CLAUDE.md still reflects reality. |

Two skills fire automatically during work. **EIID awareness** catches misalignment during planning. **Build awareness** checks traceability during implementation.

## Three ideas that matter

**Context engineering.** Every output of this plugin is structured context for AI agents. When an agent reads the CLAUDE.md, it knows which nodes are genesis (invest here), which are commodity (buy, don't build), what to measure, and when to change approach. Stale context is worse than no context, so review checks fidelity: does the document still match the product?

**Autoresearch.** Some nodes have clean metrics and fast feedback. An Enrichment node matching products to SKUs can run 12 experiments per hour: change the prompt, measure accuracy, keep or discard. An Interpretation node generating pricing recommendations cannot, because the signal (did the seller accept it?) takes days. The plugin marks each node with its loop type so you know where automated optimization works and where it doesn't.

**Graduation.** Nothing is permanent. A node that started as a quick experiment graduates to a robust system when volume demands it. A node that started complex graduates down to simple rules when patterns stabilize. Each node documents the trigger that says when.

## What gets generated

```
your-project/
  CLAUDE.md         strategic context — where the value is (stable)
  .eiid/
    report.md       operational state — metrics, decisions, test results (volatile)
```

Two files. CLAUDE.md is the strategy. Report is the current state. No duplication between them.

## Example

A pricing intelligence tool for e-commerce sellers (full example in `reference/example.md`):

| Node | Layer | Evolution | Metric | Graduation | Loop |
|------|-------|-----------|--------|------------|------|
| Price scraper | Enrichment | commodity | coverage 80%+ | if coverage drops, build custom | N/A (buy) |
| Product matcher | Enrichment | custom | accuracy on test set | >95% stable: switch to rules | autoresearch |
| Anomaly detector | Inference | custom | precision + recall | >10K SKUs: rules for known patterns | autoresearch |
| Price recommendation | Interpretation | genesis | acceptance rate | patterns repeat: auto-rules per category | manual review |
| Alert dispatcher | Delivery | product | fatigue rate <40% | fatigue >40%: reduce frequency | manual review |

The genesis node (price recommendation) is where the value is. Two nodes run automated optimization loops. One node is commodity: buy it, don't build it.

## References

Wardley (value chain evolution), Choudary (platform dynamics, AI-driven restructuring), Karpathy (autoresearch: automated experimentation loop).

## Install

```bash
claude plugin marketplace add Play-New/EIID
```

Update: `claude plugin marketplace update EIID`

## License

MIT
