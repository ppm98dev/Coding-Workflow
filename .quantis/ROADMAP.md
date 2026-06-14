# ROADMAP.md

> **Current Milestone**: v3.3 — Workflow Reliability & Advanced Features
> **Status**: 🏁 All numbered phases complete (3.1–3.5 ✅) — future-scope items deferred; ready for `/wf-complete-milestone`

---

## Milestone: v2.0 — Antigravity-Native Quantis ✅ COMPLETE

### Phase 1: Antigravity Integration ✅

### Phase 2: Remove PowerShell — Bash Only ✅

### Phase 3: Core Fixes ✅

### Phase 4: Install Automation & Polish ✅

---

## Milestone: v2.1 — Production Code Quality, Spec Rigor & Scaling ⏸ CLOSED

> **Goal**: Close every gap between "it works" and production-grade.
> **Status**: ⏸ Closed — Phases 1-2 complete, Phases 3-6 superseded by v3.0 (Superpowers adoption).
> **Reason**: Deep audit of [obra/superpowers](https://github.com/obra/superpowers) revealed superior code quality skills (TDD, SDD, code review). Phases 3-6 goals are now achieved by adopting Superpowers. See D-015 through D-024.

### Phase 1: Constitution & Spec Rigor ✅

### Phase 1.5: Quantis Rebrand ✅

### Phase 2: Plan Iteration ✅

### Phase 3: Production Code Enforcement ⏸ SUPERSEDED by Superpowers TDD + SDD skills

### Phase 4: Skill Infrastructure Upgrade ⏸ SUPERSEDED by Superpowers skill adoption

### Phase 5: Branch Management & Polish ⏸ SUPERSEDED by Superpowers git worktrees skill

### Phase 6: Multi-User Foundations ⏸ DEFERRED to future milestone

---

## Milestone: v3.0 — Superpowers Integration & Antigravity 2.0

> **Goal**: Fork Superpowers' battle-tested code quality skills into Quantis, adapt for Antigravity 2.0's native subagent system, and keep Quantis' unique process management layer on top.
> **Status**: All phases complete ✅

### Must-Haves

- [x] Superpowers skills imported into `.agents/skills/` (18 skills)
- [x] All skills adapted for Antigravity 2.0 tool names
- [x] `using-quantis` bootstrap skill (replaces `using-superpowers`)
- [x] `antigravity-tools.md` tool mapping reference
- [x] SDD skill adapted with `invoke_subagent` / `define_subagent`
- [x] State integration: SDD auto-updates STATE.md, JOURNAL.md, ROADMAP.md
- [x] Old Quantis skills removed (planner, executor, verifier, etc.)
- [x] Replaced workflows aliased to skills (discuss-phase, plan, execute, etc.)
- [x] Kept workflows updated for new skill references
- [x] README updated with v3.0 architecture

### Nice-to-Haves

- [ ] Pre-defined subagent types via `define_subagent` at session start
- [ ] Visual brainstorming companion adapted for `browser_subagent`
- [ ] Parallel agent dispatch adapted for Antigravity
- [ ] Skill creation meta-skill (`writing-skills`) adapted

### Phases

#### Phase 1: Skill Migration ✅

**Status**: ✅ Complete
**Objective**: Import all 13 Superpowers skills into `.agents/skills/`, adapt tool references for Antigravity 2.0.
**Deliverables:**

- Copy all Superpowers skills to `.agents/skills/`
- Create `using-quantis` bootstrap skill
- Create `antigravity-tools.md` reference file
- Adapt all `Task` tool references → `invoke_subagent`
- Adapt all `Read/Write/Edit/Bash` references → Antigravity equivalents
- Update file location defaults → `.quantis/phases/{N}/`
- Remove old Quantis skills (planner, executor, verifier, debugger, etc.)

#### Phase 2: Workflow Reconciliation ✅

**Status**: ✅ Complete
**Objective**: Remove superseded workflows, update kept workflows to reference new skills, add state integration hooks.
**Deliverables:**

- Remove 6 superseded workflows (discuss-phase, plan, update-plan, execute, stress-test, research-phase)
- Update `/debug` to invoke `systematic-debugging` skill
- Update `/verify` to invoke `verification-before-completion` skill
- Update `/new-project` to reference `brainstorming` skill for design phase
- Add state-update hooks to SDD skill (STATE.md, JOURNAL.md, ROADMAP.md)
- Update `/help` with new command listing

#### Phase 3: Integration Testing & Polish ✅

**Status**: ✅ Complete
**Objective**: End-to-end validation of the complete Quantis v3.0 workflow.
**Deliverables:**

- Create `MANIFEST.md` listing all core skills/workflows (so upgrade knows what to replace)
- Create `/upgrade` workflow — in-place GSD→v3.0 migration that:
  - Replaces GSD workflows with v3.0 workflows
  - Replaces GSD core skills with Superpowers skills
  - Preserves user-installed skills (anything not in MANIFEST)
  - Preserves `.quantis/` state (SPEC, ROADMAP, phases, STATE, etc.)
  - Preserves user's CONSTITUTION.md
- Update `/install` and `/update` workflows for v3.0
- Update README with v3.0 architecture, Superpowers credit
- Test full workflow: brainstorming → writing-plans → SDD → verification
- Test pause/resume across sessions with new skills

---

## Milestone: v3.1 — Hierarchical Subphase Folders

> **Goal**: Migrate the entire Quantis codebase to support hierarchical subphase folders (e.g. `.quantis/phases/1.1-description/`) for maximum isolation and clarity in the file tree.
> **Status**: ✅ Complete

### Must-Haves

- [x] Workflows resolution adapted (plan, execute, verify, debug, research-phase, update-plan, etc.)
- [x] Skills definition updated (using-quantis, writing-plans, brainstorming, SDD)
- [x] Plan naming standard implemented (`N.M-PLAN.md` with numbered H1 headers)
- [x] Automatic directory normalizer/lookup helper in workflows

### Phases

#### Phase 1.1: Hierarchical Subphase Folder Architecture ✅

**Status**: ✅ Complete
**Objective**: Update all workflows and skills to read and write from/to `.quantis/phases/{N}.{M}-{slug}/` folders.
**Deliverables:**

- Update `writing-plans/SKILL.md` to output plans in `.quantis/phases/{N}.{M}-{slug}/{N}.{M}-PLAN.md` and enforce `# Phase {N}.{M}: {Description} - Implementation Plan` header
- Update `brainstorming/SKILL.md` to output specs to `.quantis/phases/{N}.{M}-{slug}/SPEC.md`
- Update `.agent/workflows/plan.md` to resolve folders dynamically and output to the new layout
- Update `.agent/workflows/execute.md` and `/verify.md` to locate phase folders by `{N}.{M}` prefix
- Update `/debug.md`, `/research-phase.md`, `/remove-phase.md`, `/insert-phase.md`, `/complete-milestone.md` to resolve directories using prefix globbing
- Update `using-quantis/SKILL.md` and reference guides
- Verify all commands using dogfooding for Phase 1.1

---

## Milestone: v3.2 — Custom Skill & MCP Dynamic Integration ✅ COMPLETE

> **Goal**: Implement dynamic custom skill and MCP discovery and context injection inside the Quantis planning workflows to leverage third-party ecosystem tools (e.g. from skills.sh and active MCP servers) without breaking core skill upgradability.
> **Status**: ✅ Complete

### Must-Haves

- [x] Automated scan of `.agents/skills/` excluding core manifest skills inside `/plan`
- [x] Active MCP server/tool discovery and parsing inside `/plan`
- [x] Injection block in planning context containing available custom skills and active MCP definitions

### Phases

#### Phase 2.1: Dynamic Skill and MCP Context Injection ✅

**Status**: ✅ Complete
**Objective**: Update the `.agent/workflows/plan.md` workflow to automatically discover, summarize, and inject custom skills and active MCP servers into the planning context.
**Deliverables:**

- Update `.agent/workflows/plan.md` with Bash code that scans `.agents/skills/` for custom skills (cross-referencing `MANIFEST.md` to exclude core skills)
- Add Bash code in `.agent/workflows/plan.md` to detect active MCP tools and servers
- Design a beautiful printout inside the planning workflow that lists these ecosystem tools right before delegating to `writing-plans`
- Dogfood and verify `/plan` successfully displays custom skills and MCP suggestions

---

## Milestone: v3.3 — Workflow Reliability & Advanced Features

> **Goal**: Fix intermittent workflow reliability issues, then address deferred work and advanced capabilities.
> **Status**: In progress 🚀

### Phases

#### Phase 3.1: Workflow Reliability Fixes ✅

**Status**: ✅ Verified (2026-06-13) — **empirically, via daily production use** (real projects, incl. the Phase 5.5 SSO planning run) + static verification (`validate-all.sh`, 51/51 anchors, independent review). Not a formal `/verify` ceremony, but battle-tested in production — stronger evidence. See `VERIFICATION.md`.
**Objective**: Originally 4 reliability fixes; expanded 2026-06-12 to the full audit — every Critical/High/Medium/Low finding + senior code review (Issue 5) across the discuss→plan→execute→verify core (32 files, 150 edits, 5 plans), plus a sweep of previously-untouched workflows/adapters/docs/scripts (17 files, 35 edits). `validate-all.sh` passes; 51/51 anchors verified; independent review pass applied.
**Deliverables:**

- [x] `wf-discuss-phase/SKILL.md` — full brainstorming checklist + SPEC.md existence gate
- [x] `wf-execute/SKILL.md` — unified phase-dir resolution, STOP gates, per-task verify gate, completion ownership, branch check
- [x] `wf-verify/SKILL.md` — loads verification-before-completion (process step) + structural repair + senior code review (Issue 5) + PARTIAL verdict + gap routing
- [x] `wf-pause/SKILL.md` — ROADMAP reconciliation + mandatory auto-save
- [x] Full audit remediation (C1–C8, H1–H12, all Medium/Low) across core skills, rules, templates — applied, reviewed, validated
- [x] Untouched-set sweep (phase-mgmt, planning, dispatch, help, methodology, README/ANTIGRAVITY, install/upgrade) — 35 edits
- [x] **End-to-end run** — verified empirically through production use (Phase 5.5 plan run + ongoing daily use); see `VERIFICATION.md`

> **Note:** Phase 3.2 (CLI-First Migration) shipped ahead of 3.1, resolving the original 3.2-depends-on-3.1 inversion. The deterministic-SDD and `browser_subagent` graceful-fallback items landed there; remaining 3.1 work targets the `wf-*` skills directly.

### Future Scope

- [ ] Multi-user foundations (deferred from v2.1 Phase 6)
- [ ] SPEC.md scaling for large projects
- [ ] Parallel subagent dispatch for independent tasks
- [ ] Community skill adoption framework

---

#### Phase 3.2: CLI-First Migration ✅

**Status**: ✅ Complete (2026-06-11)
**Objective**: Fully adapt Quantis to run on Antigravity CLI (`agy`) as the primary platform, enabling subagent-driven development, VM/SSH workflows, and cross-platform compatibility.
**Depends on**: — (3.2 shipped ahead of 3.1; original inversion resolved — see Phase 3.1 note)

**Completed:**
- [x] Consolidated `.agent/workflows/` into `.agents/skills/wf-*/` (30 real files, 0 symlinks)
- [x] Deleted `.agent/` directory entirely
- [x] Moved PROJECT_RULES, CONSTITUTION, QUANTIS-STYLE to `.agents/rules/` (auto-discovered)
- [x] Removed dead adapters (CLAUDE, GEMINI, GPT_OSS) and `model_capabilities.yaml`
- [x] SDD skill detects `invoke_subagent` availability — uses it when present, falls back to inline when absent
- [x] `wf-execute` deterministic SDD selection (no menu)
- [x] `wf-verify` graceful `browser_subagent` fallback
- [x] Subagent dispatch in discuss-phase, plan, stress-test, verify
- [x] `quantis-help` shows CLI `/wf-*` variants
- [x] All scripts updated (validate-workflows, install, upgrade)
- [x] All root docs updated (README, MANIFEST, CHANGELOG)
- [x] Platform compatibility matrix in `adapters/ANTIGRAVITY.md`

---

#### Phase 3.3: Subagent & Workflow Skill-Wiring 🔄

**Status**: ✅ Complete (2026-06-13) — 16-task SDD fan-out applied + formal `/wf-verify` **PASS** (8/8 must-haves verified empirically, senior code review 0 findings). See `VERIFICATION.md`.
**Objective**: Make every **dispatched subagent** actually use the superpowers methodology it embodies — by handing it the skill **path** (read-on-demand) at the dispatch site, never pasted text. Plus reconcile the IDE-fallback routing contradiction and the two carried-in workflow-delegation gaps.
**Depends on**: Phase 3.2
**Folder**: `.quantis/phases/3.3-subagent-superpowers-wiring/` (SPEC.md + `3.3-subagent-superpowers-wiring-PLAN.md`, 17 tasks)

**Why this matters:** agy can dispatch a subagent in any phase, and a dispatched subagent is a fresh context carrying only its prompt — it inherits **none** of the orchestrator's loaded skills (D-009). A 4-agent verified audit found the `/wf-*`→methodology chain intact, but the dispatched-subagent layer largely cut off from superpowers — most importantly `test-driven-development` is force-loaded by nothing.

**Gaps (audit-verified 2026-06-13):**

| Site | Should hand its subagent | Status |
|------|--------------------------|--------|
| SDD `implementer-prompt` | `test-driven-development` | ❌ name-drop only |
| SDD `spec-reviewer-prompt` | `verification-before-completion` (D-011a) | ❌ none |
| SDD `code-quality-reviewer-prompt` | `requesting-code-review` | ⚠️ "use template at…" (not forced) |
| `executing-plans` | `test-driven-development` | ❌ none |
| `wf-stress-test` / `wf-research-phase` / `wf-debug-issue` | stress-test / `brainstorming` / `systematic-debugging` | ❌ none at dispatch |
| `writing-plans` 156–160 | (IDE fallback routes to `executing-plans`) | ❌ contradicts D-002 |
| `wf-plan-milestone-gaps` / `wf-sprint` | `writing-plans` / SDD+`executing-plans` | ❌ carried-in gaps |

**Deliverables:**
- [x] Fix 1 — Dispatch Contract in QUANTIS-STYLE (every dispatch hands its skill by path; D-011)
- [x] Fix 2 — SDD's 3 dispatched-role prompts wired to their superpowers skill
- [x] Fix 3 — `executing-plans`, `wf-stress-test`, `wf-research-phase`, `wf-debug-issue`, `wf-audit-milestone`, `wf-discuss-phase` hand their methodology at dispatch (discuss-phase confirmed inline-only)
- [x] Fix 4 — `writing-plans` IDE-fallback reconciled to D-002 (SDD-only; executing-plans standalone)
- [x] Fix 5 — `wf-verify` Step 0 hands the skill by path, not paste (D-010) — verified already-compliant
- [x] Fix 6 — carried-in: `wf-plan-milestone-gaps`→`writing-plans`, `wf-sprint`→SDD/`executing-plans`
- [x] Fix 7 — `scripts/validate-dispatch.sh` (durability: no bare dispatchers); `validate-all.sh` green
- [x] Formal `/wf-verify 3.3` run (final gate) — PASS (8/8 must-haves, 0 review findings)

**Out of scope:** `finishing-a-development-branch`/`using-git-worktrees` wiring (intentionally outside `/wf-execute`); the Phase 3.1 end-to-end `/verify` run (separate deliverable).

**Nice-to-haves:**
- [ ] Delete `adapters/ANTIGRAVITY.md` (content already distributed into workflows/skills)
- [ ] End-to-end test: full Quantis cycle on CLI (`discuss → plan → execute → verify`)

---

#### Phase 3.4: Parallel-Dispatch Concurrency Cap & Rate Limits ✅

**Status**: ✅ Complete (2026-06-13) — implemented + self-verified; **empirically validated on the user's agy tier** (≤3 concurrent does not crash).
**Objective**: Stop fan-out workflows from blowing the model's per-minute rate limit. `/wf-stress-test` fired **7 subagents at once** → `429 "exhausted capacity"` (twice, in production) → naive immediate re-dispatch looped on the unreliable "reset after 0s." Fix = cap concurrency at **≤3 (waves)** + wait-then-retry-once-then-inline on 429, as one shared rule inherited by every fan-out workflow.
**Depends on**: Phase 3.2
**Folder**: `.quantis/phases/3.4-dispatch-concurrency-cap/` (SPEC + PLAN)

**Deliverables:**
- [x] `dispatching-parallel-agents` — "Concurrency Cap & Rate Limits" contract (≤3 / waves / 429 wait-then-inline / no thundering herd; D-012)
- [x] `wf-stress-test` — 7-all-together → waves of ≤3; 429-aware retry
- [x] `wf-research-phase`, `wf-map`, `wf-debug-issue` — dispatch in waves of ≤3
- [x] `antigravity-tools.md` — document `invoke_subagent` has no built-in cap → ≤3 concurrent
- [x] D-012 recorded; `validate-all.sh` green

> **Note:** `≤3` is a validated-but-tunable default for the current Antigravity tier, not a hard pin. `wf-audit-milestone` dispatches a single subagent → cap N/A.

---

#### Phase 3.5: Install/Update Footprint ✅

**Status**: ✅ Complete (2026-06-13) — fixes a real production clobber (ARES_APP).
**Objective**: `/wf-update` overwrote a project's own `README`/`MANIFEST`/`CHANGELOG` — the skill prose said "replace Core files per MANIFEST," and MANIFEST listed those as Core Root Files (while the bash only copied `VERSION`). Fix = mark them **Quantis source-only** (never installed) + relocate the version marker root `VERSION` → **`.quantis/VERSION`** (no root collision).
**Depends on**: Phase 3.2
**Folder**: `.quantis/phases/3.5-install-footprint/` (SPEC + PLAN)

**Deliverables:**
- [x] MANIFEST — README/MANIFEST/CHANGELOG moved to a "Quantis source-only — NEVER installed" section
- [x] `wf-update` prose guard: never copy those three into a project
- [x] Version marker relocated `VERSION` → `.quantis/VERSION`; all 11 refs updated (install/upgrade/wf-install/wf-quantis-help/wf-update/wf-upgrade/README)
- [x] D-013 recorded; version → 3.4.2; `validate-all.sh` green

> **Recovery note:** projects already clobbered by the old behavior (e.g. ARES_APP) restore their own root files via `git checkout` — separate from this source fix.

