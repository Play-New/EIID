# Build Readiness Guide

Three gates before `/super:build` starts construction. All must pass. Each gate has a clear fix if it fails.

## Strategy Gate

Read CLAUDE.md. Check for:

1. **EIID mapping exists** with all four layers (Enrichment, Inference, Interpretation, Delivery)
2. **Each layer has an Approach field** with strategic classification (automate/differentiate/innovate) and implementation level (code/buy/LLM call/workflow/agent)
3. **User need is defined** — not features, an outcome
4. **Technology Constraints exist** — detected from package.json or recommended

**Pass:** all four checks true.
**Fail:** tell the user which items are missing. "Run `/super:strategy` to complete the mapping." If the mapping exists but Approach fields are missing, it may be an older format — suggest a refresh.

## Stack Gate

Read package.json. Check for:

1. **Framework installed** — the framework listed in CLAUDE.md Stack section is in dependencies
2. **Core dependencies installed** — database client, UI library (if visual layers), test runner
3. **Package manager matches** — lock file matches the constraint in CLAUDE.md (pnpm-lock.yaml if constraint says pnpm)
4. **Scripts present** — at minimum: dev, build, test

**Pass:** all four checks true.
**Fail:** install what's missing. Use the package manager from constraints. Run `[pm] install` for missing dependencies. Add missing scripts to package.json. After installation, re-check.

If no package.json exists at all (truly new project):
1. Run `[pm] init` (package manager from CLAUDE.md constraints, default to npm if none specified)
2. Install the stack from CLAUDE.md
3. Configure the framework (e.g., `npx create-next-app` with the right options)
4. Re-run the gate

## Design Gate

Only applies if `.superskills/design-system.md` exists AND has an EIID Interface Map with at least one layer mapped to visual modality.

Read `.superskills/design-system.md`. Check for:

1. **Direction section** — feel, domain concepts, signature, rejected defaults
2. **Typography Scale section** — at least Display, H1, Body, and Caption levels defined
3. **Tokens section** — spacing base, scale, radius, color primitives
4. **Layout section** — grid, breakpoints, container strategy (needed for layout shell)

**Pass:** all four checks true, OR no visual layers exist.
**Fail:** tell the user which sections are missing. "Run `/super:design` to complete the design system." If the design system exists but is partial, point to the specific missing sections.

## Setup Checklist (human prerequisites)

Some things the human must do before the build loop can be autonomous. Check once at the start of init mode:

### Always needed
- [ ] Git repo initialized
- [ ] Package manager available (`npm`/`pnpm`/`yarn`/`bun` on PATH)
- [ ] Node.js installed (check `node --version`)

### If using Supabase
- [ ] Supabase project created (check for `supabase/config.toml` or ask)
- [ ] `SUPABASE_URL` and `SUPABASE_ANON_KEY` in `.env.local`
- [ ] Supabase CLI available (`supabase --version`)

### If using Vercel
- [ ] Vercel project linked (check for `.vercel/project.json` or ask)
- [ ] `VERCEL_TOKEN` available for CLI deploys (optional, manual deploy is fine)

### If using external APIs (WhatsApp, Slack, email services)
- [ ] API keys in `.env.local` for each service in the EIID mapping
- [ ] Webhook URLs configured (or note that they'll need configuration after deploy)

### If using LLM calls, workflows, or agents
- [ ] LLM provider API key in `.env.local` (ANTHROPIC_API_KEY, OPENAI_API_KEY, etc.)
- [ ] Budget awareness: estimated monthly cost from strategy step 5b

For each missing prerequisite, tell the user what they need to do. The build loop does not proceed until prerequisites are met. These are one-time setup tasks — once done, the loop handles everything else.
