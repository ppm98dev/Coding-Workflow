---
phase: 2
plan: 2
wave: 1
depends_on: []
---

# Plan 2.2: Documentation & Roadmap Updates

## Objective
Update all documentation to reflect Phase 2 changes: `/update-plan` added as an optional command, `/checklist` removed from scope, command count updated, Mermaid diagram updated, and roadmap scope revised. Also fix the stale "GSD" brand reference in plan-checker skill (missed in Phase 1.5).

## Context
- README.md — Commands table, Mermaid diagram, Typical Session, command count
- .agent/workflows/help.md — Help command listing
- .quantis/ROADMAP.md — Phase 2 deliverables and must-haves
- .agents/skills/plan-checker/SKILL.md — Stale "GSD Plan Checker Agent" header

## Tasks

<task type="auto">
  <name>Update README with /update-plan</name>
  <files>README.md</files>
  <action>
    Make these specific changes to README.md:
    
    1. **Command count**: Update "Commands (28 Total)" to "Commands (29 Total)" in the heading (line ~304)
    
    2. **Core Workflow table** (lines ~309-318): Add `/update-plan [N]` row after `/plan [N]` with purpose: `🔄 Revise plans based on discussion (optional)`
    
    3. **Mermaid diagram** (lines ~117-141): Add `/update-plan` as an optional path between `/plan` and `/execute`:
       - Add node: `E2["🔄 /update-plan"]`
       - Add edge: `E --> E2` (from /plan to /update-plan)
       - Add edge: `E2 --> F` (from /update-plan to /execute)
       - Add edge: `E --> F` (direct path — plan to execute, already implied but make explicit)
       - Style E2 with a distinct color (use dashed or lighter shade to indicate "optional")
       - Add "(optional)" label on the edge from E to E2
    
    4. **How It Works table** (lines ~143-151): Add row between Plan and Execute:
       | **3b** | `/update-plan N` | *(optional)* Revise plans based on discussion |
    
    5. **Typical Session** (lines ~373-381): Add optional update-plan step:
       ```
       /plan 2              # ← Plan next phase
       # /update-plan 2     # ← Revise plans if needed (optional)
       /execute 2           # ← Implement with atomic commits
       ```
    
    Do NOT change anything else in the README.
  </action>
  <verify>
    - Command count: `grep "Commands (29 Total)" README.md`
    - New command listed: `grep "update-plan" README.md | wc -l` returns at least 3
    - Mermaid has new node: `grep "update-plan" README.md | grep -c "E2"` returns at least 1
  </verify>
  <done>
    - README command count is 29
    - `/update-plan` appears in Core Workflow table, Mermaid diagram, How It Works table, and Typical Session
    - All existing content preserved
  </done>
</task>

<task type="auto">
  <name>Update help workflow and roadmap</name>
  <files>
    .agent/workflows/help.md
    .quantis/ROADMAP.md
    .agents/skills/plan-checker/SKILL.md
  </files>
  <action>
    1. **help.md**: Add `/update-plan [N]` to the CORE WORKFLOW section, after `/plan [N]`:
       ```
       /update-plan [N]  Revise plans based on discussion (optional)
       ```
    
    2. **ROADMAP.md**: Update Phase 2 to reflect revised scope:
       - Change title from "Plan Iteration & Validation" to "Plan Iteration"
       - Update deliverables: remove the `/checklist` line, keep `/update-plan` line
       - Remove the `/checklist` entry from the Must-Haves section (line ~29: `- [ ] /checklist workflow...`)
       - Add `/update-plan` to Must-Haves if not already there
    
    3. **plan-checker SKILL.md**: Fix stale brand reference on line 6:
       - Change `# GSD Plan Checker Agent` to `# Quantis Plan Checker Agent`
  </action>
  <verify>
    - Help has update-plan: `grep "update-plan" .agent/workflows/help.md`
    - Roadmap Phase 2 updated: `grep "Plan Iteration" .quantis/ROADMAP.md | head -1`
    - No /checklist in roadmap: `grep -c "checklist" .quantis/ROADMAP.md` returns 0
    - No GSD in plan-checker: `grep -c "GSD" .agents/skills/plan-checker/SKILL.md` returns 0
  </verify>
  <done>
    - `/help` lists `/update-plan` in core workflow section
    - ROADMAP Phase 2 reflects revised scope (no /checklist)
    - Must-haves updated to include `/update-plan` and exclude `/checklist`
    - Plan-checker brand reference fixed (GSD → Quantis)
  </done>
</task>

## Success Criteria
- [ ] README has 29 commands, includes `/update-plan` in 4 locations
- [ ] Mermaid diagram shows optional `/update-plan` path
- [ ] `/help` lists the new command
- [ ] ROADMAP Phase 2 scope updated (no /checklist)
- [ ] Plan-checker stale brand fixed
