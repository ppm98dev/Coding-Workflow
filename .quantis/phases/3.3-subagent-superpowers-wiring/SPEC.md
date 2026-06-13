# Phase 3.3: Subagent & Workflow Skill-Wiring — SPEC

> **Status**: FINALIZED
> **Created**: 2026-06-13
> **Verified**: 2026-06-13 — dispatch-site audit + independent 4-agent verification pass (TDD-disconnect, core-chain, routing-contradiction, orphans) all confirmed.
> **Scope**: Prose edits to skill/prompt/rule files + one new validator script. No product code.

## Problem Statement

agy can dispatch a subagent in **every** phase — discuss, plan, execute, verify, and the fan-out
workflows (stress-test, research, debug, map). A dispatched subagent is a **fresh context that
carries only its dispatch prompt** — it does NOT inherit the orchestrator's loaded skills (only a
`self` clone would, which we avoid per D-009). Therefore a subagent only "uses superpowers" if its
dispatch hands it the **path** to the methodology skill it should follow, to read on demand.

A dispatch-site audit (2026-06-13), independently verified by a 4-agent pass, found the
orchestrator→methodology chain **intact** (all 8 `/wf-*` force-loads resolve) but the
**dispatched-subagent layer largely cut off from superpowers**:

- SDD's `implementer` / `spec-reviewer` / `code-quality-reviewer` prompts reference **no skill**
  (code-quality only name-drops a template via "Use template at…", not a forced read).
- `test-driven-development` is force-loaded by **nothing** — SDD only name-drops "follow TDD"
  (SKILL.md:314), so implementer subagents never receive the RED-GREEN-REFACTOR discipline.
- `executing-plans`, `wf-stress-test`, `wf-research-phase`, `wf-debug-issue`, `wf-audit-milestone`
  dispatch subagents **without handing the methodology skill** they embody.
- `writing-plans` (lines 156–160) still routes the IDE/no-`invoke_subagent` fallback to
  `executing-plans`, **contradicting D-002** (SDD is the single `/execute` path).
- Pre-existing Phase 3.3 gaps (carried in): `wf-plan-milestone-gaps`→`writing-plans`,
  `wf-sprint`→SDD/`executing-plans`.

**Verified non-issues (no action):** the context skills (`context-compressor`,
`context-health-monitor`, `token-budget`) are condition-triggered + cross-referenced — not orphans.
The core `/wf-*`→methodology chain is fully wired.

## Fix 1 — The Dispatch Contract (foundation)
File: `.agents/rules/QUANTIS-STYLE.md`
- Add a named contract to § Subagent Dispatch & Delegation: **every subagent dispatch MUST hand the
  subagent a PATH to the methodology skill it embodies** —
  `REQUIRED SUB-SKILL: Read and follow .agents/skills/<X>/SKILL.md` — **never pasted skill text**
  (D-009/D-010: lean prompt + skill path = no stall AND real superpowers). Cite `wf-plan`'s
  Subagent Planning section as the canonical, already-correct example.
Acceptance: grep finds the contract; the phrase "REQUIRED SUB-SKILL" + "path, not paste" present.

## Fix 2 — SDD execution layer: wire the three dispatched roles
Files: `subagent-driven-development/{implementer,spec-reviewer,code-quality-reviewer}-prompt.md`,
`subagent-driven-development/SKILL.md`
- `implementer-prompt`: add `REQUIRED SUB-SKILL: Read and follow .agents/skills/test-driven-development/SKILL.md`.
- `spec-reviewer-prompt`: add `REQUIRED SUB-SKILL: Read and follow .agents/skills/verification-before-completion/SKILL.md`
  (default — see Decision D-011a; flippable to self-contained).
- `code-quality-reviewer-prompt`: upgrade "Use template at requesting-code-review…" →
  `Read and follow .agents/skills/requesting-code-review/SKILL.md`.
- `SKILL.md`: at each dispatch site ensure the relevant skill path is handed; convert the line-314
  TDD name-drop into a pointer to the implementer directive.
