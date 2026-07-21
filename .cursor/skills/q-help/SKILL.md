---
name: q-help
description: Show the Quantis commands and how the tracking loop works
---

# /q-help

Display:

```
Quantis ► project tracking for Cursor

Your skills/plugins (superpowers, Plan Mode, …) do the work.
Quantis remembers where you are and routes to the right skill.

COMMANDS
  /q-init     set up ROADMAP.md (intent + phases) and STATE.md
  /q-next     advance one stage: DEFINE → PLAN → BUILD → VERIFY → MILESTONE
  /q-status   where are we, and what /q-next will do
  /q-pause    dump state for a clean session handoff
  /q-resume   restore context in a fresh session
  /q-update   update installed Quantis to the latest version
  /q-help     this

Migrating an old Antigravity (v3) project? Run the script:
  curl -sSL https://raw.githubusercontent.com/ppm98dev/\
Coding-Workflow/main/scripts/migrate-v3-to-v4.sh | bash

STATE (.quantis/)
  ROADMAP.md  intent (vision, non-goals, success criteria, FINALIZED gate),
              phases with status + plan links, decisions
  STATE.md    current position + session handoff
  phases/     verification evidence per phase
  archive/    completed milestones

RULES (always loaded via .cursor/rules/quantis.mdc)
  🔒 no code until ROADMAP intent is FINALIZED
  🔗 plans stay with your plugin, linked from ROADMAP
  ✅ no phase is ✅ without evidence (VERIFICATION.md)
  💾 STATE.md updated as work happens

Roadmap edits need no command — just ask (add/remove/reorder
phases, rename milestone); the schema is in the rules.
```
