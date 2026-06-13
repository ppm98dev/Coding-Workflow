---
name: wf-quantis-help
description: Show all available Quantis commands
---

# /wf-quantis-help Workflow

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
/wf-map              Analyze codebase             → codebase-mapper
/wf-plan [N]         Create phase plans           → writing-plans
/wf-update-plan [N]  Revise plans                 → writing-plans (revision)
/wf-execute [N]      Wave-based execution         → subagent-driven-development
/wf-discuss-phase    Clarify scope                → brainstorming
/wf-stress-test      Adversarial spec review      → wf-stress-test
/wf-research-phase   Deep technical research      → brainstorming (research)

SKILL-ENHANCED COMMANDS (workflow + skill)
──────────────────────────────────────────
/wf-debug-issue [desc] Systematic debugging       + systematic-debugging
/wf-verify [N]       Must-haves validation        + verification-before-completion
/wf-new-project      Deep questioning → SPEC.md   + brainstorming

PROJECT MANAGEMENT
──────────────────
/wf-new-milestone    Create milestone with phases
/wf-complete-milestone   Archive completed milestone
/wf-audit-milestone  Review milestone quality
/wf-plan-milestone-gaps  Create gap closure plans

PHASE MANAGEMENT
────────────────
/wf-add-phase        Add phase to end of roadmap
/wf-insert-phase     Insert phase (renumbers subsequent)
/wf-remove-phase     Remove phase (with safety checks)
/wf-list-phase-assumptions   Surface planning assumptions

NAVIGATION & STATE
──────────────────
/wf-progress         Show current position in roadmap
/wf-pause            Save state for session handoff
/wf-resume-session   Restore from last session
/wf-sprint           Time-boxed focused work session
/wf-add-todo         Quick capture idea
/wf-check-todos      List pending items

UTILITIES
─────────
/wf-quantis-help     Show this help
/wf-web-search       Search web for information
/wf-whats-new        Show recent Quantis changes
/wf-install          Install Quantis into a project
/wf-update           Update Quantis to latest version
/wf-upgrade          Migrate from GSD/v2.x to latest

───────────────────────────────────────────────────────

QUICK START
───────────
1. /wf-new-project      → Initialize with deep questioning
2. /wf-plan 1           → Create Phase 1 plans
3. /wf-execute 1        → Implement Phase 1
4. /wf-verify 1         → Confirm it works
5. Repeat

───────────────────────────────────────────────────────

CORE RULES
──────────
🔒 Planning Lock     No code until SPEC.md is FINALIZED
💾 State Persistence Update STATE.md after every task
🧹 Context Hygiene   3 failures → state dump → fresh session
✅ Empirical Valid.  Proof required, no "it should work"

───────────────────────────────────────────────────────

📚 Docs: .agents/rules/QUANTIS-STYLE.md, adapters/
🔧 Skills: .agents/skills/ (18 skills, auto-triggered)

───────────────────────────────────────────────────────

CLI USERS (agy)
───────────────
On Antigravity CLI, ALL workflow commands use the /wf- prefix:

  /wf-plan, /wf-execute, /wf-verify, /wf-pause, etc.

Skills work as direct slash commands without prefix:
  /brainstorming, /writing-plans, /systematic-debugging, etc.

The /wf- prefix distinguishes workflow commands (user-facing
orchestration) from skill commands (agent methodology).

💡 CLI: prefix all workflow commands with /wf-
   Example: /wf-plan 1 instead of /wf-plan 1

───────────────────────────────────────────────────────
```

</process>
