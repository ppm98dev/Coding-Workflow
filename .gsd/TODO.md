# TODO.md — Quick Capture

## Pending

### v2.1 — Dead Code Prevention (researched)
- [ ] Add `<remove>` tag to PLAN.md task XML (see `.gsd/phases/5/RESEARCH.md`)
- [ ] Add Executor Rule 5: "Auto-clean dead code" to `/execute`
- [ ] Add code growth audit check to `/verify`

### Ideas from github/spec-kit (93.6k ⭐)
> Source: https://github.com/github/spec-kit — study their repo for patterns to adopt

#### 🔥 Steal Now (high value, low effort)

- [ ] **Constitution concept** (~30 min) — Add `CONSTITUTION.md` step to `/new-project`. Captures project-level principles (code style, quality rules, architecture constraints, perf targets) separate from requirements. Gets loaded in every `/plan` and `/execute` so the agent never forgets your standards. Spec-Kit puts this in `.specify/memory/constitution.md`. **Patch:** new template + update `/new-project`, `/plan`, `/execute` context loading.

- [ ] **Spec Stress-Test `/stress-test`** (~20 min) — New workflow that reads SPEC.md and pokes holes: "What happens when X fails?", "You said Y but didn't mention Z", edge cases, contradictions, scale concerns. Spec-Kit calls this `/speckit.clarify`. GSD has nothing between "SPEC finalized" and "start planning". **Create:** `.agent/workflows/stress-test.md`

#### 🟡 Steal Later (high value, medium effort)

- [ ] **Smart install `--agent` flag** (~1 hour) — `install.sh --agent antigravity` would skip irrelevant adapters (CLAUDE.md, GPT_OSS.md), auto-configure `.gemini/GEMINI.md`. Spec-Kit does `specify init . --integration gemini`. **Patch:** expand `scripts/install.sh` with agent flag + selective copy logic.

- [ ] **Override layer (presets-lite)** (~45 min) — A `.gsd/overrides/` directory. If a template exists in overrides, use it instead of default. One line of logic per workflow: `TEMPLATE="${OVERRIDE_DIR}/${name}.md"; [ ! -f "$TEMPLATE" ] && TEMPLATE="${TEMPLATE_DIR}/${name}.md"`. Spec-Kit has full preset stacking with priorities — overkill for us, but the simple override directory gives 80% of the value.

- [ ] **`/checklist`** (~15 min) — Pre-implementation validation command. Reads PLAN.md and checks: all files exist or will be created, actions are specific, verify commands are executable, done criteria are measurable. GSD has this as the `plan-checker` skill but it's not a user-facing command.

#### 🔵 Skip (not worth it for solo use)

- ~~Extension catalog / community system~~ — Over-engineering for a solo user
- ~~Full preset stacking with priorities~~ — Simple override layer covers it
- ~~Python CLI tool~~ — GSD's strength is zero dependencies, adding Python betrays the philosophy

### ⚠️ Honest Assessment: Where GSD Falls Short vs Spec-Kit

> GSD works well for small projects. For big builds, it may fail without these fixes.

#### Things Spec-Kit does BETTER than GSD (must fix)

1. **Forced `[NEEDS CLARIFICATION]` markers** — Spec-Kit forces the LLM to mark what it doesn't know instead of guessing. GSD's SPEC.md says "FINALIZED" but nobody checks if the spec is actually complete. The agent will plan around ambiguous requirements and you won't know until Phase 3.

2. **Test-first enforcement** — Spec-Kit Article III: write tests first, confirm they fail, THEN write code. GSD says "verify after execution" but never forces test-first. The agent writes code, then writes tests to match the code — backwards.

3. **Cleaner spec/plan separation** — Spec-Kit: `spec.md` = pure user intent (no tech), `plan.md` = tech choices. GSD: `SPEC.md` mixes "what I want" with architecture hints. The boundary is blurry.

4. **File creation order** — Spec-Kit mandates: contracts → tests → source. Always. GSD's `<task>` blocks have no ordering convention — the agent picks "code first, tests later."

5. **Branch-per-feature** — `/speckit.specify` auto-creates a git branch per feature. GSD works on whatever branch you're on. For multi-feature projects this is cleaner.

6. **Project-specific principles that persist** — The constitution is always-loaded. GSD relies on the agent remembering Phase 1 context in Phase 4. It doesn't. PROJECT_RULES.md is generic, not project-specific.

#### Where GSD still wins

- **Session management** (pause/resume/context health) — Spec-Kit has nothing
- **Debugging protocol** (3-strike rule) — Spec-Kit has no debugging guidance
- **Verification with proof** (screenshots, command output) — Spec-Kit trusts the implement step
- **Wave-based execution** — Spec-Kit is sequential only

#### Scaling Problem

GSD was built for small, solo projects. For anything larger:
- No branch management → merge conflicts on multi-feature work
- No test-first discipline → bugs compound across phases
- No spec quality gate → ambiguity cascades into bad plans
- SPEC.md is one file → doesn't scale to 10+ features
- No contracts/API specs → integration breaks between components

**Action:** The v2.1+ roadmap should prioritize closing these gaps, especially: constitution, test-first enforcement, clarification markers, and branch-per-feature.

### 🔍 Community Skills to Study/Adopt
> Sources: https://github.com/VoltAgent/awesome-agent-skills (20.9k ⭐, 1000+ skills) · https://agentskills.io

#### Directly relevant to GSD improvements
- [ ] **trailofbits/ask-questions-if-underspecified** — Prompts for clarification on ambiguous requirements. This is exactly the `/stress-test` idea. Study their SKILL.md for implementation patterns.
- [ ] **trailofbits/differential-review** — Security-focused diff review with git history analysis. Could improve our `/verify` with a diff-aware check.
- [ ] **trailofbits/property-based-testing** — Property-based testing for multiple languages. Could inform test-first enforcement in `/execute`.
- [ ] **anthropics/webapp-testing** — Test local web apps using Playwright. Could replace GSD's manual browser_subagent verification.
- [ ] **anthropics/skill-creator** — Guide for creating skills. Study to improve our skill structure.
- [ ] **cloudflare/web-perf** — Audit Core Web Vitals. Could add perf verification to `/verify`.

#### Best practices from official teams (study their SKILL.md patterns)
- [ ] **vercel-labs/react-best-practices** — How Vercel structures best-practice skills
- [ ] **trailofbits/static-analysis** — CodeQL, Semgrep, SARIF integration patterns
- [ ] **callstackincubator/github** — GitHub workflow patterns (PRs, branching, code review)
- [ ] **google-labs-code/design-md** — How to create/manage DESIGN.md files (similar to our SPEC.md)

#### Key insight: GSD skills are primitive compared to community
GSD has 7 skills with basic SKILL.md files. Community skills from Stripe, Cloudflare, Trail of Bits bundle: `scripts/` for executable helpers, `references/` for API docs, `assets/` for templates. Our skills are instruction-only — no scripts, no references, no assets. **Upgrading skill structure is a prerequisite for v2.1.**

### Other
- [ ] Check if upstream `gsd-build/get-shit-done` has newer features to backport
- [ ] Consider adding a `/self-test` workflow that validates GSD works on itself
- [ ] Investigate token measurement APIs in Antigravity for context-health-monitor
- [ ] Explore MCP integration for enhanced tool calling

## Done
- [x] Clone repo and commit baseline
- [x] Run /map and create ARCHITECTURE.md + STACK.md
- [x] Run /new-project and create SPEC, ROADMAP, STATE
