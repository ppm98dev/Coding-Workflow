---
phase: 3
plan: 3
wave: 2
---

# Plan 3.3: README, Versioning & Final Polish

## Objective
Write the v3.0 README from scratch, create CHANGELOG.md + VERSION (needed by /update, /whats-new, /help), update stale workflow content, and do a final cross-reference validation pass across the entire package.

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
  <name>Create CHANGELOG.md, VERSION, and update /whats-new + /help</name>
  <files>
    quantis-new/CHANGELOG.md
    quantis-new/VERSION
    quantis-new/.agent/workflows/whats-new.md
    quantis-new/.agent/workflows/help.md
  </files>
  <action>
    **1. Create VERSION file:**
    ```
    3.0.0
    ```
    Single line, no trailing content. This is read by `/help` (`cat VERSION`).

    **2. Create CHANGELOG.md:**
    ```markdown
    # Changelog

    ## [3.0.0] — 2026-05-24

    ### 🎉 Major Release: Superpowers Integration

    Complete methodology overhaul powered by [obra/superpowers](https://github.com/obra/superpowers) v5.1.0.

    #### Added
    - 18 skills (13 from Superpowers + 5 Quantis context skills)
    - Subagent-driven development (SDD) for Antigravity 2.0
    - TDD, code review, systematic debugging skills
    - Brainstorming skill (replaces /discuss-phase, /stress-test, /research-phase)
    - Writing-plans skill (replaces /plan methodology)
    - Executing-plans skill (replaces /execute methodology)
    - /upgrade workflow for GSD→v3.0 migration
    - MANIFEST.md for safe updates
    - Platform adapters (Antigravity, Gemini CLI, Claude, GPT/OSS)

    #### Changed
    - Skills auto-trigger based on task context (no explicit invocation needed)
    - /update is now MANIFEST-aware (preserves user-installed skills)
    - /install updated for v3.0 package structure
    - Skill-powered slash commands preserved as aliases (/plan, /execute, etc.)

    #### Removed
    - Old core skills (planner, executor, verifier, debugger, context-fetch, empirical-validation)
    - tests/ directory (Claude Code-specific, incompatible with Antigravity)
    ```
    This is read by `/update` for version detection and `/whats-new` for display.

    **3. Update /whats-new workflow:**
    - Replace the hardcoded v1.0/1.1/1.2 example content with v3.0 content from the new CHANGELOG.md
    - Remove any "GSD" references in the example display
    - Keep the workflow structure (read CHANGELOG.md, display latest)

    **4. Update /help workflow:**
    - Add `/upgrade` to the UTILITIES section:
      ```
      /upgrade         Migrate from GSD/v2.x to v3.0
      ```
    - Verify VERSION file is referenced correctly (`cat VERSION`)

    **5. Add CHANGELOG.md and VERSION to MANIFEST.md** (core root files section).
  </action>
  <verify>
    test -f quantis-new/CHANGELOG.md && echo "CHANGELOG exists"
    test -f quantis-new/VERSION && cat quantis-new/VERSION
    # Must show "3.0.0"
    
    grep "upgrade" quantis-new/.agent/workflows/help.md
    # Must show /upgrade in utilities
    
    grep -c "GSD" quantis-new/.agent/workflows/whats-new.md
    # Must be 0
  </verify>
  <done>CHANGELOG.md exists with v3.0 entry. VERSION contains "3.0.0". /whats-new shows v3.0 content (no GSD). /help lists /upgrade. Both files added to MANIFEST.md.</done>
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
    
    **5. docs/ cleanup verification:**
    Confirm Plan 3.1 cleaned docs/ correctly:
    - docs/superpowers/ — DELETED ✓?
    - docs/testing.md — DELETED ✓?
    - docs/plans/ — DELETED ✓?
    - docs/README.opencode.md — KEPT (multi-platform reference, superpowers refs cleaned) ✓?
    - docs/windows/ — KEPT (polyglot hooks, still useful) ✓?
    
    **6. Final grep sweep:**
    ```bash
    # No stale references should remain
    grep -rl "GSD\|get-shit-done\|Get Shit Done" quantis-new/ | grep -v ".git/"
    grep -rl "superpowers" quantis-new/ | grep -v ".git/" | grep -v "obra/superpowers"
    grep -rl "/tmp/superpowers" quantis-new/ | grep -v ".git/"
    ```
    
    **7. CHANGELOG.md + VERSION in package:**
    Verify both exist and are listed in MANIFEST.md.
    
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
- [ ] CHANGELOG.md exists with v3.0 entry
- [ ] VERSION file contains "3.0.0"
- [ ] /whats-new shows v3.0 content, zero GSD references
- [ ] /help lists /upgrade command
- [ ] All 9 workflow→skill cross-references resolve
- [ ] All GEMINI.md file references resolve
- [ ] MANIFEST.md matches actual package contents (including CHANGELOG.md + VERSION)
- [ ] docs/ contains only user-relevant files (no superpowers internal docs)
- [ ] Zero stale GSD/superpowers references in final sweep
