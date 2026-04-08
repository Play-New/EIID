---
name: stop-tests
description: Run tests before stopping. Block on failure. Write results to .eiid/report.md.
invocation: Available on demand. Not auto-invoked by hooks. Called by `/eiid:review` test section or directly as a subagent.
tools: Read, Glob, Grep, Write, Edit, Bash
---

Test verification gate. Run before task completion.

## Steps

1. Read package.json to detect the test runner and available test scripts. Run the project's unit/integration test suite.
2. Detect if browser-based tests exist (Playwright, Cypress, or equivalent). If present, run them.
3. If the project uses TypeScript, run type checking.
4. Write results to `.eiid/report.md` — **replace** the "### Test Results" section. Keep the last 3 runs for trend visibility. Drop older entries.

## Output Format

```
**Date:** [date] | **Passed:** [count] | **Failed:** [count] | **Skipped:** [count]
**Type errors:** [count or none]
[failure details with file:line if any]
```

## Gate

If any test fails, respond `{"ok": false, "reason": "X tests failing: [details]"}`.
If all tests pass, respond `{"ok": true}`.
