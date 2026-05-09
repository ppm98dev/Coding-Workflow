# ROADMAP.md

> **Current Milestone**: v2.1 — Production Code Quality, Spec Rigor & Scaling
> **Status**: Phase 1 complete

---

## Milestone: v2.0 — Antigravity-Native GSD ✅ COMPLETE

### Phase 1: Antigravity Integration ✅
### Phase 2: Remove PowerShell — Bash Only ✅
### Phase 3: Core Fixes ✅
### Phase 4: Install Automation & Polish ✅

---

## Milestone: v2.1 — Production Code Quality, Spec Rigor & Scaling

> **Goal**: Close every gap between "it works" and production-grade. Add spec rigor, code quality enforcement, plan iteration, upgrade skill infrastructure, and lay the groundwork for multi-user.

### Must-Haves
- [x] `CONSTITUTION.md` — project-level quality + architecture standards, always loaded
- [x] `[NEEDS CLARIFICATION]` markers — forced in spec, rejected by plan-checker
- [x] "Quality Requirements" section in SPEC template
- [ ] Test-first + file creation order (contracts → tests → source)
- [ ] Production code enforcement in `/execute` + `/verify`
- [ ] New `production-code` skill with language-specific references
- [ ] `/update-plan` workflow — review and revise plans before execution
- [ ] `/checklist` workflow — plan-checker as user-facing command
- [x] `/stress-test` workflow — spec quality gate before planning
- [x] Cleaner spec/plan separation
- [ ] Branch-per-feature in `/plan` or `/execute`
- [x] Architecture guardrails in constitution
- [ ] Upgraded skill structure (scripts/, references/, assets/)
- [ ] Multi-user foundations (per-user state, phase ownership, handoff)

### Nice-to-Haves
- [ ] Dead code prevention (`<remove>` tags)
- [ ] Smart install `--agent` flag
- [ ] Override layer `.quantis/overrides/`
- [ ] Community skills adoption (Trail of Bits, Vercel, Cloudflare)

### Phases

#### Phase 1: Constitution & Spec Rigor ✅
**Status**: ✅ Complete
**Objective**: Establish project-level quality standards and spec quality gates.
**Deliverables:**
- `CONSTITUTION.md` template — added to `/new-project`, loaded in `/plan` + `/execute`
- Architecture guardrails included in constitution (max function length, separation of concerns, dependency rules)
- `[NEEDS CLARIFICATION]` markers — forced in spec template, plan-checker rejects unresolved markers
- "Quality Requirements" section added to SPEC template (error handling strategy, logging level, perf targets)
- `/stress-test` workflow — reads SPEC.md and pokes holes: edge cases, contradictions, missing failure modes
- Cleaner spec/plan separation — SPEC = pure user intent, PLAN = technical choices
#### Phase 1.5: Quantis Rebrand
**Status**: ⬜ Not Started
**Objective**: Rename GSD → Quantis across the entire framework. Update all references, directory structure, README, and external docs.
**Deliverables:**
- Rename `.quantis/` directory to `.quantis/`
- Replace all "GSD" brand references with "Quantis" across 99+ files
- Rename `GSD-STYLE.md` → `QUANTIS-STYLE.md`
- Full README rewrite with Quantis branding + Phase 1 features
- Update scripts, adapters, docs, and LICENSE

#### Phase 2: Plan Iteration & Validation
**Status**: ⬜ Not Started
**Objective**: Enable plan review and revision before execution.
**Deliverables:**
- `/update-plan` workflow — review generated plan, request changes, iterate before committing to execution
- `/checklist` workflow — user-facing command wrapping plan-checker skill (pre-execution validation: files exist, actions specific, verify commands executable, done criteria measurable)

#### Phase 3: Production Code Enforcement
**Status**: ⬜ Not Started
**Objective**: Enforce production-grade code quality throughout the pipeline.
**Deliverables:**
- Planner skill updated: mandate contracts → tests → source file ordering
- `/execute` updated with production patterns: validate inputs → handle errors → log operations → write clean code → add tests
- `/verify` updated with quality gates: error handling exists, logs present, no hardcoded secrets, functions small, code documented
- New `production-code` skill with `references/` for language-specific patterns (Python: logging, typing, pydantic; JS: zod, winston, error boundaries)

#### Phase 4: Skill Infrastructure Upgrade
**Status**: ⬜ Not Started
**Objective**: Upgrade skill structure to community standard and adopt best practices.
**Deliverables:**
- All 7 existing skills upgraded to include `scripts/`, `references/`, `assets/` directories where applicable
- Study and adopt patterns from community skills:
  - `trailofbits/ask-questions-if-underspecified` — clarification prompts
  - `trailofbits/differential-review` — security-focused diff review
  - `trailofbits/property-based-testing` — property-based testing patterns
  - `anthropics/webapp-testing` — Playwright-based web app testing
  - `anthropics/skill-creator` — skill creation best practices
  - `cloudflare/web-perf` — Core Web Vitals auditing
- Study best-practice skill structures from: `vercel-labs/react-best-practices`, `trailofbits/static-analysis`, `callstackincubator/github`, `google-labs-code/design-md`

#### Phase 5: Branch Management & Polish
**Status**: ⬜ Not Started
**Objective**: Add branch isolation, dead code prevention, and developer experience improvements.
**Deliverables:**
- Branch-per-feature: `/plan` or `/execute` auto-creates git branch per phase/feature
- Dead code prevention: `<remove>` tag in PLAN.md task XML, Executor Rule 5 "auto-clean dead code", code growth audit in `/verify`
- Smart install `--agent` flag: `install.sh --agent antigravity` skips irrelevant adapters
- Override layer: `.quantis/overrides/` directory for template customization
- Spec/plan separation cleanup pass

#### Phase 6: Multi-User Foundations
**Status**: ⬜ Not Started
**Objective**: Enable team usage of GSD while preserving single-user simplicity.
**Deliverables:**
- Per-user state files: `STATE-{user}.md` so `/pause` and `/resume` don't collide
- Phase ownership/assignment: `**Assigned**: @user` in ROADMAP.md phases
- Handoff protocol: like `/pause` but explicitly for passing work to another person
- Attribution: journal entries, decisions, and commits tagged with author
- Review gates: spec review before planning, plan review before execution, code review before merge
- Git conventions for team use: branch naming, PR workflow, merge rules

---

## Milestone: v2.2 — Advanced Scaling (Future)

> **Goal**: Address structural scaling limitations for large, complex projects.
> **Status**: 🔮 Planned — not started, depends on v2.1 completion.

### Planned Scope
- [ ] **SPEC.md scaling** — Split monolithic SPEC into feature-level spec files for projects with 10+ features
- [ ] **Contracts/API specs** — Interface definitions between components to prevent integration breaks
- [ ] **`/self-test` workflow** — Meta-workflow that validates GSD works on itself
- [ ] **Token measurement APIs** — Integrate with Antigravity internals for context-health-monitor accuracy
- [ ] **MCP integration** — Enhanced tool calling via Model Context Protocol
- [ ] **Upstream backport check** — Compare against `gsd-build/get-shit-done` for new features to adopt
