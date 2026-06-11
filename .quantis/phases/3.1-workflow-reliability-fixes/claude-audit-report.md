# Quantis Workflow System Audit

**Date:** 2026-06-11 · **Scope:** 24 files (10 workflows, 10 methodology skills, 3 rules, ROADMAP) plus on-disk state (`.quantis/phases/`, templates, scripts)
**Method:** 8 per-issue analysts + 8 systematic-review dimensions (delegation, clarity, hard gates, contradictions, dead references, state management, subagent dispatch, error handling), each finding adversarially re-verified against file content. 210 raw findings produced; sampled verification confirmed ~78% and the survivors below were additionally cross-checked by direct reading of every audited file. Live bugs (C1, C4) were reproduced against the repo's own files.

---

## 1. Executive Summary

The system's architecture is sound — thin `wf-*` orchestrators delegating to methodology skills is the right shape — but the two layers were authored separately (Quantis orchestration vs. forked Superpowers skills) and never reconciled, so they now form **two competing state machines**: the methodology chain (brainstorming → writing-plans → SDD → finishing-a-development-branch) prescribes its own artifacts, handoffs, menus, and terminal states that contradict the `wf-*` cycle (discuss → plan → execute → verify) that invokes it. Almost every "intermittent" reliability issue is a deterministic consequence of these written contradictions, not model disobedience: workflows invoke skill "modes" that don't exist, `/plan`'s delegated skill produces plans in a format `/execute` cannot parse (the discovery glob fails against the repo's own plan files — `/execute 3.1` today would mark the phase Complete having executed nothing), every gate is an `echo` with no STOP semantics, and phase-completion state has three half-owners so ROADMAP.md updates fall through the cracks. The fixes are almost entirely prose edits to ~12 files — no code — but they require one set of explicit contract decisions (plan format, spec locations, completion ownership, methodology scope overrides) rather than piecemeal patching.

---

## 2. Critical Issues (must fix — cause incorrect behavior)

### C1. `/execute` plan discovery misses real plans → phases marked Complete without execution
- **File:** `.agents/skills/wf-execute/SKILL.md` lines 45–50, 96–105; `.agents/skills/writing-plans/SKILL.md` line 18
- **Current:** Step 2 discovers plans via `ls "$PHASE_DIR"/*-PLAN.md` and says *"If no incomplete plans: phase already complete, skip to step 6"* — and Step 6 marks the phase `✅ Complete` in ROADMAP.md. The repo's own plans (`3.1-PLAN-A.md`, `3.1-PLAN-B.md`) do **not** match `*-PLAN.md` (verified: zsh reports "no matches found"). A phase directory containing only SPEC.md (the state `/discuss-phase` produces) triggers the same path.
- **Expected:** Zero plans = error, not completion. Naming convention enforced at the writer.
- **Fix:**
  1. wf-execute Step 2: replace the skip rule with:
     `If NO *PLAN*.md files exist: STOP — "No plans found for phase {N}. Run /plan {N} first." Do not touch ROADMAP.md or STATE.md. If every PLAN has a matching SUMMARY: skip to Step 5 (Verify Phase Goal) — never straight to Step 6.`
  2. writing-plans line 18: `**Save plans to:** .quantis/phases/{N}.{M}-{slug}/{N}.{M}-{plan-slug}-PLAN.md — the filename MUST end in -PLAN.md (never letter suffixes like 3.1-PLAN-A.md); /execute discovers plans by that suffix.`
  3. Rename the two existing on-disk plans to match.
- **Risk:** Widening/standardizing the glob may catch scratch files containing `PLAN`; mitigated by the suffix rule.

