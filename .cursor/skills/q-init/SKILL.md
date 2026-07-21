---
name: q-init
description: Initialize project tracking — short questioning, then ROADMAP.md (intent + phases) and STATE.md
disable-model-invocation: true
---

# /q-init — set up tracking

## 1. Guard

If `.quantis/ROADMAP.md` exists → STOP, suggest `/q-status`. Run `git init` if no repo.

## 2. Understand the project

Ask what they're building, then follow the thread — users, the problem, what's explicitly out of scope, what "done" looks like. A brainstorming skill (e.g. superpowers) may drive the technique; its findings land HERE, in the roadmap header — a per-feature design doc is not a substitute, and do not follow a plugin handoff into plan-writing (that's `/q-next`'s job, after FINALIZED).

For an existing codebase, skim the code first (structure, stack, entry points) so questions and phases are grounded.

Mark anything unresolved as `[NEEDS CLARIFICATION: question]`. Stop asking when you could defend the scope to a stranger.

## 3. Write `.quantis/ROADMAP.md`

Use the schema in `.quantis/templates/roadmap.md`: intent header (Vision, Non-Goals, Success Criteria, `Status: DRAFT`), 3–5 phases with objectives, and an empty Decisions section. `Status: FINALIZED` only when no `[NEEDS CLARIFICATION]` markers remain — the Planning Lock gates on this line.

## 4. Write `.quantis/STATE.md`

From `.quantis/templates/state.md` — position: "Phase 1 not started", next step: `/q-next`.

## 5. Optional: quality standards

Offer (skippable): capture standards (testing policy, error handling, dependency policy…) as `.cursor/rules/constitution.mdc` with `alwaysApply: true`.

## 6. Commit + report

```bash
git add .quantis/ .cursor/rules/constitution.mdc 2>/dev/null; git commit -m "chore: initialize Quantis tracking"
```

Report what was created and whether Status is DRAFT (resolve markers first) or FINALIZED (ready: `/q-next` plans Phase 1).
