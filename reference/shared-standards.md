# Shared Standards

Building blocks that every project needs and that should work identically every time. These are deterministic: follow the pattern, verify with tests. No creative decisions here — consistency is the value.

Each standard defines: what it does, the pattern to follow, and what tests verify.

Read CLAUDE.md for stack and constraints before applying. Adapt the pattern to the detected framework, but keep the behavior identical.

---

## 1. Project Scaffold

The directory structure and base configuration. Derived from the stack in CLAUDE.md.

### Pattern

```
app/ or src/              application code
  (framework-specific structure)
lib/                      shared utilities
  db.ts                   database client
  env.ts                  env validation
tests/
  unit/                   unit tests
  e2e/                    end-to-end tests
```

### What to set up

- **Env validation:** validate all required env vars at startup. Use zod or similar. Fail fast with a clear message naming the missing var. Never silently fall back to defaults for secrets.
- **Database client:** single export, configured from validated env. Connection pooling for serverless environments.
- **Type generation:** if using Supabase, generate types from schema. If using Prisma/Drizzle, generate from schema file. Types are always generated, never hand-written.
- **Scripts:** `dev`, `build`, `test`, `test:e2e`, `typecheck`, `lint` in package.json. Every script works from a fresh clone after `install`.

### Tests verify

- App starts without errors when all env vars are set
- App fails with clear error when a required env var is missing
- Database client connects successfully
- Generated types exist and are importable
- All scripts exit 0 on a clean project

---

## 2. Database Schema

Tables, relationships, row-level security, and type generation. The schema is the contract.

### Pattern

- **Schema-first:** define tables, columns, constraints, indexes before writing application code
- **RLS on every table with user data.** No exceptions. Policies check `auth.uid()` or equivalent
- **Indexes on filtered columns.** Every column used in WHERE, ORDER BY, or JOIN gets an index
- **Timestamps:** `created_at` (default now) and `updated_at` (trigger or application) on every table
- **Soft delete:** if the domain requires it, `deleted_at` timestamp. Otherwise hard delete is fine

### For Supabase specifically

- Write migrations in `supabase/migrations/`
- Enable RLS: `alter table [name] enable row level security;`
- Create policies for select, insert, update, delete per role
- Generate types: `supabase gen types typescript --local > lib/database.types.ts`
- Storage buckets: private by default, explicit policies for public access

### Tests verify

- Tables exist with expected columns and types
- RLS prevents cross-user data access (insert as user A, select as user B returns empty)
- Indexes exist on filtered columns
- Migrations run cleanly from scratch (`supabase db reset`)
- Generated types match actual schema

---

## 3. Auth

Authentication and authorization. The most security-critical building block.

### Pattern

- **Use the stack's auth service.** Supabase Auth, NextAuth, Clerk, Auth0 — whatever CLAUDE.md specifies. Never roll custom auth.
- **Middleware on all protected routes.** A single middleware file, not per-route checks. Unauthenticated requests redirect to login or return 401.
- **Session validation:** server-side on every request. Never trust client-only session state.
- **Login flow:** email/password or OAuth as specified. Password requirements: minimum 8 chars, no maximum. No arbitrary complexity rules.
- **Signup flow:** create account, create initial user record in database, redirect to app.
- **Logout:** clear session server-side, redirect to login.
- **Protected API routes:** check session before processing. Return 401 with no body, not error details.

### For Supabase + Next.js specifically

- `@supabase/ssr` for server-side auth
- Middleware in `middleware.ts` at project root
- Server client in `lib/supabase/server.ts`
- Browser client in `lib/supabase/client.ts`
- Auth callback route for OAuth and magic links

### Tests verify

- Unauthenticated request to protected route returns redirect or 401
- Authenticated request to protected route returns 200
- Login with valid credentials creates session
- Login with invalid credentials returns error, no session
- Logout destroys session
- API routes return 401 without valid session
- Signup creates user record in database

---

