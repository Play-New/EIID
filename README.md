```
     ______  _____  _____  ____
    |  ____||_   _||_   _||  _ \
    | |__     | |    | |  | | | |
    |  __|    | |    | |  | | | |
    | |____  _| |_  _| |_ | |_| |
    |______||_____||_____||____/

    E N R I C H M E N T
    I N F E R E N C E
    I N T E R P R E T A T I O N
    D E L I V E R Y
```

Decompose intelligence-era products into value chains. Know where to invest.

```bash
claude plugin marketplace add Play-New/EIID
```

```bash
claude plugin install eiid
```

Update: `claude plugin marketplace update EIID`

Auto-update: run `/plugin` in Claude Code, select `EIID` under Marketplaces, enable auto-update.

---

## What this does

Takes any input — a raw brief, a pitch deck, an idea in conversation, an existing codebase — and decomposes it into an EIID value chain. For each node: what EIID layer it serves, how evolved it is, what to measure, when to change approach, and whether it can be optimized automatically.

Then it challenges your assumptions. Commodity treated as custom? Buy it. Genesis treated as obvious? Validate it first. No delivery layer? How does the value reach the user?

The output is structured context: a CLAUDE.md that any AI agent can read and know exactly where the value is in your product.

## EIID

```
 ENRICHMENT       collect + normalize
 INFERENCE        detect, predict, flag
 INTERPRETATION   insights + framing
 DELIVERY         channels + triggers
```

Every component (node) of the product traces to one layer. Each node carries: evolution (genesis to commodity), a metric or signal, a graduation trigger, and a loop type (autoresearch for automated optimization, manual review, or N/A).

## How it works

3 commands, 2 advisory skills, 1 hook.

| Command | What it does |
|---------|------|
| `/eiid:strategy` | Decomposes the product into EIID nodes. Challenges assumptions. Identifies autoresearch candidates. Outputs CLAUDE.md. |
| `/eiid:build` | Vision conversation, tests that encode it, autonomous construction. Sets up autoresearch loops for eligible nodes. |
| `/eiid:review` | Measures metrics per node, evaluates autoresearch convergence, checks context fidelity, security basics. |

Strategy first. Build constructs. Review measures. Context stays faithful to reality.

Two skills fire automatically. **EIID awareness** checks alignment during planning. **Build awareness** checks traceability during implementation.

One hook guards boundaries. **Session integrity** warns when strategy exists but supporting files are missing.

## What gets generated

```
your-project/
  CLAUDE.md                 strategic context document
  .eiid/
    decisions.md            non-obvious choices (append-only)
    report.md               metrics per node (replaced each review)
    build-plan.md           test suite from the vision
```

## Key concepts

**Context engineering** — every output is structured context for AI agents. If an agent reads CLAUDE.md, it knows where the value is, what to build, what to measure, when to change approach.

**Autoresearch** — for nodes with clean metrics and fast feedback (typically Enrichment and Inference), the automated optimization loop: change, measure, keep or discard.

**Graduation** — nodes evolve. Start simple, graduate up when edge cases justify complexity, graduate down when patterns stabilize.

## References

Strategic thinking draws from Wardley (value chain evolution), Choudary (platform dynamics), Walker (context engineering as the new knowledge problem), Karpathy (autoresearch loop for automated optimization).

## License

MIT
