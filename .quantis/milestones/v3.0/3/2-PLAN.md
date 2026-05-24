---
phase: 3
plan: 2
wave: 1
---

# Plan 3.2: Rewrite /install, /update, and Create /upgrade

## Objective
Rewrite the install and update workflows for v3.0 package structure (correct file list, Quantis branding, MANIFEST-aware update). Create the new /upgrade workflow for one-time GSD→v3.0 migration.

## Context
- .quantis/DECISIONS.md (D-031, D-032, D-033, D-035)
- quantis-new/MANIFEST.md (created in Plan 3.1)
- quantis-new/.agent/workflows/install.md (current version)
- quantis-new/.agent/workflows/update.md (current version)

## Tasks

<task type="auto">
  <name>Rewrite /install workflow</name>
  <files>quantis-new/.agent/workflows/install.md</files>
  <action>
    Rewrite install.md for v3.0 package structure:
    
    **File list changes:**
    - ADD: CONSTITUTION.md to copy list
    - ADD: MANIFEST.md to copy list
    - REMOVE: scripts/ (doesn't exist in v3.0)
    - KEEP: .agent/, .agents/, .gemini/, .quantis/templates/, adapters/, docs/
    - KEEP: PROJECT_RULES.md, QUANTIS-STYLE.md, model_capabilities.yaml
    
    **Branding changes:**
    - All "GSD" → "Quantis" in banners and messages
    - Update repo URL from `get-shit-done-for-antigravity` to correct repo name
    - Update confirmation banner to list correct v3.0 files
    - Update next step suggestion: `/new-project — Initialize your project with Quantis`
    
    **Logic changes:**
    - Check for `.agents` OR `.agent` OR `.quantis` (not "GSD marker directories")
    - After install, auto-create .quantis/ state directories (not just templates)
  </action>
  <verify>
    # No GSD references
    grep -c "GSD\|get-shit-done" quantis-new/.agent/workflows/install.md
    # Must be 0
    
    # CONSTITUTION.md in copy list
    grep "CONSTITUTION" quantis-new/.agent/workflows/install.md
    # Must match
    
    # No scripts/ reference
    grep "scripts" quantis-new/.agent/workflows/install.md
    # Must be 0
  </verify>
  <done>install.md references correct v3.0 file list (with CONSTITUTION.md, without scripts/), zero GSD references, correct repo URL.</done>
</task>

<task type="auto">
  <name>Rewrite /update workflow (MANIFEST-aware)</name>
  <files>quantis-new/.agent/workflows/update.md</files>
  <action>
    Rewrite update.md to be MANIFEST-aware per D-032:
    
    **Key change:** Instead of blanket `cp -r .agents/*` (which clobbers user skills), the update workflow now:
    1. Clones latest from GitHub
    2. Reads MANIFEST.md from the cloned copy
    3. Only replaces files/dirs listed in MANIFEST.md's "Core" sections
    4. Skips anything in "User Files" section
    5. Skips any .agents/skills/ directory NOT listed in MANIFEST (user-installed skills)
    
    **Update logic:**
    ```bash
    # For each core skill listed in MANIFEST.md
    for skill in $(grep "^- " .quantis-update-temp/MANIFEST.md | grep ".agents/skills/" | sed 's/^- //'); do
        cp -r ".quantis-update-temp/$skill" ".agents/skills/"
    done
    
    # Same for workflows, templates, root files
    ```
    
    **Branding:** All "GSD" → "Quantis". Correct repo URL.
    
    **Preserved files list:** Keep the existing <preserved_files> section but ensure it matches MANIFEST.md's "User Files" section.
  </action>
  <verify>
    # No blanket cp -r .agents/*
    grep "cp -r.*\.agents/\*" quantis-new/.agent/workflows/update.md
    # Must be 0 (no blanket copy)
    
    # MANIFEST reference exists
    grep -c "MANIFEST" quantis-new/.agent/workflows/update.md
    # Must be > 0
    
    # No GSD references  
    grep -c "GSD\|get-shit-done" quantis-new/.agent/workflows/update.md
    # Must be 0
  </verify>
  <done>update.md is MANIFEST-aware (only replaces listed core files), preserves user-installed skills, zero GSD references.</done>
</task>

<task type="auto">
  <name>Create /upgrade workflow</name>
  <files>quantis-new/.agent/workflows/upgrade.md</files>
  <action>
    Create a new upgrade.md workflow for one-time GSD/v2.x → v3.0 migration.
    
    **Flow:**
    1. Detect current installation type:
       - Has `.agents/skills/planner/` → GSD v2.x (old core skills)
       - Has `.agents/skills/writing-plans/` → Already v3.0
       - Neither → Fresh install, redirect to /install
    
    2. Show migration preview:
       ```
       SKILLS TO REPLACE (old → new):
       - planner → writing-plans
       - executor → executing-plans  
       - verifier → verification-before-completion
       - debugger → systematic-debugging
       - context-fetch → (removed, merged into codebase-mapper)
       - empirical-validation → (removed, merged into verification)
       
       SKILLS TO ADD:
       - brainstorming, subagent-driven-development, receiving-code-review,
         requesting-code-review, test-driven-development, etc.
       
       PRESERVED (untouched):
       - .quantis/ (all state files)
       - CONSTITUTION.md (user's copy)
       - Any skills NOT in old MANIFEST
       ```
    
    3. User confirms
    
    4. Execute migration:
       - Clone v3.0 from GitHub
       - Remove old core skills (listed in migration map)
       - Copy new core skills from MANIFEST.md
       - Replace workflows
       - Update templates
       - Keep user state (.quantis/*)
       - Keep user CONSTITUTION.md
    
    5. Verify migration:
       - All v3.0 skills present
       - No old core skills remaining
       - User state intact
    
    6. Cleanup temp files
    
    **Add to /help workflow** — include /upgrade in the command listing.
  </action>
  <verify>
    test -f quantis-new/.agent/workflows/upgrade.md && echo "EXISTS"
    # Must exist
    
    # Has detection logic
    grep "planner" quantis-new/.agent/workflows/upgrade.md
    # Must reference old skill names for detection
    
    # Has MANIFEST reference
    grep "MANIFEST" quantis-new/.agent/workflows/upgrade.md
    # Must reference MANIFEST for what to replace
  </verify>
  <done>upgrade.md exists with GSD detection, migration preview, MANIFEST-based replacement, state preservation. /help updated.</done>
</task>

## Success Criteria
- [ ] install.md has correct v3.0 file list (CONSTITUTION yes, scripts no)
- [ ] update.md is MANIFEST-aware (no blanket skill overwrite)
- [ ] upgrade.md exists with full GSD→v3.0 migration flow
- [ ] Zero GSD references across all three files
- [ ] /help lists /upgrade command
