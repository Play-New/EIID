```
 ____                       ____  _    _ _ _
/ ___| _   _ _ __   ___ _ _/ ___|| | _(_) | |___
\___ \| | | | '_ \ / _ \ '__\___ \| |/ / | | / __|
 ___) | |_| | |_) |  __/ |  ___) |   <| | | \__ \
|____/ \__,_| .__/ \___|_| |____/|_|\_\_|_|_|___/
             |_|
```

A Claude Code plugin that restructures software around how intelligence flows from data to user value.

```bash
claude plugin marketplace add Play-New/superskills
```

```bash
claude plugin install super
```

Update: `claude plugin marketplace update superskills`

Auto-update: run `/plugin` in Claude Code, select `superskills` under Marketplaces, enable auto-update.

---

## What this does

Most AI-assisted software is traditional software typed faster. Same forms, same CRUD, same dashboards. The architecture could have been built in 2015.

SuperSkills builds a different kind of product. One where the system accepts a voice note on WhatsApp, detects that order volume dropped 30% compared to historical average, frames it as "likely due to Q3 budget freeze, renewal in 45 days," and delivers the insight back through WhatsApp before the next morning. No new interface to learn. The intelligence wraps around existing behavior.

The plugin enforces this through EIID, a four-layer model where every component traces to one layer. If it doesn't trace, it doesn't get built.

## EIID

```
 ENRICHMENT       collect + normalize
 INFERENCE        detect, predict, flag
 INTERPRETATION   insights + framing
 DELIVERY         channels + triggers
```

**Enrichment** accepts data from every channel people already use: photos, voice notes, emails, spreadsheets, chat messages. People should not change how they work.

**Inference** detects patterns, predicts, flags anomalies. The compute is cheap. Knowing what questions to ask is hard.

**Interpretation** turns "anomaly score 0.87" into "orders dropped 30%, likely budget freeze, renewal in 45 days." Raw inference becomes actionable insight through context, comparison, and a recommended action.

**Delivery** returns results through the same channels. Voice note in, WhatsApp answer out. The critical design choice is timing: an insight about a churning customer is worth nothing after the renewal date.

The web interface, when one exists, handles what messages cannot: charts, maps, timelines, and configuration of the invisible layer.

Every component carries a strategic classification (automate, differentiate, innovate) and an implementation level (LLM call, workflow, agent, code, buy). These levels are not permanent. Start simple, graduate up when edge cases justify complexity, graduate down when patterns stabilize. Each component documents its graduation trigger.

## How it works

4 commands, 3 advisory skills, 2 hooks.

| Command | What it does |
|---------|------|
| `/super:strategy` | Understands the business context, researches the problem space, produces the EIID mapping with strategic classification and implementation levels. Outputs CLAUDE.md. |
| `/super:design` | Determines what needs a visual surface, conversational interface, or notification channel. Defines experience patterns across all modalities. For visual layers: direction, IA, typography, tokens. |
| `/super:build` | Asks what the product should do and when it's perfect. Challenges the vision, proposes the experience, writes tests that encode it, builds autonomously until every test passes. |
| `/super:review` | Eight-domain audit: tests, security, build quality, strategy, experience, design, performance, agent architecture. |

Strategy before design. Design before build. Review anytime.

Three skills fire automatically during work. **EIID awareness** flags scope creep and stale mappings during planning. **Design awareness** challenges whether changes earn their place. **Build awareness** checks every addition against rule zero during implementation.

Two hooks guard boundaries. **Secrets guard** blocks hardcoded credentials on file write. **Session integrity** warns when strategy exists but supporting files are missing.

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

`reference/examples/` contains complete outputs for three products:

**FleetPulse** (SaaS). Vehicle fleet management, visual-heavy, dense operational data. All code/buy, no agents. Shows that EIID structures products even without intelligence surfaces.

**RecipeBox** (Consumer). Recipe matching from pantry photos. WhatsApp for input and delivery, web archive for browsing, agent for conversation. Shows graduation triggers and mixed modality design.

**DepWatch** (DevTool). Dependency update risk analysis. CLI only, no visual UI. A single LLM call for interpretation with a graduation trigger to template when patterns stabilize across 50+ summaries. Shows that EIID applies to non-visual products.

## Stack

Strategy identifies which roles the project needs and recommends tools based on the EIID mapping, team context, and current ecosystem. A CLI tool needs no framework. A WhatsApp bot needs a messaging library but no frontend. The mapping determines the roles.

## References

Strategic thinking draws from Wardley (value chain evolution), Choudary (platform dynamics, AI-driven restructuring), Steinberger (intelligence where the user works), and the SaaSpocalypse pattern where commodity layers collapse and value moves to orchestration and delivery.

## License

MIT
