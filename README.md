```
 ____                       ____  _    _ _ _
/ ___| _   _ _ __   ___ _ _/ ___|| | _(_) | |___
\___ \| | | | '_ \ / _ \ '__\___ \| |/ / | | / __|
 ___) | |_| | |_) |  __/ |  ___) |   <| | | \__ \
|____/ \__,_| .__/ \___|_| |____/|_|\_\_|_|_|___/
             |_|
```

**Existing frameworks help you build faster. SuperSkills changes what you build.**

```bash
claude plugin marketplace add Play-New/superskills
```

```bash
claude plugin install super
```

4 commands. 3 advisory skills. 2 hooks. One architectural model that restructures every product around how intelligence flows from raw data to user value. If a component doesn't trace to that model, it doesn't get built.

---

## What this does

A sales rep sends a voice note on WhatsApp. At 9am the next day, they get back: "Acme Corp's order volume dropped 30% this month, likely due to their Q3 budget freeze. Renewal in 45 days. Here are three things to try."

No dashboard. No new interface to learn. The system meets people where they already work.

Most AI-assisted software is traditional software typed faster. Same forms, same CRUD, same dashboards. SuperSkills builds a different kind of product: one where intelligence is structural, delivered through existing channels, invisible to the user.

## EIID

Every AI-native product maps onto four layers:

```
 ENRICHMENT       collect + normalize
 INFERENCE        detect, predict, flag
 INTERPRETATION   insights + framing
 DELIVERY         channels + triggers
```

**Enrichment** accepts data from every channel people already use: photos, voice notes, emails, spreadsheets, chat messages. People should not change how they work.

**Inference** detects patterns, predicts, flags anomalies. The compute is cheap. The hard part is knowing what questions to ask.

**Interpretation** turns "anomaly score 0.87" into "orders dropped 30%, likely budget freeze, renewal in 45 days." Context, comparison, recommended action.

**Delivery** returns results through the same channels. Voice note in, WhatsApp answer out. The critical design choice is timing.

The web interface, when one exists, handles what messages cannot: charts, maps, timelines, and configuration of the invisible layer.

Every component carries a strategic classification (automate / differentiate / innovate) and an implementation level (LLM call / workflow / agent / code / buy). These are not permanent. Start simple, graduate up when edge cases justify complexity, graduate down when patterns stabilize.

## Commands

| Command | What it does |
|---------|------|
| `/super:strategy` | Understands the business context, researches the problem space, produces the EIID mapping with strategic classification and implementation levels. Outputs CLAUDE.md. |
| `/super:design` | Determines what needs a visual surface, conversational interface, or notification channel. Defines experience patterns across all modalities. For visual layers: direction, IA, typography, tokens. |
| `/super:build` | Asks what the product should do and when it's perfect. Challenges the vision, proposes the experience, writes tests that encode it, then builds autonomously until every test passes. |
| `/super:review` | Eight-domain audit: tests, security, build quality, strategy, experience, design, performance, agent architecture. |

Strategy before design. Design before build. Review anytime.

Three skills fire automatically during your work: **EIID awareness** (flags scope creep and stale mappings), **design awareness** (challenges whether changes earn their place), **build awareness** (checks every addition against rule zero).

Two hooks guard boundaries: **secrets guard** blocks hardcoded credentials on file write. **Session integrity** warns when strategy exists but supporting files are missing.

## What gets generated

```
your-project/
  CLAUDE.md                 stable instructions (~100 lines)
  .superskills/
    report.md               audit findings (replaced each review)
    decisions.md            architecture log (append-only)
    design-system.md        direction + tokens + patterns
    build-plan.md           test suite from the vision
```

## Three example products

`reference/examples/` contains complete outputs for three products across the spectrum:

**FleetPulse** (SaaS) — visual-heavy fleet management. All code/buy. Demonstrates EIID applies even without intelligence surfaces.

**RecipeBox** (Consumer) — WhatsApp-first recipe matching with agent conversation and web archive. Demonstrates graduation triggers and mixed modality.

**DepWatch** (DevTool) — CLI dependency risk analysis with a single LLM call. Demonstrates EIID applies to non-visual products.

## Stack

Strategy identifies which roles the project needs and recommends tools based on the EIID mapping, team context, and ecosystem. A CLI tool needs no framework. A WhatsApp bot needs a messaging library but no frontend. The mapping determines the roles.

## References

Strategic thinking draws from Wardley (value chain evolution), Choudary (platform dynamics, AI-driven restructuring), Steinberger (intelligence where the user works), and the SaaSpocalypse pattern (commodity layers collapse, value moves to orchestration and delivery).

## License

MIT
