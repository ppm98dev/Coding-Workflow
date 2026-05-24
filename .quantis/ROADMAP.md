# ROADMAP.md

> **Current Milestone**: v3.1 — Hierarchical Subphase Folders
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
> **Status**: 🚀 Active

### Must-Haves
- [ ] Workflows resolution adapted (plan, execute, verify, debug, research-phase, update-plan, etc.)
- [ ] Skills definition updated (using-quantis, writing-plans, brainstorming, SDD)
- [ ] Plan naming standard implemented (`N.M-PLAN.md` with numbered H1 headers)
- [ ] Automatic directory normalizer/lookup helper in workflows

### Phases

#### Phase 1.1: Hierarchical Subphase Folder Architecture
**Status**: 🚀 Active
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

## Milestone: v3.2 — Advanced Features (Future)

> **Goal**: Address deferred work and advanced capabilities.
> **Status**: 🔮 Planned

### Planned Scope
- [ ] Multi-user foundations (deferred from v2.1 Phase 6)
- [ ] SPEC.md scaling for large projects
- [ ] MCP integration for enhanced tool calling
- [ ] Parallel subagent dispatch for independent tasks
- [ ] Community skill adoption framework