### C2. Plan format contract broken between `/plan` and `/execute` (frontmatter, XML vs. checkbox)
- **Files:** `wf-execute/SKILL.md:53` (wave frontmatter), `:77` (`<task>` blocks); `wf-plan/SKILL.md:166–174` (checks `<verify>`/`<done>`), `:185–191` (task_types); `writing-plans/SKILL.md:45–104`; `QUANTIS-STYLE.md:67–103`
- **Current:** `/execute` groups plans by a `wave` YAML field and follows `<task>` XML blocks; `/plan`'s checker validates `<verify>`/`<done>` XML tags. But the skill `/plan` delegates to ("follow **exactly**") mandates a frontmatter-less header and markdown checkbox tasks with `Run:`/`Expected:` lines. Neither artifact the system actually produces satisfies what the executor reads. QUANTIS-STYLE canonicalizes the XML format, deepening the conflict.
- **Fix (decide one format — recommended: writing-plans' checkbox format, since plans-are-prompts is the core philosophy and the real plans on disk use it):**
  1. writing-plans "Plan Document Header": prepend required frontmatter `--- phase: {N}.{M}, plan: {slug}, wave: {W}, gap_closure: false ---`.
  2. wf-execute Step 3: *"If a plan has no `wave` field, treat it as wave 1 — do not error, do not skip."* Step 4.3 → *"Execute the plan's `### Task N` sections in order, running each `Run:` command and checking output against `Expected:`. (Legacy `<task>` XML plans: run `<verify>` per block.)"*
  3. wf-plan Step 5 checklist: replace the two XML bullets with `- [ ] Every task has Run: commands with Expected: output` / `- [ ] Every task's final step has measurable acceptance`.
  4. QUANTIS-STYLE: mark the XML `<task>` structure as the format for *gap-closure fix plans only*, or migrate it to the checkbox format.
- **Risk:** Dual-format tolerance entrenches two formats; the legacy clause should carry a deprecation note.

### C3. Two competing state machines: methodology chain vs. wf-* orchestration (root cause of Issues 1 & 2)
- **Files:** `wf-discuss-phase/SKILL.md:42,51–60`; `brainstorming/SKILL.md:21–33,66,133–136`; `writing-plans/SKILL.md:134–153`; `subagent-driven-development/SKILL.md:93–94,112–113`; `executing-plans/SKILL.md:32–37`; `wf-stress-test/SKILL.md:7,44`
- **Current:**
  - `/discuss-phase` invokes brainstorming "in **discuss/explore mode**" — no such mode exists (grep-verified). Brainstorming's checklist mandates SPEC.md (step 6) and terminates by *invoking writing-plans* (step 9), bypassing `/plan` entirely; `/discuss-phase`'s own steps 3–4 end with DECISIONS.md + "suggest /plan". The model must improvise which contract wins — when it resolves "discuss mode = lighter than full checklist," SPEC.md is skipped (**Issue 1**).
  - writing-plans' Execution Handoff orders the model to ask *"Which approach?"* between subagent/inline — the exact menu `wf-execute:76` forbids ("This is NOT a choice. Do not present a menu.") (**Issue 2**'s real source).
  - SDD and executing-plans both terminate in *final whole-implementation review → finishing-a-development-branch* (merge/cleanup) — invoked **per plan** inside `/execute`'s wave loop, this would finish the branch mid-phase and skip `/execute` Steps 5–6.
  - `/stress-test` tells the model to "adopt **adversarial critique mode**" of brainstorming — also nonexistent; brainstorming is a collaborative design skill.
- **Fix (one pattern: workflows may scope-override delegated skills, and say so explicitly):**
  1. wf-discuss-phase Step 2 → `**Read and follow .agents/skills/brainstorming/SKILL.md, checklist items 1–8 in full** — including writing the spec to the phase directory and the user review gate. **Override:** do NOT execute item 9 (invoking writing-plans); this workflow ends at Step 5 below, suggesting /plan {N}.` Delete "in discuss/explore mode". (See C8/SPEC for the SPEC.md existence gate.)
  2. writing-plans Execution Handoff → `After saving the plan, announce the path and STOP if invoked from /plan ("Run /execute {N} to implement"). Never ask the user to choose an execution mode — selection is automatic (invoke_subagent available → subagent-driven-development; else → executing-plans).` Also fix the plan header blockquote ("subagent-driven-development (recommended) **or** executing-plans" reads as a menu).
  3. wf-execute Step 4, after methodology selection: `> **Scope note:** the methodology skill executes ONE plan. Skip its terminal steps (final whole-implementation review, finishing-a-development-branch) — Steps 5–6 below own phase-level verification and completion.`
  4. brainstorming, end of checklist: `**If invoked by a workflow command:** the caller may replace step 9, but steps 1–8 always apply — a design discussion that ends without a written, committed SPEC.md is incomplete regardless of any "mode" the caller names.`
  5. wf-stress-test: delete both brainstorming-mode references; the 7-dimension framework is self-contained (`Adopt an adversarial mindset: your job is to BREAK the spec...` already in the file).
- **Risk:** Hard-coding checklist numbering creates a cross-file coupling; name the carved-out step ("invoke writing-plans") as well as its number.

### C4. Phase-directory resolution: three strategies, two live failure modes
- **Files:** `wf-plan/SKILL.md:59–64`; `wf-execute/SKILL.md:39–44`; `wf-verify/SKILL.md:59–65`
- **Current:** `/plan` *constructs* the dir from an unanchored `grep -i "Phase $PHASE" ROADMAP.md | head -n 1` + slugification; `/execute` and `/verify` *find* by `-name "${PHASE}-*" | head -n 1`. Verified failures: (a) `/plan 1` on this repo resolves "Phase 1: Antigravity Integration" from the **archived v2.0 milestone** (first grep hit) → wrong slug → orphan directory; (b) `/execute 3` matches nothing against `3.1-…` (glob `3-*` ≠ `3.`); (c) multiple subphases → `head -n 1` silently drops siblings; (d) the bash also uses `$PHASE` before anything assigns it and contains a no-op `tr -d ''`.
- **Fix:** One shared resolution recipe, stated identically in all three files:
  ```bash
  # Reuse existing dir if present (keeps /plan, /execute, /verify consistent)
  MATCHES=$(find .quantis/phases -maxdepth 1 -name "${PHASE}-*" | sort)
  COUNT=$(printf '%s\n' "$MATCHES" | grep -c .)
  # 0 matches in /execute|/verify: STOP ("pass the full number, e.g. 3.1, or run /plan first")
  # 0 matches in /plan: derive slug from an ANCHORED heading grep, LAST match
  #   (current milestone is last in ROADMAP.md):
  #   grep -E "^#{2,4} Phase ${PHASE}: " .quantis/ROADMAP.md | tail -n 1
  # >1 match: list them and ask the user — never head -n 1 silently
  ```
