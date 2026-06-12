# Phase 3.1: Workflow Reliability Fixes — SPEC

> **Status**: FINALIZED
> **Created**: 2026-06-11 (supersedes 2026-06-01 draft — stale paths, partially shipped)
> **Verified**: 2026-06-12 (deep audit confirmed 49/50 claims — see claude-audit-report.md)
> **Scope**: 9 skill files + 1 rules file + ROADMAP.md hygiene. Prose edits only, no code.

## Problem Statement

The audited failures are deterministic consequences of written contradictions between
the wf-* orchestration layer and the methodology skills it delegates to, plus gates
that print errors without stopping. Reproduced on this repo: `/execute 3.1` would mark
the phase Complete without executing anything (plan glob mismatch); `/plan 1` would
resolve an archived milestone's phase title. Fixes are grouped into seven contracts.

## Fix 1 — Execution contract: /plan output must be what /execute consumes
Files: `.agents/skills/writing-plans/SKILL.md`, `.agents/skills/wf-execute/SKILL.md`,
`.agents/skills/wf-plan/SKILL.md`, `.agents/rules/QUANTIS-STYLE.md`
- writing-plans: add required frontmatter (phase/plan/wave/gap_closure) to the plan
  header; filename rule `{N}.{M}-{plan-slug}-PLAN.md`, must end `-PLAN.md`.
- wf-execute Step 2: zero plans → STOP (never "already complete"); all-summarized →
  Step 5, never straight to Step 6. Step 3: missing wave → wave 1. Step 4.3: execute
  checkbox tasks (Run:/Expected:); legacy <task> XML supported for gap plans only.
  Step 4.5: per-plan summaries (`X-PLAN.md` → `X-SUMMARY.md`); define "matching".
- wf-plan Step 5: checklist items match the checkbox format (no <verify>/<done>).
Acceptance: `/execute` on a phase dir with only SPEC.md errors out; on this phase's
plans, discovers all plans; grep finds no `<task>` references in wf-execute Step 4.

## Fix 2 — Phase-dir resolution: one recipe in /plan, /execute, /verify
Files: `wf-plan`, `wf-execute`, `wf-verify` SKILL.md
- Shared recipe: reuse existing dir via find with sort; /plan derives new slugs from
  ANCHORED heading grep scoped to current milestone (LAST match); 0 matches → STOP
  with guidance ("pass full number e.g. 3.1"); >1 match → list and ask.
  Integer phase → subphase fallback (find `${PHASE}.*-*`).
Acceptance: dry-run prompts: `/plan 1` refuses or resolves only a current-milestone
heading; `/execute 3` errors with "pass the full number"; identical bash in all 3 files.

## Fix 3 — STOP semantics for all gates
Files: `wf-plan` (Planning Lock), `wf-execute` (validation + per-task verify gate),
`wf-new-milestone` (SPEC check + archive guard), `wf-complete-milestone` (incomplete-
phase check, final-verification routing, post-mv verification)
- Pattern: `**If any Error line printed: STOP. Do not continue to Step {next}.**` plus
  exit 1 where bash allows. wf-execute: task commit conditional on verify passing;
  wave-complete defined (all SUMMARYs + all verifies). wf-new-milestone: never truncate
  DECISIONS/JOURNAL without a verified archive copy.
Acceptance: every `|| echo "Error"` in the four files is followed by an explicit STOP
instruction; wf-new-milestone reset is guarded.

## Fix 4 — Completion ownership: /verify writes ROADMAP; /pause reconciles
Files: `wf-verify`, `wf-execute`, `wf-pause` SKILL.md
- wf-verify: PASS → ROADMAP ✅ (idempotent) + STATE; FAIL → STATE + ROADMAP 🔄 Gap
  closure; Step 6 commits VERIFICATION + ROADMAP + STATE with git-show self-check;
  PARTIAL branch added (browser-pending ⇒ never PASS); PASS banner routes /plan {N+1}.
- wf-execute: Step 4 sets 🔄 In Progress; Step 6 banner offers /verify {N}, drops
  /execute {N+1}.
- wf-pause: new "Reconcile ROADMAP.md" step (verdict-based, never SUMMARY-only);
  ROADMAP staged in pause commit.
