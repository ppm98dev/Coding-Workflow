---
phase: 3
plan: 3
wave: 2
---

# Plan 3.3: README Rewrite + Final Polish

## Objective
Write the v3.0 README from scratch and do a final cross-reference validation pass across the entire package.

## Context
- .quantis/DECISIONS.md (D-034)
- quantis-new/MANIFEST.md (created in Plan 3.1)
- quantis-new/.agent/workflows/ (all 29 workflows)
- quantis-new/.agents/skills/ (all 18 skills)

## Tasks

<task type="auto">
  <name>Write v3.0 README.md</name>
  <files>quantis-new/README.md</files>
  <action>
    Create a new README.md from scratch for Quantis v3.0. Structure:
    
    **1. Header + tagline**
    - "Quantis — Spec-driven development methodology for AI coding agents"
    - One-liner: what it does, who it's for
    
    **2. What is Quantis?**
    - Brief explanation: structured AI-assisted development (not vibecoding)
    - Core workflow: Spec → Plan → Execute → Verify
    - Key differentiator: persistent state across sessions
    
    **3. Quick Start**
    - Install command (from /install workflow)
    - `/new-project` to initialize
    - `/plan 1` → `/execute 1` → `/verify 1`
    
    **4. Architecture**
    - Skills (18) — the methodology engine (powered by Superpowers)
      - Code quality: TDD, SDD, code review, verification
      - Planning: brainstorming, writing-plans, executing-plans
      - Context: codebase-mapper, context-compressor, context-health-monitor, token-budget
      - Git: using-git-worktrees, finishing-a-development-branch
      - Meta: writing-skills, dispatching-parallel-agents, using-quantis
    - Workflows (29) — project management orchestration
      - List key workflows: /plan, /execute, /verify, /debug, /pause, /resume, /progress
    - State (.quantis/) — persistent project memory
      - SPEC.md, ROADMAP.md, STATE.md, JOURNAL.md, DECISIONS.md
    
    **5. Platform Support**
    - Primary: Google Antigravity
    - Adapters: Gemini CLI, Claude, GPT/OSS
    - Note: skills are platform-agnostic, adapters handle tool mapping
    
    **6. Credits**
    - Skills powered by [obra/superpowers](https://github.com/obra/superpowers) v5.1.0
    - Methodology and workflow orchestration by Quantis
    - License: MIT
    
    **Style:** Concise, developer-friendly. No marketing fluff. Show, don't tell.
    Max ~200 lines. Use tables for skill/workflow listings.
  </action>
  <verify>
    test -f quantis-new/README.md && wc -l quantis-new/README.md
    # Must exist, ~150-250 lines
    
    # Credits Superpowers
    grep "obra/superpowers" quantis-new/README.md
    # Must match
    
    # No GSD references
    grep -c "GSD\|get-shit-done" quantis-new/README.md
    # Must be 0
  </verify>
  <done>README.md exists at quantis-new root, covers architecture/quick start/credits, credits Superpowers, zero GSD references, under 250 lines.</done>
</task>

<task type="auto">
  <name>Final cross-reference validation</name>
  <files>quantis-new/ (all files)</files>
  <action>
    Do a final validation sweep across the entire package:
    
    **1. Workflow → Skill cross-references:**
    For each workflow that references a skill, verify the skill directory exists:
    - /plan → writing-plans ✓?
    - /execute → executing-plans, subagent-driven-development ✓?
    - /debug → systematic-debugging ✓?
    - /verify → verification-before-completion ✓?
    - /discuss-phase → brainstorming ✓?
    - /stress-test → brainstorming ✓?
    - /research-phase → brainstorming ✓?
    - /map → codebase-mapper ✓?
    - /new-project → brainstorming ✓?
    
    **2. GEMINI.md references:**
    - adapters/ANTIGRAVITY.md exists? ✓?
    - adapters/GEMINI.md exists? ✓?
    - adapters/CLAUDE.md exists? ✓?
    - PROJECT_RULES.md exists? ✓?
    
    **3. Template references:**
    For each workflow that references a template, verify it exists in .quantis/templates/.
    
    **4. MANIFEST accuracy:**
    Compare MANIFEST.md listings against actual files. Flag any mismatch.
    
    **5. Final grep sweep:**
    ```bash
    # No stale references should remain
    grep -rl "GSD\|get-shit-done\|Get Shit Done" quantis-new/ | grep -v ".git/"
    grep -rl "superpowers" quantis-new/ | grep -v ".git/" | grep -v "obra/superpowers"
    grep -rl "/tmp/superpowers" quantis-new/ | grep -v ".git/"
    ```
    
    Fix any issues found.
  </action>
  <verify>
    # All cross-reference checks pass (run each grep from above)
    # Zero stale references
    # MANIFEST matches reality
  </verify>
  <done>All workflow→skill references resolve. All GEMINI.md references resolve. All template references resolve. MANIFEST matches actual package. Zero stale references.</done>
</task>

## Success Criteria
- [ ] README.md exists, under 250 lines, credits Superpowers
- [ ] All 9 workflow→skill cross-references resolve
- [ ] All GEMINI.md file references resolve
- [ ] MANIFEST.md matches actual package contents
- [ ] Zero stale GSD/superpowers references in final sweep
