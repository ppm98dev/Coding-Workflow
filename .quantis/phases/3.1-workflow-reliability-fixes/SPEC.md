# Phase 3.1: Workflow Reliability Fixes — SPEC

> **Status**: FINALIZED
> **Created**: 2026-06-01
> **Scope**: 4 workflow files, 0 skill files

---

## Problem Statement

Four intermittent reliability issues exist across Quantis workflows. They are not caused by missing instructions — the instructions exist but are either too weak, ambiguously placed, or easily ignored by the model under heavy context. Three issues occur sometimes; one (verify not loading skill) occurs consistently.

---

## Fix 1: `discuss-phase.md` — Always Produce SPEC.md

### Problem
Line 29 says to use brainstorming in **"discuss/explore mode"**. The brainstorming skill has no concept of "modes" — it's a single linear checklist that ends with writing a SPEC.md. The "discuss/explore mode" qualifier gives the model implicit permission to skip the later checklist steps (spec writing, self-review, user review).

### Root Cause
Ambiguous qualifier in the workflow undermines the skill's own hard requirements.

### Fix
- **Remove** the phrase "in discuss/explore mode" from Step 2
- **Replace** with explicit instruction: "Read and follow `.agents/skills/brainstorming/SKILL.md` — complete the full checklist including writing SPEC.md"
- **Add** a post-brainstorming gate: after the brainstorming skill completes, verify that a SPEC.md was created in the phase directory before proceeding to Step 3

### Acceptance Criteria
- The workflow text contains no "mode" qualifiers when invoking brainstorming
- The workflow explicitly requires SPEC.md creation
- A verification step confirms SPEC.md exists before moving to decision documentation

---

## Fix 2: `execute.md` — Deterministic SDD Usage

### Problem
Step 4.2 (line 72) says: "When subagents are available, **prefer** `.agents/skills/subagent-driven-development/SKILL.md`". The word "prefer" is ambiguous — models interpret it as "ask the user which one they prefer" and present a menu:

```
Two execution options:
1. Subagent-Driven (recommended)
2. Inline Execution
Which approach?
```

Additionally, models sometimes refuse to use SDD for sequential tasks, incorrectly believing SDD requires parallel execution. SDD is sequential by design — it dispatches one subagent per task, one at a time.

### Root Cause
1. "prefer" is not deterministic — it invites a choice
2. Models confuse "subagent" with "parallel" and opt out for sequential work

### Fix
- **Replace** the "prefer SDD" line with a deterministic rule: on Antigravity, **always** use SDD. No menu, no choice, no asking.
- **Add** a mandatory announcement: the model must state "I'm using Subagent-Driven Development to execute this plan." before starting any task
- **Add** a clarification note: SDD executes tasks sequentially (one subagent at a time). It is not about parallelism — it is about fresh context per task and two-stage review gates.
- **Keep** `executing-plans` as fallback only for non-Antigravity environments (if those ever exist)

### Acceptance Criteria
- The workflow text contains no "prefer" or "when available" qualifiers
- The workflow unconditionally loads SDD skill on Antigravity
- The workflow requires the model to announce "I'm using Subagent-Driven Development" before execution
- The workflow includes a note clarifying SDD is sequential, not parallel

---

## Fix 3: `verify.md` — Explicitly Load Verification Skill

### Problem
The reference to `verification-before-completion` skill is buried inside a `<context>` block (lines 35-37), which is metadata — not an action step. The actual numbered process steps (1-6) never say "Read and follow the skill." Compare with `/plan` and `/execute` which both have explicit "Read and follow" instructions inside their process steps.

### Root Cause
Skill reference is in the wrong location (metadata vs. action step). Models treat `<context>` as background info, not as instructions to execute.

### Fix
- **Add** a new Step 1.5 (between current Step 1 "Load Verification Context" and Step 2 "Extract Must-Haves") that explicitly says: "**Read and follow `.agents/skills/verification-before-completion/SKILL.md`** for the full verification methodology."
- **Keep** the existing `<context>` reference as supplementary documentation — don't remove it, just add the action step

### Acceptance Criteria
- A numbered process step explicitly instructs the model to read and follow the verification skill
- The instruction uses the same pattern as `/plan` and `/execute` ("Read and follow `.agents/skills/...`")
- The existing `<context>` reference remains intact

---

## Fix 4: `pause.md` — Roadmap Sync Check

### Problem
After finishing a phase, the model sometimes fails to update ROADMAP.md (marking the phase ✅ Complete) and STATE.md. The instructions exist in `/execute.md` Step 6 and in both execution skills, but they're at the tail end of long files and get dropped under heavy context. Since `/pause` is the natural end-of-session checkpoint, it's the ideal place to add a safety net.

### Root Cause
State-update instructions are at the bottom of long execution files and get ignored. No safety net exists at the pause boundary.

### Fix
- **Add** a new Step 1.5 (between current Step 1 "Capture Current State" and Step 2 "Add Journal Entry") called "Roadmap Sync Check"
- The step should:
  1. Read ROADMAP.md and check if any phases that were worked on this session are still marked as not-started or in-progress when they should be complete
  2. Cross-reference with the phase directory — if SUMMARY.md files exist for all plans in a phase, that phase is complete
  3. If mismatches found: update ROADMAP.md to mark completed phases as `✅ Complete`
  4. Report what was synced in the pause output
- This is a **safety net** — it catches what `/execute` Step 6 should have done but didn't

### Acceptance Criteria
- The pause workflow includes a roadmap sync check step before state capture
- The step checks for phases with completed work (SUMMARY.md exists) that aren't marked ✅ in ROADMAP.md
- Mismatches are auto-corrected and reported in the pause output
- The check does NOT interfere with normal pause behavior if everything is already in sync

---

## Scope Boundaries

### In Scope
- `discuss-phase.md` — Remove mode qualifier, enforce SPEC.md
- `execute.md` — Deterministic SDD, mandatory announcement
- `verify.md` — Add skill-loading step
- `pause.md` — Add roadmap sync check

### Out of Scope
- Skill files (brainstorming, executing-plans, SDD, verification-before-completion) — no changes
- Other workflows — no changes
- New features — this is purely reliability fixes
