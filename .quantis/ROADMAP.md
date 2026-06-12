# ROADMAP.md

> **Current Milestone**: v3.3 — Workflow Reliability & Advanced Features
> **Status**: In progress 🚀

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

#### Phase 3.1: Workflow Reliability Fixes 🔄

**Status**: 🔄 Implemented — pending independent `/verify` (applied 2026-06-12 by hand; never run through `/execute`+`/verify` — see the E2E deliverable)
**Objective**: Originally 4 reliability fixes; expanded 2026-06-12 to the full audit — every Critical/High/Medium/Low finding + senior code review (Issue 5) across the discuss→plan→execute→verify core (32 files, 150 edits, 5 plans), plus a sweep of previously-untouched workflows/adapters/docs/scripts (17 files, 35 edits). `validate-all.sh` passes; 51/51 anchors verified; independent review pass applied.
**Deliverables:**

- [x] `wf-discuss-phase/SKILL.md` — full brainstorming checklist + SPEC.md existence gate
- [x] `wf-execute/SKILL.md` — unified phase-dir resolution, STOP gates, per-task verify gate, completion ownership, branch check
- [x] `wf-verify/SKILL.md` — loads verification-before-completion (process step) + structural repair + senior code review (Issue 5) + PARTIAL verdict + gap routing
- [x] `wf-pause/SKILL.md` — ROADMAP reconciliation + mandatory auto-save
- [x] Full audit remediation (C1–C8, H1–H12, all Medium/Low) across core skills, rules, templates — applied, reviewed, validated
- [x] Untouched-set sweep (phase-mgmt, planning, dispatch, help, methodology, README/ANTIGRAVITY, install/upgrade) — 35 edits
- [ ] **End-to-end run** — `discuss→plan→execute→verify` on a real/sandbox project (the one remaining behavioral gap; tracked in Phase 3.3)

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

#### Phase 3.3: Workflow-Skill Wiring Gaps ⬜

**Status**: ⬜ Not Started
**Objective**: Wire remaining workflows to their natural skills, closing delegation gaps found in the workflow-skill audit.
**Depends on**: Phase 3.2

**Gaps identified:**

| Workflow | Should delegate to | Why |
|----------|-------------------|-----|
| `plan-milestone-gaps` | `writing-plans` | Creates plans from audit gaps — should use the same planning methodology as `/plan` |
| `sprint` | `executing-plans` + `subagent-driven-development` | Time-boxed execution should use SDD when available |

**Deliverables:**
- [ ] `wf-plan-milestone-gaps` delegates to `writing-plans/SKILL.md` for plan generation
- [ ] `wf-sprint` delegates to `executing-plans/SKILL.md` and uses SDD when `invoke_subagent` is available
- [ ] Verification: both workflows produce the same quality output as their full counterparts (`/plan`, `/execute`)

**Nice-to-haves:**
- [ ] Delete `adapters/ANTIGRAVITY.md` (content already distributed into workflows/skills)
- [ ] End-to-end test: full Quantis cycle on CLI (`discuss → plan → execute → verify`)

