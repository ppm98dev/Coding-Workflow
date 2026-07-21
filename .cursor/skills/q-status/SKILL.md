---
name: q-status
description: Show where the project stands — phases, current position, blockers, and what /q-next will do
---

# /q-status — where are we?

Read-only. Never changes files.

## 1. Read

`.quantis/ROADMAP.md` + `.quantis/STATE.md`. If missing → suggest `/q-init`.

## 2. Display

```
Quantis ► STATUS
Project: {name} · Milestone: {milestone} · Intent: {DRAFT|FINALIZED}

✅ Phase 1: {name}
🔄 Phase 2: {name} ← current   (plan: {path or "none yet"})
⬜ Phase 3: {name}

Progress: {done}/{total}
Current task: {from STATE.md or plugin plan}
Blockers: {from STATE.md, or none}

▶ /q-next will: {DEFINE|PLAN|BUILD|VERIFY|MILESTONE — per the q-next stage table}
```

Derive the "▶ will" line from the same stage rules `/q-next` uses, so the two never disagree.
