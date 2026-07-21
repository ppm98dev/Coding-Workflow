---
name: q-pause
description: Dump state for a clean session handoff — end of session, context getting heavy, or after 3 failed debugging attempts
---

# /q-pause — save state, end clean

## 1. Update `.quantis/STATE.md` (in place, per the template schema)

- **Position** — phase, task, `Paused at {timestamp}`
- **Session summary** — what was accomplished, what was verified
- **In-progress** — uncommitted files, test status
- **Context dump** — decisions made (mirror durable ones into ROADMAP's Decisions section), approaches tried and their outcomes, current hypothesis, files of interest
- **Next steps** — numbered, specific; first one should be executable by `/q-next` or a fresh reader

If pausing after debugging failures: exact error messages, what NOT to retry, and your hypothesis. A fresh context usually sees what a polluted one missed.

## 2. Reconcile ROADMAP.md

Fix drift: phase with `verdict: PASS` VERIFICATION.md → ✅ (idempotent). Plan fully checked but unverified → note "needs verification" in Next Steps. Never mark ✅ from checked boxes alone.

## 3. Commit

```bash
git add .quantis/ && git commit -m "docs: pause session - {reason}"
```

Then tell the user: state saved, resume with `/q-resume`.

## Auto-save (don't wait to be asked)

If the session is degrading — 20+ tool calls, re-reading files you already summarized, a context warning — write a minimal STATE.md snapshot (position, last action, next step) BEFORE telling the user anything. Save first, recommend `/q-pause` second: never rely on the user getting the chance to type it.
