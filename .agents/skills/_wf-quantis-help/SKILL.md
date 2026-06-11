---
description: Show all available Quantis commands
---

# /quantis-help Workflow

<objective>
Display all available Quantis commands with descriptions and usage hints.
</objective>

<process>

**First, read and display the version:**

```bash
version=$(cat VERSION 2>/dev/null || echo "unknown")
```

**Then display help with version in header:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► HELP (v{version})
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SKILL-POWERED COMMANDS (slash command → skill)
──────────────────────────────────────────────
/map              Analyze codebase             → codebase-mapper
/plan [N]         Create phase plans           → writing-plans
/update-plan [N]  Revise plans                 → writing-plans (revision)
/execute [N]      Wave-based execution         → executing-plans
/discuss-phase    Clarify scope                → brainstorming
/stress-test      Adversarial spec review      → brainstorming (critique)
/research-phase   Deep technical research      → brainstorming (research)

SKILL-ENHANCED COMMANDS (workflow + skill)
──────────────────────────────────────────
/debug-issue [desc] Systematic debugging       + systematic-debugging
/verify [N]       Must-haves validation        + verification-before-completion
/new-project      Deep questioning → SPEC.md   + brainstorming

PROJECT MANAGEMENT
──────────────────
/new-milestone    Create milestone with phases
/complete-milestone   Archive completed milestone
/audit-milestone  Review milestone quality
/plan-milestone-gaps  Create gap closure plans

PHASE MANAGEMENT
────────────────
/add-phase        Add phase to end of roadmap
/insert-phase     Insert phase (renumbers subsequent)
/remove-phase     Remove phase (with safety checks)
/list-phase-assumptions   Surface planning assumptions

NAVIGATION & STATE
──────────────────
/progress         Show current position in roadmap
/pause            Save state for session handoff
/resume-session   Restore from last session
/sprint           Time-boxed focused work session
/add-todo         Quick capture idea
/check-todos      List pending items

UTILITIES
─────────
/quantis-help     Show this help
/web-search       Search web for information
/whats-new        Show recent Quantis changes
/install          Install Quantis into a project
/update           Update Quantis to latest version
/upgrade          Migrate from GSD/v2.x to v3.0

───────────────────────────────────────────────────────

QUICK START
───────────
1. /new-project      → Initialize with deep questioning
2. /plan 1           → Create Phase 1 plans
3. /execute 1        → Implement Phase 1
4. /verify 1         → Confirm it works
5. Repeat

───────────────────────────────────────────────────────

CORE RULES
──────────
🔒 Planning Lock     No code until SPEC.md is FINALIZED
💾 State Persistence Update STATE.md after every task
🧹 Context Hygiene   3 failures → state dump → fresh session
✅ Empirical Valid.  Proof required, no "it should work"

───────────────────────────────────────────────────────

📚 Docs: QUANTIS-STYLE.md, adapters/
🔧 Skills: .agents/skills/ (18 skills, auto-triggered)

───────────────────────────────────────────────────────

CLI USERS (agy)
───────────────
On Antigravity CLI, ALL workflow commands use the /_wf- prefix:

  /_wf-plan, /_wf-execute, /_wf-verify, /_wf-pause, etc.

Skills work as direct slash commands without prefix:
  /brainstorming, /writing-plans, /systematic-debugging, etc.

The /_wf- prefix distinguishes workflow commands (user-facing
orchestration) from skill commands (agent methodology).

💡 CLI: prefix all workflow commands with /_wf-
   Example: /_wf-plan 1 instead of /plan 1

───────────────────────────────────────────────────────
```

</process>
