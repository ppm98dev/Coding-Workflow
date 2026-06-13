# Phase 3.4: Parallel-Dispatch Concurrency Cap & Rate Limits — SPEC

> **Status**: FINALIZED
> **Created**: 2026-06-13
> **Scope**: Prose edits to the dispatch skills + tool reference. No product code.

## Problem Statement

`/wf-stress-test` dispatched **7 `research` subagents simultaneously** ("invoked all together").
On agy (Claude Opus via the Antigravity quota), that burst blew the **per-minute model rate limit**,
returning `429 "exhausted your capacity. Your quota will reset after 0s."` — reproduced **twice** in a
real project (ARES_APP). The retry logic made it worse: misled by the "reset after **0s**" message, the
agent **re-dispatched the failed reviewers immediately**, hitting the wall again — a classic
"thundering herd" loop.

**It was systemic**, not stress-test-specific: every fan-out workflow dispatched "all together" with no
cap and no backoff — `wf-stress-test` (7), `wf-research-phase` (N questions), `wf-map` (5 domains),
`wf-debug-issue` (N hypotheses). The shared `dispatching-parallel-agents` skill and the
`antigravity-tools.md` reference had **zero** concurrency/rate-limit guidance.

**Ground truth (verified):**
- agy has **no built-in concurrency cap or backoff** — it passes every dispatch to the model, which
  enforces RPM/ITPM/OTPM ("burst within budget": you can be under your daily quota but at 100% of the
  current minute's bucket).
- The `"reset after 0s"` string is **not in the agy binary** — it's an unreliable upstream-API
  passthrough; immediate retry cannot help.
- **Empirically validated on the user's tier:** the agy agent recommended **≤3 concurrent**, and running
  with that cap **does not crash**.

## The Contract (Fix 1)
Every parallel subagent dispatch caps at **≤3 concurrent** (waves of ≤3). On a `429`/capacity error:
**wait — do not re-dispatch immediately** (ignore "reset after 0s") — retry that one once, then run the
domain **inline**; re-dispatch failures **one at a time**, never as a batch. The rule lives once in
`dispatching-parallel-agents/SKILL.md`; the fan-out workflows inherit it.

## Fixes
- **Fix 1 — `dispatching-parallel-agents/SKILL.md`**: new **"Concurrency Cap & Rate Limits (REQUIRED)"**
  section (≤3 cap, waves, 429 wait-then-retry-once-then-inline, no thundering herd); step-3 example
  annotated with the cap.
- **Fix 2 — `wf-stress-test/SKILL.md`**: "7 invoked all together" → **waves of ≤3**; the retry line now
  defers to the Rate-Limit rule (no immediate re-dispatch on 429).
- **Fix 3 — `wf-research-phase`, `wf-map`, `wf-debug-issue`**: dispatch in **waves of ≤3** (reference
  the Concurrency Cap).
- **Fix 4 — `antigravity-tools.md`**: document that `invoke_subagent` has no built-in cap/backoff →
  bound to ≤3 concurrent.

## Acceptance
- `dispatching-parallel-agents/SKILL.md` contains "Concurrency Cap" + "at most 3".
- No fan-out workflow still says "all invoked together" / "invoked all together" / "all together".
- `wf-stress-test` retry line references the rate-limit rule (no bare immediate re-dispatch).
- `validate-all.sh` green.
- Empirical: ≤3 concurrent confirmed non-crashing on the user's agy tier.

## Decisions
- **D-012** — ≤3 concurrency cap (waves) + wait-then-retry-once-then-inline on 429. `≤3` is a
  **validated default, tunable** (drop to 2 if a tier still limits), not a hard pin.

## Out of Scope
- Elaborate exponential-backoff-with-jitter spec — deliberately kept to "wait, retry once, inline."
  The cap is the load-bearing fix (empirically holds); heavier backoff machinery isn't needed and would
  over-complicate a quick fix. Revisit only if the cap proves insufficient on some tier.
- `wf-audit-milestone` — dispatches a **single** subagent, so the cap is trivially satisfied; no edit.

---

*Last updated: 2026-06-13*
