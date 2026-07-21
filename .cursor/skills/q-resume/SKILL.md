---
name: q-resume
description: Restore context from the previous session and continue
disable-model-invocation: true
---

# /q-resume — pick up where we left off

## 1. Load

Read `.quantis/STATE.md` fully. If missing or a stub, don't invent a position — reconstruct from ROADMAP.md (lowest non-✅ phase), `git log --oneline -15`, and the linked plan's checkboxes (plus `.superpowers/sdd/progress.md` if present), then ask the user to confirm the reconstruction. Nothing to reconstruct → suggest `/q-init`.

## 2. Brief the user

Last position, session summary, context dump (approaches tried, hypothesis), blockers, and the saved next steps — compact, not a wall.

## 3. Check the working tree

`git status --porcelain`. Dirty files listed in STATE.md's in-progress → summarize the diff, offer commit-as-wip or continue. Dirty files NOT listed → show them and ask before touching anything.

## 4. Go

Mark STATE.md `Status: Active (resumed {timestamp})`, then point at the next action — usually `/q-next` (say which stage it will run).