## 4. Layout Shell

The persistent UI frame: navigation, page structure, responsive behavior. Only applies if EIID layers are mapped to visual modality.

### Pattern

Read `.superskills/design-system.md` for:
- Navigation items and budget from IA section
- Page patterns from Layout section
- Typography scale and composition from their sections
- Tokens from Tokens section

- **Navigation matches IA exactly.** Same items, same order, same nesting. No extras.
- **Active state** on current route. Visually distinct without relying on color alone.
- **Responsive:** sidebar collapses to mobile nav at the documented breakpoint
- **Page layout** follows the documented page patterns
- **Typography:** use the documented scale. Display, H1, body, etc. from the design system
- **Tokens:** all spacing, color, radius from the token set. No arbitrary values.

### Tests verify

- All navigation items from IA section are present
- No navigation items beyond what IA documents
- Active state renders on current route
- Layout is responsive at documented breakpoints
- Typography uses only values from the documented scale
- Page renders without errors at all breakpoints

---

## 5. Settings

User preferences and system configuration. Every project that has users needs settings.

### Pattern

- **Settings page** at `/settings` or equivalent. Inside the navigation if IA includes it, otherwise accessible from user menu.
- **Grouped by concern:** profile, preferences, connections, notifications, danger zone (delete account)
- **Immediate feedback:** save on change or explicit save button. Either way, confirm success visually.
- **Validation:** client-side for UX, server-side for security. Same rules both sides.

### If the project uses LLM calls, workflows, or agents

Settings MUST include prompt visibility and management:

- **Prompt inspector:** every prompt the system uses is visible to the user. Not the raw template — a readable version showing what the system asks and why.
- **Editable prompts:** users can customize prompts that affect their experience. Each prompt has a default (from the system) and a user override. Reset to default is always available.
- **Prompt versioning:** when a system prompt changes (via deploy), user overrides are preserved. Show the user what changed and let them decide whether to adopt the new default.

This is not optional for AI-native products. The intelligence layer should not be a black box. Users who can see and adjust the prompts trust the system more and get better results.

### Tests verify

- Settings page loads with current values
- Changes persist after save and page reload
- Invalid input shows validation error, does not save
- Each setting group renders
- If prompts: default prompts are visible, user can override, reset restores default

---

## 6. Error Handling

Consistent error patterns across the application. Not a separate feature — a standard applied everywhere.

### Pattern

- **User-facing errors:** clear language, what happened + what to do next. No stack traces, no error codes, no "something went wrong."
- **API errors:** structured JSON. `{ error: string, code?: string }`. HTTP status codes used correctly (400 for bad input, 401 for unauth, 403 for forbidden, 404 for missing, 500 for server).
- **Agent errors:** follow the agent interaction patterns in the design system if documented. "Photo too dark to read" not "Image processing failed."
- **Logging:** server-side errors logged with context (route, user ID, input summary). No PII in logs. No secrets in logs.
- **Boundaries:** React error boundaries (or equivalent) on route segments. A failing component doesn't take down the page.

### Tests verify

- API routes return correct status codes for each error type
- Error responses have the structured format
- Error boundary catches component errors without crashing the page
- Errors are logged with context (mock logger in tests)

---

## 7. Logging

Structured logging with consistent format. Not console.log scattered through the code.

### Pattern

- **Structured:** JSON format with timestamp, level, message, context fields
- **Levels:** error, warn, info, debug. Production runs at info. Development at debug.
- **Context:** each log entry includes the relevant identifiers (userId, route, jobId, etc.)
- **Minimal stdout:** scripts and processes output minimal status. Full output goes to structured logs.
- **No PII:** never log email addresses, names, passwords, tokens. Log user IDs only.
- **Request logging:** middleware logs each request (method, path, status, duration). Not body.

### Tests verify

- Logger outputs structured JSON
- Log levels filter correctly
- Context fields are present in output
- PII patterns are not present in logs (regex check on test output)
