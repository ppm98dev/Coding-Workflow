---
name: q-next
description: The conductor — read ROADMAP + STATE, determine the current stage, and route to the right methodology skill (brainstorm, plan, build, verify), then record the outcome
disable-model-invocation: true
---

# /q-next — advance the project one stage

You are the conductor. The methodology skills (superpowers, Cursor Plan Mode, or whatever is installed) do the actual work — your job is to know where the project stands, invoke the right one, and record what happened. **One stage per invocation** — finish it, update state, stop, and tell the user what `/q-next` will do next time.

## 1. Locate

Read `.quantis/ROADMAP.md` and `.quantis/STATE.md`. If ROADMAP.md is missing → STOP, suggest `/q-init`. If STATE.md contradicts ROADMAP.md, trust ROADMAP + git log, and say so.

## 2. Determine the stage — first match wins

| Condition | Stage → what to do |
|-----------|-------------------|
| ROADMAP header `Status: DRAFT` or open `[NEEDS CLARIFICATION]` markers | **DEFINE** — resolve the open questions with the user (a brainstorming skill may assist), then set `Status: FINALIZED`. No planning or code before this. |
| No phase 🔄, next ⬜ phase has no `Plan:` link | **PLAN** — hand off to the planning skill (superpowers `writing-plans`, or suggest Cursor Plan Mode). Let it save the plan in its own home. Then add `Plan: {path}` to the phase entry and flip it to 🔄. |
| Current 🔄 phase's linked plan has unchecked tasks | **BUILD** — hand off to the execution workflow (superpowers subagent-driven-development / executing-plans). The plugin tracks tasks; you only update STATE.md's position when the hand-off returns. |
| Linked plan fully checked, no `VERIFICATION.md` for the phase | **VERIFY** — check the result against the phase objective and the roadmap's success criteria, with empirical evidence (run commands, capture output). Write `.quantis/phases/{N}-{slug}/VERIFICATION.md` with `verdict: PASS` or `verdict: FAIL` + gaps. PASS → flip phase to ✅. FAIL → list gaps in the phase entry; next `/q-next` routes them back to BUILD. |
| All phases ✅ | **MILESTONE** — confirm the roadmap's success criteria are met (evidence, not vibes). Then offer: archive `.quantis/phases/*` → `.quantis/archive/{milestone}/`, append a short milestone summary there, and define the next milestone's phases with the user (or stop here if the project is done). |

## 3. Record

After the stage completes:
- Update the phase's Status / `Plan:` link / gaps in ROADMAP.md
- Update STATE.md (position, what just happened, next step)
- Commit: `docs(phase-N): {what advanced}` — confirm with `git log -1`

## 4. Report

Tell the user: what stage ran, what changed, and what the next `/q-next` will do.

## Precedence

Auto-invoked plugin skills are sub-procedures here: use their technique, but this workflow's gates win — no code while DRAFT, no skipping VERIFY, no plugin handoff past the current stage. Roadmap edits (add/remove/reorder phases, rename milestone) need no skill: edit ROADMAP.md per the schema in `.cursor/rules/quantis.mdc` when the user asks.
