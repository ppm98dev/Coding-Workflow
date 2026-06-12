# Verification Prompt for Claude

---

We took your audit report and built 4 implementation plans (2 waves) to fix everything. Before we execute, verify our plans against your own findings.

## The Plans

**Wave 1:**
1. **execution-contract-and-gates** (Fixes 1+3) — 3 tasks: writing-plans format contract, wf-execute discovery/format/SUMMARY/banner, gate STOP semantics across wf-plan/wf-new-milestone/wf-complete-milestone
2. **phase-resolution-and-verify-structure** (Fixes 2+7) — 2 tasks: unified phase-dir resolution in all 3 workflows, wf-verify structural repair (close tags, move Step 0, skill loading, PARTIAL verdict, subagent resumption at Step 5)

**Wave 2 (depends on Wave 1):**
3. **completion-ownership** (Fix 4) — 3 tasks: wf-verify writes ROADMAP on PASS/FAIL, wf-execute sets 🔄 In Progress + banner offers /verify, wf-pause ROADMAP reconciliation
4. **methodology-overrides-and-rules** (Fixes 5+6) — 4 tasks: kill phantom modes + SPEC gate + Planning Lock closure, methodology fallback alignment (SDD inline as single fallback) + checkpoint exception + terminal step scoping, rules contradictions (waves=ordering, token exemptions, delegation pattern, 3-strike reconciliation), ROADMAP hygiene rider

## Verify Against Your Audit

For each item, give PASS / FAIL / PARTIAL with a one-line reason.

1. **Coverage** — Map each of your findings (C1-C8, H1-H12, Medium items) to a specific plan task. Flag any finding with NO fix.

2. **Contradictions** — Plans 1+4 both edit wf-execute. Plans 2+3 both edit wf-verify. Do any edits conflict?

3. **Missing fixes** — We declared these out of scope: STATE.md 6 schemas, DECISIONS.md dual format, JOURNAL cadence split, 7 bare "Update STATE.md" instances, requesting-code-review + dispatching-parallel-agents missing IDE fallback. Is that the right call, or should any of these be in scope?

4. **Wave ordering** — Plan 3 edits wf-verify assuming Plan 2's structural repair is done. Plan 4 edits wf-execute assuming Plan 1's changes are in. Any circular dependency or merge risk?

5. **Prose-edit feasibility** — Are the replacement texts specific enough for an AI agent doing find-and-replace on the actual files?

6. **Acceptance criteria** — Every task ends with grep verification. Any gaps?

7. **Biggest risk and what you'd change** — Be brutally honest.