- **Risk:** `tail -n 1` assumes current milestone is last in the file (true today; documented assumption). Unescaped `.` in `${PHASE}` is acceptable inside the anchored pattern.

### C5. Every gate is an `echo` — no STOP semantics anywhere in the system
- **Files:** `wf-plan/SKILL.md:50–54` (Planning Lock — the system's flagship gate per PROJECT_RULES:21); `wf-execute/SKILL.md:29–35`; `wf-new-milestone/SKILL.md:15–21`; `wf-complete-milestone/SKILL.md:14–26`
- **Current:** All four validation blocks are `test/grep … || echo "Error: …"` — the compound command exits 0, and no prose says what to do when the message prints. The next numbered step follows immediately. A model can print "Error: SPEC.md must be FINALIZED" and proceed to plan; print "⚠️ Cannot complete milestone" and proceed to archive + git tag.
- **Fix:** After each block, identical pattern: `**If any Error line printed: STOP.** Do not continue to Step {next}. Tell the user {remedy}. (⚠️ warnings are non-blocking.)` Where bash allows, also `exit 1` inside the failure branch.
- **Risk:** None meaningful. This is the highest leverage-per-character fix in the audit.

### C6. `/new-milestone` destroys unarchived DECISIONS.md and JOURNAL.md
- **File:** `wf-new-milestone/SKILL.md:91–110`
- **Current:** Step 5b unconditionally truncates both files to a bare header whenever they exceed 5 lines. The note admits archiving only happens "if running /complete-milestone first" — but nothing checks that it ran. Skipping `/complete-milestone` (which C5 currently allows even on failure) silently erases the project's decision log.
- **Fix:** Guard before the truncation: `If .quantis/milestones/ contains no archive of the current DECISIONS.md/JOURNAL.md, do NOT reset — archive both into .quantis/milestones/{prev-name}/ first (cp, then verify the copies exist), or ask the user to run /complete-milestone.`
- **Risk:** Slightly more ceremony when intentionally starting fresh; acceptable for a destructive operation.

### C7. Phase-completion state has three half-owners; ROADMAP.md falls through (Issue 4)
- **Files:** `wf-verify/SKILL.md:224–311`; `wf-execute/SKILL.md:96–105,116–124`; `wf-pause/SKILL.md:96–101`
- **Current:** Only `/execute` Step 6 ever writes `✅ Complete` — at the tail of the longest workflow, reachable only via its own internal PASS. `/verify` (the system's actual auditor, per wf-progress's "Phase done, not verified → /verify") updates **only STATE.md** on PASS, updates **nothing** on FAIL, and its Step 6 commits **only VERIFICATION.md** — even the STATE.md edit it just made is left uncommitted (consistent with this repo's currently-dirty STATE.md). `/execute`'s completion banner never offers `/verify`. `/pause` never reads or stages ROADMAP.md. The intermediate statuses `/progress` counts (`🔄 In Progress`) are never written by anyone.
- **Fix (ownership rule: whoever ends the phase writes ROADMAP; /pause is the safety net):**
  1. wf-verify Step 5 PASS: `**Update .quantis/ROADMAP.md — REQUIRED:** set the phase's Status line to ✅ Complete ({date}), check off its deliverables. Idempotent: if /execute already marked it, leave it.` FAIL: update STATE.md (`Status: ⚠ Verification failed — {Z} gaps; Next: /execute {N} --gaps-only`) and set ROADMAP status `🔄 Gap closure`.
  2. wf-verify Step 6: `git add "$PHASE_DIR/VERIFICATION.md" .quantis/ROADMAP.md .quantis/STATE.md` + self-check: `if verdict was PASS, git show --stat HEAD must list ROADMAP.md — if not, the Step 5 update was skipped: go back, then commit --amend`.
  3. wf-execute Step 4 opening: set phase `🔄 In Progress`; Step 6 keeps `✅ Complete` but the banner adds `▶ /verify {N} — independent verification (recommended)` and drops `/execute {N+1}` (no plans exist yet; also fix wf-verify:249 which routes to `/execute {N+1}` for the same reason — should be `/plan {N+1}`).
  4. wf-pause: insert Step 3 "Reconcile ROADMAP.md" (the existing Phase 3.1 SPEC's Fix 4, ported to `wf-pause/SKILL.md`): for each non-Complete phase with a directory, `VERIFICATION.md verdict: PASS` → mark Complete; all PLANs have SUMMARYs but no VERIFICATION → leave status, set Next Steps to `/verify {N}`. Stage ROADMAP.md in the pause commit.
- **Risk:** /verify touching historical sections on re-runs — mitigated by the idempotency clause. SUMMARY-only evidence must NOT mark Complete (over-eager sync) — hence the verdict-based rule.

### C8. `wf-verify` is structurally malformed and its skill delegation is outside the process (Issue 3)
- **File:** `wf-verify/SKILL.md:28–54` (and 36–38)
- **Current:** `<context>` opens at line 28 and is **never closed** (grep: no `</context>` in file). The verification-before-completion reference (line 36) and the only "read and follow" language (a lowercase blockquote, line 38) sit in that metadata block, and `## 0. Platform Check` (40–52) sits **outside** `<process>` (54–313). The numbered steps never load the skill. The three sibling workflows all use a bold "Read and follow `path`" as a numbered process step; wf-verify is the only one that doesn't — and the only one users report not loading its skill. Bonus: the subagent path (Step 0) tells the orchestrator to do exactly 3 things ending at "present results," orphaning Steps 5–6 (state update, gap plans, commit) — they're framed as inline-only.
- **Fix:**
  1. Close `<context>` after line 36; move `<process>` to open before `## 0`.
  2. New first action inside Step 1: `**Read and follow .agents/skills/verification-before-completion/SKILL.md exactly.** Its Gate Function (IDENTIFY → RUN → READ → VERIFY → only then claim) governs every must-have check below.`
  3. Step 0 orchestrator list → `…3. Proceeds to Step 5 (Handle Results) and Step 6 (Commit) — the subagent path skips Steps 1–4 ONLY.` And the dispatch must paste the skill text + VERIFICATION.md format into the subagent prompt (subagents don't inherit context).
  4. Add the standard header: `# /verify → verification-before-completion skill` + Skill-powered blockquote.
- **Risk:** Low; matches the already-working sibling pattern. (This is the existing SPEC's Fix 3, extended with the structural repair the SPEC missed.)

---

## 3. High Priority (confuse models / produce wrong-but-recoverable behavior)

### H1. Conflicting platform/fallback signals around execution mode (rest of Issue 2)
The no-menu rule in wf-execute is strong, but five surrounding texts undermine it:
- `wf-execute:75` routes no-subagent to **executing-plans**, while `subagent-driven-development:22–26` routes the identical condition to **inline SDD mode** — two different prescribed fallbacks for the same state. Pick one (recommended: inline SDD mode, preserving review gates) and align both files.
- `executing-plans:14`: "Antigravity 2.0 supports them natively" — told to exactly the models that don't have the tool. → `If invoke_subagent is in your tool list, use subagent-driven-development. If /execute routed you here, that check already failed — proceed without asking.`
- `using-quantis:109` maps `/execute` → executing-plans (stale; contradicts wf-execute:9).
- `using-quantis/references/antigravity-tools.md:21`: "Antigravity 2.0 supports subagents natively" → scope to CLI/Standalone, "absence is normal on IDE, never ask."
- `QUANTIS-STYLE.md:251–253` Decision Gates template legitimizes menus → scope it: `Never for anything a skill resolves automatically (execution mode, tool availability, platform detection).`
- `subagent-driven-development:46–62` "When to Use" decision tree routes coupled tasks away from SDD → add `When dispatched by /execute, skip this tree — the workflow already chose.`

### H2. PROJECT_RULES mandates parallel wave execution; SDD forbids it
`PROJECT_RULES.md:62–69` ("Run in parallel") vs `subagent-driven-development:269` ("Never: dispatch multiple implementation subagents in parallel") vs `wf-execute:81` ("sequential — one subagent per task"). The "Single Source of Truth" contradicts both executors. Fix the table: waves define *ordering constraints*, not parallelism; implementation is sequential; parallel dispatch is reserved for read-only investigation (dispatching-parallel-agents). Also fix SDD:236 "Parallel-safe" → "Isolated context per subagent; implementers still run one at a time."

### H3. Token-efficiency rules suppress the full skill reads the architecture depends on
`PROJECT_RULES.md:206–214` ("File >200 lines → outline, not full file"; ">5 files → stop") vs `using-quantis:26,36` (read the full SKILL.md). SDD alone is 316 lines. This plausibly contributes to Issues 1–3: a rules-compliant model skims delegated skills. Fix: add exemptions — `SKILL.md files invoked per using-quantis, .quantis/ state files, and any file a skill says to read completely are always read in full; the >5-file cap applies to source exploration only.`

### H4. Three conflicting prescriptions for the same "3 failed attempts" trigger
`context-health-monitor:27–37` (STOP → state dump → fresh session, "Do NOT continue") vs `systematic-debugging:192–213` (STOP → discuss architecture with partner, stay in session) vs `wf-execute:109–114` (document → recommend /pause). Reconcile: auto-save state first (always), then if failures match the architectural pattern → discuss in session; else → recommend /pause. State the precedence in all three files.

### H5. PARTIAL verdict defined but unrouted; browser-pending must-haves can PASS
`wf-verify:192,216` define `PASS | FAIL | PARTIAL`; Step 5 routes only PASS/FAIL. The CLI browser-handoff path (129–180) never says pending visual must-haves cap the verdict. Fix: pending items get `Status: PENDING-BROWSER`; any pending ⇒ verdict PARTIAL; add a `### If PARTIAL` branch (no completion claim, no "verified" in STATE.md, re-run /verify after evidence lands, stage BROWSER-VERIFY.md in the commit).

### H6. SUMMARY naming breaks resume logic
`wf-execute:79` creates `$PHASE-SUMMARY.md` (phase-named, once) inside a **per-plan** loop whose Step 2 resumes by "PLAN without matching SUMMARY" (undefined "matching"). Two plans → second overwrites first or first SUMMARY marks both complete. Fix: `for X-PLAN.md create X-SUMMARY.md`; define incomplete = `*-PLAN.md` lacking a same-prefix `*-SUMMARY.md`.

### H7. Stress-test produces no artifact and is integrated with nothing (Issue 6)
`wf-stress-test:87–106`: the findings report has no file destination, no commit — findings die with the session. Nothing invokes stress-test programmatically; `/plan`'s only gate is the FINALIZED grep; `/plan`'s Step 5 checker is the plan's own author re-reading it (writing-plans' Self-Review even says "not a subagent dispatch" — while an orphaned `plan-document-reviewer-prompt.md` sits unused in the same directory). Fix package:
1. Stress-test writes its report to disk (`.quantis/STRESS-TEST.md` or `$PHASE_DIR/STRESS-TEST.md`), stamps `Stress-tested: {date}` into the spec, gates on critical findings ("STOP: fix criticals before /plan").
2. Stress-test gains a **plan mode** (target matches `*PLAN*.md` → reinterpret the 7 dimensions for plans: every spec requirement maps to a task, verify commands real, etc.).
3. `/plan` Step 1.5: spec stress-test gate (skippable via `--skip-stress-test` / `--gaps`); Step 5 becomes **adversarial plan review** — fresh-context subagent running stress-test plan mode when `invoke_subagent` exists, the orphaned reviewer prompt template inline otherwise; unresolved issues after 3 iterations → STOP and ask (today "max 3 iterations" has no exit defined).
4. Optional external-model review can hang off the same Step 5 output (the findings file is the interchange format).

### H8. Gap-closure has three owners, two formats, no loop cap
`wf-verify:254–282` creates XML fix plans itself; `wf-plan:21` declares `--gaps` ("reads VERIFICATION.md") but its process never specifies it; `wf-execute:94` routes to `--gaps-only` which filters on `gap_closure: true` frontmatter that wf-verify's template includes but wf-plan's path never mentions. And verify→gaps→execute→verify can loop forever. Fix: wf-verify *routes* (`Run /plan {N} --gaps`) instead of authoring; wf-plan gets a real `3b. Gaps mode` step (read VERIFICATION.md, one fix plan per FAILed must-have, `gap_closure: true`, `wave: 1`, `-PLAN.md` suffix, skip research); add `Gap-closure limit: same must-have fails after 2 rounds → architectural problem: systematic-debugging Phase 4.5 + ask the user.`

### H9. The brainstorming→writing-plans path bypasses the Planning Lock
`PROJECT_RULES:21` declares the lock; only `/plan` enforces it. brainstorming's flow (user approves spec → invoke writing-plans) never stamps `FINALIZED` nor checks it. Fix: brainstorming's user-review gate, on approval: `set Status: FINALIZED in the spec and commit — this satisfies the Planning Lock`; writing-plans Overview: `confirm the spec is FINALIZED before writing any plan; if not, stop and get the spec approved.`

### H10. `checkpoint:human-verify` tasks vs. SDD's "do not pause between tasks"
`wf-plan:185–191` defines checkpoint task types; `SDD:14` forbids stopping ("Should I continue?" prompts waste time). A checkpoint task inside an SDD-executed plan is contradictory. Fix SDD:14: add `…or a task explicitly typed checkpoint:* — those exist to stop you; present them and wait.`

### H11. Subagent dispatch blocks under-specify and orphan tail steps (Issue 7)
Dispatch exists in 4 workflows (discuss-phase, stress-test, verify, plan-Step-4) + SDD; written five different ways; only two say "don't ask the user." None instructs **pasting content** (subagents don't inherit context — "the brainstorming skill in adversarial critique mode" and "the writing-plans skill instructions" are name-drops the subagent can't resolve unless told to read the path or given the text). Stress-test/verify Step 0 paths end at "present findings," orphaning their Steps 5–6. `dispatching-parallel-agents` is referenced by zero workflows (its natural homes: stress-test dimensions — 7 independent read-only analyses, the clearest parallel win in the system; debug hypotheses; research questions; map domains). It also assumes `invoke_subagent` unconditionally (no IDE fallback), as does `requesting-code-review:32` despite "Mandatory" reviews. Fix: one canonical Platform Check block in QUANTIS-STYLE (Step 0, MUST-dispatch-when-available, paste-don't-reference contract, return format, "then continue at Step N"), applied to all five sites; wire dispatching-parallel-agents into wf-stress-test (per-dimension fan-out), wf-debug-issue, wf-research-phase; add inline fallbacks to dispatching-parallel-agents and requesting-code-review.

### H12. `/execute` Step 4's verify→commit sequence has no conditional
`wf-execute:77–78`: "run `<verify>` commands" then "Commit per task" — nothing says the commit depends on the verify passing, and no failure path exists for a failing verify mid-wave ("Verify wave complete" is also undefined). Fix: `**GATE:** each task's verify must RUN and PASS (read the output) before that task is committed; on failure → systematic-debugging; 3 strikes → record BLOCKED in STATE.md, finish other plans, do not mark the wave complete.` Define wave-complete = every plan has its SUMMARY + all verifies passed (cross-ref PROJECT_RULES' Wave Completion Protocol, which wf-execute never cites).

---

## 4. Medium Priority

**State-file schema unification**
- STATE.md has 4+ competing schemas (templates/state.md frontmatter format vs wf-pause's dump vs wf-verify's 2-line snippet vs context-health-monitor/auto-save sections); `/resume-session` can only parse wf-pause's. → Make wf-pause's schema canonical in `templates/state.md`; all other writers edit fields in place (wf-verify's PASS snippet currently *replaces* the file's Current Position, destroying Context Dump/Next Steps that resume needs — add "edit only these fields, preserve other sections").
- DECISIONS.md: two formats (`D-{NNN}` in wf-discuss-phase vs `[DECISION-XXX]` in the template) + two writers with none (stress-test, context-health-monitor). → standardize on `D-{NNN}`.
- JOURNAL.md cadence: per-task (SDD:313) vs per-session (executing-plans:83, wf-pause). → one session entry, newest-first; SDD accumulates and writes once.
- Bare "Update STATE.md" with no fields in wf-discuss-phase:60, wf-stress-test:105, wf-map, wf-complete-milestone:87 → give each a 3-line field list.
- ROADMAP statuses read but never written: nothing writes `🔄 In Progress` (wf-progress counts it; covered by C7 fix 3); wf-progress's legend (⏸️ = Blocked) mismatches real usage (⏸ = CLOSED/SUPERSEDED).
- wf-execute Step 6 updates REQUIREMENTS.md but doesn't stage it in the commit.

**Error paths (define once, reference everywhere)**
- Subagent dispatch failure undefined in all 4 dispatching workflows → `re-dispatch once with feedback; second failure → fall back inline and say so.`
- `/verify` on a never-executed phase (plans, no SUMMARYs) → STOP "run /execute {N}", don't create gap plans.
- `/execute`/`/verify` with no phase argument → read current phase from STATE.md; ambiguous → list and ask. Guard the bash (`[ -z "$PHASE" ]`).
- `/resume-session` with missing/stub STATE.md → reconstruct from ROADMAP + `git log` + PLAN-without-SUMMARY; say so. Uncommitted-changes step needs a procedure (diff against STATE.md's In-Progress list; offer wip-commit vs continue) instead of "Review before proceeding."
- Git failures (hooks, merge-in-progress, detached HEAD, nothing-to-commit) unhandled in 6 workflows → one Commit Failure Rule in PROJECT_RULES, referenced.
- SDD: review loops unbounded ("Repeat until approved") → 3 rejections = BLOCKED protocol; final-review node has no rejection branch; DONE status taken on faith → `git log/diff --stat` check first (verification-before-completion explicitly forbids trusting agent reports).
- wf-plan Step 3.5 ecosystem discovery: breaks when MANIFEST.md absent (every core skill reported "custom"); MCP probe hardcodes the IDE path `$HOME/.gemini/antigravity-ide/mcp` (always "None connected" on CLI — the platform Phase 3.2 made primary).
- `/complete-milestone` Step 1 greps the whole multi-milestone ROADMAP (archived `⏸ CLOSED` milestones contain "Not Started"/"In Progress" text) → slice the current-milestone section first; Step 4's `mv .quantis/phases/*` needs a post-move verification before Step 5 resets anything.
- CONSTITUTION.md ships `[PROJECT_NAME]` + 7 articles of `[FILL: …]` loaded "on every run" → rule: unfilled `[FILL]` = first option is the default; optional grep warning in /plan//execute.

**Other**
- **Branch policy gap:** SDD and executing-plans both forbid implementing on main/master without explicit consent and require `using-git-worktrees` isolation — but `wf-execute`, the orchestrator that invokes them, has no branch/worktree step anywhere (Steps 1–6 commit directly to the current branch). → Add a Step 1.5 Branch Check: on main/master, get consent or create `phase-{N}` branch before executing.
- wf-new-milestone Step 4 template reads as a full-file overwrite of the accumulating ROADMAP → "Append; update the Current Milestone line; preserve previous milestones."
- wf-plan "2–3 tasks max. No exceptions" vs writing-plans (no cap) and SDD's 5-task example → put the cap in writing-plans, fix the example.
- Commit scope: writing-plans templates emit `feat: …` without the mandatory `(phase-N)` scope.
- wf-plan's frontmatter description claims it decomposes requirements into ROADMAP phases; its process requires phases to already exist (that's /new-milestone's job).
- "Auto-detect next unplanned phase" is undefined → define: lowest phase in current milestone with status ⬜/🔄 and no `*-PLAN.md` in its directory; confirm with user.
- 25 templates exist but no workflow copies them ("Copy, don't reference" notwithstanding) — formats are re-inlined and drift (the STATE/DECISIONS divergences above are the symptom). Either wire `cp` instructions or delete the unused template fields (state.md "Active Decisions", roadmap.md Progress/Timeline tables, SUMMARY duration metadata — written by no one, read by no one).
- Context-% triggers ("50–70% usage") are unmeasurable by the model → replace with observable proxies (N tool calls, N full files read, platform warning).
- using-quantis "not negotiable" vs "user instructions always take precedence" — reconcile the all-caps block with one clause.

## 5. Low Priority

- Dead/wrong references: `skills/brainstorming/visual-companion.md` (→ `.agents/skills/...`); `/debug` in wf-verify:348 (→ `/debug-issue`); "Rule 3 in GEMINI.md" in context-health-monitor:105 (no such rule; → PROJECT_RULES § Context Management); `.quantis/examples/` and root-level rules files in PROJECT_RULES' repo tree; empty Adapter Pattern code block; QUANTIS-STYLE's orphaned "Read-only documentation and examples." line and its claim that core rules auto-load from `.gemini/GEMINI.md` (vs PROJECT_RULES self-declaring SSoT); `elements-of-style:…`, `frontend-design`, `mcp-builder` upstream skill names in brainstorming; `deployment-plan.md` example in requesting-code-review; `STACK.md` ordered updated but defined nowhere; unexplained `// turbo` annotation in wf-verify.
- `self`/`research` subagent types ARE defined (antigravity-tools.md:50–52) but every dispatch site name-drops them without that pointer — add the reference once per file or inline the definition.
- Severity taxonomies differ (Critical/High/Medium/Low vs Critical/Important/Minor) across stress-test vs code review.
- QUANTIS-STYLE bans celebration; wf-progress says "Celebrate! 🎉" and wf-complete-milestone has a step named Celebrate.
- requesting-code-review: no re-review loop after fixes outside SDD; BASE_SHA example can silently return empty.
- wf-execute nests methodology selection inside the per-plan loop (re-select/re-read per plan) — hoist above the loop.
- brainstorming "create a task for each item" names no mechanism; soft "should" language in wf-pause auto-save and context-health-monitor's core obligation → MUST.
- SDD Model Selection has no mechanism on platforms whose invoke_subagent takes no model param — add "skip if unsupported; map plan `effort` attribute when present."
- ROADMAP.md hygiene: Phase 3.2 `✅ Complete` "Depends on: Phase 3.1 (⬜)"; 3.1's deliverable for execute.md is already shipped by 3.2 but unchecked; stale `.agent/workflows` filenames (see SPEC below).

---

## 6. Known Issues 1–8 — Verdicts

| # | Issue | Root cause | Confidence in fix |
|---|-------|-----------|-------------------|
| 1 | SPEC.md not always produced | **Design flaw** — wf-discuss-phase never names the artifact; phantom "discuss/explore mode" licenses skipping checklist 6–9; no existence gate; project-vs-phase SPEC namespace collision invites "it already exists" | High (C3.1 + gate below) |
| 2 | /execute asks about subagent mode | **Design flaw** — the prohibition is fine; writing-plans' handoff menu, the plan-header "recommended or", conflicting fallbacks, stale tables, and the unscoped Decision Gates template re-inject the menu | Medium-high (C3.2 + H1) |
| 3 | /verify doesn't load its skill | **Design flaw** — delegation lives in an unclosed `<context>` block, never a process step; only workflow without the pattern | High (C8) |
| 4 | ROADMAP not updated | **Design flaw** — diffusion of responsibility; /verify writes nothing, /pause checks nothing, only /execute's tail step owns it | Medium-high (C7) |
| 5 | No senior code review in /verify | **Missing capability** — nothing in the verification path reviews code quality; SDD's reviewers frequently never run (IDE inline mode, or plans executed via executing-plans) | Medium (design below) |
| 6 | Plan quality inconsistent | **Missing integration** — stress-test orphaned (no artifact, no invoker, no plan mode); plan checker is same-author review | Medium (H7) |
| 7 | Subagents under-used | **Design flaw** — dispatch optional/conditional, prompts under-specified, tail steps orphaned, dispatching-parallel-agents referenced by nothing | Medium (H11) |
| 8 | E2E never tested | **Confirmed broken by inspection** — C1/C2/C4/H6 are exactly the breaks an E2E run would hit; the repo's own Phase 3.1 artifacts already demonstrate C1 | High (fixes above + dogfood run) |

**Issue 5 design (senior code review):** new Step 4 in `/verify` (between must-have verification and report writing), not a separate workflow — /verify already owns the quality gate and the gap-closure remediation loop. Scope = files changed in the phase, derived from git (`git log --grep="(phase-$PHASE)"` → BASE_SHA..HEAD, SUMMARY "files changed" as fallback) — never the full codebase. Mechanism: `invoke_subagent` available → dispatch reviewer(s) with the `requesting-code-review/code-reviewer.md` template + the diff, batching files if large; IDE → inline file-by-file review against the same template. Relationship to SDD's code-quality-reviewer: complementary backstop (task-scoped gate during /execute vs phase-scoped sweep at /verify). Verdict integration: PASS additionally requires zero unresolved Critical/Important review findings; findings feed the same gap-closure plans. Report section added to VERIFICATION.md (+ template).

---

## 7. Proposed Phase 3.1 SPEC.md

> Replaces `.quantis/phases/3.1-workflow-reliability-fixes/SPEC.md`. The existing SPEC (2026-06-01) is stale: it targets `.agent/workflows/*.md` paths deleted by Phase 3.2, and its Fix 2 (deterministic SDD in /execute) already shipped in 3.2. Both existing PLAN files target the deleted paths and must be regenerated. Scope below is re-cut from this audit: reliability-critical fixes only; capability work (senior code review, stress-test integration, subagent maximization) goes to Phases 3.4/3.5.

```markdown
# Phase 3.1: Workflow Reliability Fixes — SPEC

> **Status**: FINALIZED
> **Created**: 2026-06-11 (supersedes 2026-06-01 draft — stale paths, partially shipped)
> **Scope**: 9 skill files + 1 rules file + ROADMAP.md hygiene. Prose edits only, no code.

## Problem Statement

The audited failures are deterministic consequences of written contradictions between
the wf-* orchestration layer and the methodology skills it delegates to, plus gates
that print errors without stopping. Reproduced on this repo: `/execute 3.1` would mark
the phase Complete without executing anything (plan glob mismatch); `/plan 1` would
resolve an archived milestone's phase title. Fixes are grouped into six contracts.

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
- Rename the two on-disk 3.1 plan files to the new convention.
Acceptance: `/execute` on a phase dir with only SPEC.md errors out; on this phase's
renamed plans, discovers 2 plans; grep finds no `<task>` references in wf-execute Step 4.

## Fix 2 — Phase-dir resolution: one recipe in /plan, /execute, /verify
Files: `wf-plan`, `wf-execute`, `wf-verify` SKILL.md
- Shared recipe: reuse existing dir via find; /plan derives new slugs from ANCHORED
  heading grep, LAST match; 0 matches → STOP with guidance ("pass full number e.g. 3.1");
  >1 match → list and ask. Fix `$PHASE` assignment and the no-op `tr -d ''`.
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
```

---

## 8. Audit limitations

The adversarial verification pass was stopped early for cost (23 of 210 verdicts ran; 18 confirmed, 5 refuted — refuted items were dropped or downgraded above, and every Critical/High item in this report was independently confirmed against the actual files). The completeness critic did not run; coverage of the 20 non-audited `wf-*` skills (install/upgrade/sprint/add-phase/audit-milestone/…), template contents, and `scripts/` is partial — findings that surfaced incidentally are included, but those areas have not been swept systematically.

**Raw material:** the full unabridged output — all 8 issue analyses with 56 verbatim proposed fixes (exact current text → replacement text), all 210 dimension findings with diff-style fixes, the 6 issue-fix skeptic verdicts, and the 23 sampled finding verdicts — is preserved in [`claude-audit-findings-raw.md`](claude-audit-findings-raw.md). This report deduplicates and prioritizes; a handful of very minor items (single-line metadata-table fixes, soft-language tightening, e.g. wf-plan's `<related>` brainstorming row, wf-complete-milestone Step 2's missing verification-skill delegation, `/progress` behavior when two phases are 🔄, SDD's `define_subagent` fallback) appear only in the raw file. When implementing, use the raw file for the exact replacement prose — the fixes there are written to be applied directly.
