---
phase: 1
plan: 1
wave: 1
---

# Plan 1.1: Create Antigravity Adapter

## Objective
Create `adapters/ANTIGRAVITY.md` — a comprehensive guide for using GSD inside Google Antigravity. This is the #1 gap identified in the audit. Must follow the established adapter pattern (see CLAUDE.md for reference) but go deeper with Antigravity-specific tool mappings.

## Context
- .quantis/SPEC.md
- .quantis/RESEARCH.md (Antigravity tool inventory, key findings)
- .quantis/DECISIONS.md (ADR-004: deep adapter, ADR-005: GSD replaces planning mode)
- adapters/CLAUDE.md (reference for adapter pattern)

## Tasks

<task type="auto">
  <name>Create adapters/ANTIGRAVITY.md</name>
  <files>adapters/ANTIGRAVITY.md</files>
  <action>
    Create a comprehensive Antigravity adapter following the established pattern. Must begin with:
    > "Everything in this file is optional. For canonical rules, see PROJECT_RULES.md."

    Structure the file with these sections:

    1. **Antigravity Tool Mapping** — Table mapping each GSD phase to Antigravity tools:
       - `/map` → `grep_search`, `list_dir`, `view_file`
       - `/plan` → `search_web`, `read_url_content`, `generate_image` (for diagrams)
       - `/execute` → `run_command`, `write_to_file`, `replace_file_content`, `multi_replace_file_content`, `send_command_input`, `command_status`
       - `/verify` → `browser_subagent` (screenshots + recordings), `run_command` (test output)
       - `/web-search` → `search_web`, `read_url_content`

    2. **Browser Subagent for Verification** — How to use browser_subagent during `/verify`:
       - Capture screenshots as proof for UI changes
       - Record browser sessions as WebP videos
       - Navigate, click, and validate UI state
       - All recordings auto-saved to artifacts directory

    3. **Context Optimization** — Antigravity-specific tips:
       - Use `grep_search` before `view_file` (search-first discipline)
       - Progressive skill disclosure: skills load on-demand, keep SKILL.md descriptions sharp
       - Persistent terminals (`RunPersistent`) for stateful operations during `/execute`

    4. **Planning Mode Relationship** — Per ADR-005:
       - GSD's SPEC→PLAN→EXECUTE→VERIFY replaces Antigravity's planning mode
       - Do NOT create Antigravity artifacts (implementation_plan, task, walkthrough)
       - Use GSD's .quantis/ files exclusively

    5. **Model Selection** — Per ADR-003:
       - Reference model_capabilities.yaml for guidance
       - Fast models for `/execute` iteration
       - Reasoning models for `/plan` and `/debug`

    6. **Anti-Patterns** — Common mistakes:
       - ❌ Using Antigravity planning mode AND GSD simultaneously
       - ❌ Ignoring browser_subagent for UI verification
       - ❌ Loading entire files when grep_search would suffice
       - ❌ Using shell echo/cat for file creation instead of write_to_file

    Target: ~150-200 lines. Match the tone and structure of CLAUDE.md but with significantly more depth.
  </action>
  <verify>test -f adapters/ANTIGRAVITY.md && wc -l adapters/ANTIGRAVITY.md | awk '{print "Lines:", $1}' && head -3 adapters/ANTIGRAVITY.md</verify>
  <done>adapters/ANTIGRAVITY.md exists, is 150-200 lines, starts with the optional disclaimer, and covers all 6 sections</done>
</task>

<task type="auto">
  <name>Update .gemini/GEMINI.md entry point</name>
  <files>.gemini/GEMINI.md</files>
  <action>
    Rewrite .gemini/GEMINI.md to serve as a proper Antigravity entry point:

    1. Keep the existing structure (Canonical Rules reference, Core Principles, Quick Reference)
    2. UPDATE the "Workflow Integration" table — add Antigravity tool references for each workflow
    3. REPLACE the "Gemini-Specific Tips" section with an "Antigravity Integration" section that:
       - Points to adapters/ANTIGRAVITY.md for full guidance
       - Lists the 3 most important tips (browser_subagent for verify, grep before view, persistent terminals)
    4. UPDATE the footer attribution link from `glittercowboy/get-shit-done` to `gsd-build/get-shit-done`
    5. ADD a note that GSD replaces Antigravity's built-in planning mode (per ADR-005)

    Keep the file concise (~70-80 lines). This is an entry point, not the full adapter.
  </action>
  <verify>wc -l .gemini/GEMINI.md | awk '{print "Lines:", $1}' && grep -c "ANTIGRAVITY" .gemini/GEMINI.md && grep "gsd-build" .gemini/GEMINI.md</verify>
  <done>GEMINI.md references adapters/ANTIGRAVITY.md, mentions browser_subagent, has updated attribution link, and is 70-80 lines</done>
</task>

## Success Criteria
- [ ] adapters/ANTIGRAVITY.md exists with all 6 sections (~150-200 lines)
- [ ] .gemini/GEMINI.md updated with Antigravity references and current attribution
- [ ] Both files follow the "optional adapter" pattern from PROJECT_RULES.md
