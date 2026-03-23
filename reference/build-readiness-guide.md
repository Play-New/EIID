# Build Readiness

Three gates before `/super:build` starts. All must pass.

## Strategy Gate

CLAUDE.md has an EIID mapping with Approach fields on all four layers. Each component has a strategic classification and implementation level.

Fail → "Run `/super:strategy` to complete the mapping."

## Stack Gate

package.json exists with the framework from CLAUDE.md installed. Package manager matches the constraint.

Fail → install what's missing from CLAUDE.md Stack section.

## Design Gate

Only if the EIID Interface Map has layers mapped to visual modality.

`.superskills/design-system.md` exists with Direction and Tokens sections.

Fail → "Run `/super:design` to complete the design system."
Skip → if no visual layers.

## Human Prerequisites

Check once at the start. These are things only the human can do:

- Service credentials in `.env.local` for each service in the EIID mapping
- Database project created and accessible (if applicable)
- LLM provider API key (if any EIID component uses LLM call/workflow/agent)

Missing → tell the user what to set up. Don't proceed without it.