Acceptance: after a simulated PASS, `git show --stat` lists ROADMAP.md; /pause output
shows the sync line; no offer_next routes to /execute {N+1}.

## Fix 5 — Methodology scope overrides (kills phantom modes and rogue terminals)
Files: `wf-discuss-phase`, `brainstorming`, `writing-plans`, `wf-execute`,
`subagent-driven-development`, `executing-plans`, `wf-stress-test` SKILL.md
- wf-discuss-phase: delete "discuss/explore mode"; follow checklist 1–8 incl. SPEC.md
  with explicit path recipe (same bash as /plan so dirs match); override item 9; add
  existence gate `test -f "$PHASE_DIR/SPEC.md"` before the completion banner, which
  gains a `Spec: {path} ✓` line; clarify phase-SPEC vs project-SPEC namespace.
- brainstorming: caller-override clause (steps 1–8 always; caller owns step 9); on user
  approval stamp `Status: FINALIZED` (closes the Planning Lock bypass); define {N}.{M}
  and slug with a worked example; never create a second dir for an existing phase.
- writing-plans: Execution Handoff never asks "Which approach?" — auto-select, or STOP
  with "Run /execute {N}" when invoked from /plan; plan-header blockquote loses
  "(recommended) or" menu phrasing.
- wf-execute: scope note — methodology executes ONE plan; skip its terminal
  finishing-a-development-branch / final-review steps; align no-subagent fallback with
  SDD inline mode (pick one, state it in both files); hoist selection above the loop.
- wf-stress-test: remove both brainstorming-mode references (framework is self-
  contained); write findings report to disk + commit; Step 5 mandatory when findings
  exist, stamps `Stress-tested: {date}`.
- using-quantis: fix /execute and /stress-test rows; add project-SPEC row to File
  Conventions; "Flexible skill" note: output artifacts are never skippable.
Acceptance: grep returns 0 for "discuss/explore mode" and "adversarial critique mode";
grep returns 0 for "Which approach?" in writing-plans; SPEC gate present in
wf-discuss-phase; stress-test names a report file path.

## Fix 6 — Rules-layer contradictions
Files: `.agents/rules/PROJECT_RULES.md`, `QUANTIS-STYLE.md`,
`context-health-monitor`, `systematic-debugging` SKILL.md
- PROJECT_RULES: Wave table — ordering not parallelism; token-efficiency exemptions for
  SKILL.md/state files; repo-tree cleanup (.quantis/examples/, root rules paths);
  commit-failure rule.
- QUANTIS-STYLE: Decision Gates scoped (never for auto-resolvable choices); canonical
  delegation pattern documented ("Read and follow ... as a numbered process step;
  subagent branches paste content, not paths"); canonical Platform Check block.
- 3-strike reconciliation across context-health-monitor / systematic-debugging /
  wf-execute (auto-save first; architectural pattern → discuss; else → /pause).
Acceptance: the three files cross-reference one 3-strike protocol; "Run in parallel"
absent from the wave table; delegation pattern section exists in QUANTIS-STYLE.

## Fix 7 — wf-verify structural repair + skill loading (carried from old SPEC Fix 3)
File: `wf-verify/SKILL.md`
- Close <context>; move Step 0 inside <process>; "Read and follow ... exactly" as the
  first action of Step 1; Step 0 subagent path explicitly resumes at Step 5 and pastes
  skill text + report format into the dispatch; standard skill-powered header.
Acceptance: file has matching open/close tags for all blocks (validate-workflows.sh
  extended to check tag balance); a numbered step contains the bold read-and-follow.

## ROADMAP hygiene (rider)
Update Phase 3.1's deliverables to wf-* paths; check off the two items 3.2 already
shipped; resolve the 3.2-depends-on-3.1 inversion; regenerate 3.1 plans from this SPEC.

## Out of Scope (→ Phase 3.4 "Verification Depth", Phase 3.5 "Subagent Maximization")
- Senior code review step in /verify (Issue 5 design in audit §6)
- Stress-test plan mode + /plan integration + external review (Issue 6 / audit H7)
- Subagent dispatch maximization + dispatching-parallel-agents wiring (Issue 7 / H11)
- State-schema unification (audit §4) — riskier, separate phase
- Error-path package (audit §4) — fold the cheap STOPs into Fix 3; rest deferred