Acceptance: each of the 3 prompts contains a `Read and follow .agents/skills/.../SKILL.md` line.

## Fix 3 — Other dispatching workflows hand their methodology
Files: `executing-plans`, `wf-stress-test`, `wf-research-phase`, `wf-debug-issue`,
`wf-audit-milestone`, `wf-discuss-phase` SKILL.md
- `executing-plans`: add the TDD `REQUIRED SUB-SKILL` (standalone path matches SDD); keep its
  existing `finishing-a-development-branch`.
- `wf-stress-test`: hand the stress-test methodology to the 7-way fan-out subagents.
- `wf-research-phase`: hand `brainstorming` (research mode) to the dispatched research subagents.
- `wf-debug-issue`: hand `systematic-debugging` (+ `test-driven-development` for the repro test) to
  the debug subagents.
- `wf-audit-milestone`: inspect the dispatch; hand the relevant skill or confirm benign + note it.
- `wf-discuss-phase`: confirm whether it dispatches a subagent; if yes, hand `brainstorming`; if
  inline-only, record that (no-op).
Acceptance: re-run the dispatch map — every dispatching workflow shows a methodology skill handed.

## Fix 4 — Reconcile the routing contradiction
File: `writing-plans/SKILL.md`
- Lines 156–160: `/wf-execute` always uses `subagent-driven-development` (self-selects real
  subagents or inline by platform); `executing-plans` is **standalone/separate-session only**, not
  the IDE fallback. (Per D-002.)
Acceptance: grep returns 0 for "else → executing-plans" / "If NOT available: Read and follow …executing-plans".

## Fix 5 — Path-not-paste cleanup on already-wired dispatches
File: `wf-verify/SKILL.md`
- Confirm Step 0's subagent dispatch hands `verification-before-completion` as a **path**, not
  pasted skill text; convert if it pastes (D-010).
Acceptance: wf-verify Step 0 references the skill by path; no large pasted skill body in the dispatch.

## Fix 6 — Pre-existing 3.3 workflow-delegation gaps (carried in)
Files: `wf-plan-milestone-gaps`, `wf-sprint` SKILL.md
- `wf-plan-milestone-gaps`: delegate plan generation to `writing-plans/SKILL.md`.
- `wf-sprint`: delegate to `executing-plans/SKILL.md`, and use SDD when `invoke_subagent` available.
Acceptance: both contain a `Read and follow .agents/skills/…/SKILL.md` step.

## Fix 7 — Durability: validator + dispatch-map re-run
Files: `scripts/validate-workflows.sh` (or new `scripts/validate-dispatch.sh`)
- Add a check: every workflow/skill that dispatches a subagent must hand a methodology skill **path**
  near its dispatch site; fail otherwise. Stops regressions.
Acceptance: `validate-all.sh` green; dispatch-map shows no bare dispatchers (except confirmed-benign,
explicitly allow-listed with a reason).

## Decisions
- **D-011** — The Dispatch Contract (paths-not-paste, REQUIRED SUB-SKILL at every dispatch).
- **D-011a** — `spec-reviewer` → `verification-before-completion`. **Confirmed (2026-06-13).** A spec
  review *is* verification — applying its Gate Function per spec requirement is the anti-rubber-stamp
  discipline, and it makes verification consistent at both the per-task and per-phase (`/wf-verify`)
  levels.

## Out of Scope
- `finishing-a-development-branch`, `using-git-worktrees` wiring — intentionally outside `/wf-execute`
  (branch-closing is skipped at phase level; worktrees is niche). May revisit later.
- The Phase 3.1 end-to-end `/verify` run — a separate, already-tracked deliverable.
- Any product-code change — this phase is prose/process only.

## Plan Structure
One plan file, `3.3-subagent-superpowers-wiring-PLAN.md` (one task per file, checkbox format).
Execution order is top-to-bottom (Fix 1 contract first, then per-file fixes, then the validator).

---

*Last updated: 2026-06-13*
