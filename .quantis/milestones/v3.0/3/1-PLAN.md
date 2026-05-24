---
phase: 3
plan: 1
wave: 1
---

# Plan 3.1: MANIFEST.md + Reference Sweep

## Objective
Create the MANIFEST.md file listing all core Quantis files (needed by /upgrade and /update), then sweep all stale "GSD" and non-attribution "superpowers" references from the package. This is foundational — Plans 3.2 and 3.3 depend on clean branding.

## Context
- .quantis/DECISIONS.md (D-031, D-032, D-036)
- quantis-new/ (full package structure)

## Tasks

<task type="auto">
  <name>Create MANIFEST.md</name>
  <files>quantis-new/MANIFEST.md</files>
  <action>
    Create MANIFEST.md at the root of quantis-new/ listing every core file and directory that Quantis ships. Format:

    ```markdown
    # Quantis v3.0 Manifest
    
    > Core files managed by Quantis. Used by /install, /update, and /upgrade
    > to determine what to replace vs preserve.
    
    ## Core Directories
    - .agent/workflows/    (29 workflow files)
    - .agents/skills/      (18 skill directories)
    - .gemini/             (bootstrap)
    - .quantis/templates/  (25 templates)
    - adapters/            (4 adapter files)
    - docs/                (reference documentation)
    
    ## Core Root Files
    - CONSTITUTION.md
    - PROJECT_RULES.md
    - QUANTIS-STYLE.md
    - model_capabilities.yaml
    - MANIFEST.md (this file)
    
    ## User Files (NEVER overwritten)
    - .quantis/SPEC.md
    - .quantis/ROADMAP.md
    - .quantis/STATE.md
    - .quantis/ARCHITECTURE.md
    - .quantis/STACK.md
    - .quantis/DECISIONS.md
    - .quantis/JOURNAL.md
    - .quantis/TODO.md
    - .quantis/phases/*
    - CONSTITUTION.md (user's copy, not template)
    ```

    List each individual workflow and skill by name for precision.
  </action>
  <verify>
    cat quantis-new/MANIFEST.md
    # Every listed file/dir must exist in quantis-new/
    # Cross-check: find quantis-new/ -maxdepth 1 -type f and compare
  </verify>
  <done>MANIFEST.md exists, lists all 29 workflows by name, all 18 skills by name, all root files. Every listed path exists in quantis-new/.</done>
</task>

<task type="auto">
  <name>GSD + superpowers reference sweep</name>
  <files>
    quantis-new/.agent/workflows/install.md
    quantis-new/.agent/workflows/update.md
    quantis-new/.agent/workflows/new-project.md
    quantis-new/.agent/workflows/web-search.md
    quantis-new/.agent/workflows/whats-new.md
    quantis-new/.agents/skills/codebase-mapper/SKILL.md
    quantis-new/.agents/skills/context-compressor/SKILL.md
    quantis-new/.agents/skills/token-budget/SKILL.md
    quantis-new/.quantis/templates/state_snapshot.md
    quantis-new/.quantis/templates/token_report.md
    quantis-new/PROJECT_RULES.md
    quantis-new/model_capabilities.yaml
    quantis-new/.agents/skills/brainstorming/scripts/frame-template.html
    quantis-new/.agents/skills/brainstorming/scripts/start-server.sh
    quantis-new/.agents/skills/brainstorming/scripts/stop-server.sh
    quantis-new/docs/ (evaluate what to keep/remove)
  </files>
  <action>
    **GSD sweep (12 files):**
    Replace all instances of:
    - "GSD" → "Quantis" (in banners, messages, comments)
    - "get-shit-done-for-antigravity" → correct repo URL
    - "Get Shit Done" → "Quantis"
    
    Context-sensitive: preserve meaning. E.g., "GSD files detected" → "Quantis files detected".

    **Superpowers sweep (non-attribution):**
    - In brainstorming scripts: replace `superpowers` dir references with `quantis` equivalents
    - In GEMINI.md, adapters/ANTIGRAVITY.md: keep the `obra/superpowers` attribution links (these are correct)
    - In docs/: The `docs/superpowers/` directory contains historical Superpowers design docs (plans + specs). These are reference material from the upstream project. Delete `docs/superpowers/` entirely — these are internal Superpowers development docs, not user-facing.
    - In docs/testing.md: references Claude Code testing patterns. Delete — we removed tests/ (D-037).
    - In docs/README.opencode.md: OpenCode-specific setup guide. Keep but rename superpowers refs.
    - In docs/plans/: historical Superpowers feature plans. Delete all — internal upstream docs.
    - In docs/windows/: polyglot hooks for Windows. Keep if useful.
    
    **After sweep, verify:**
    ```bash
    grep -rl "GSD\|get-shit-done\|Get Shit Done" quantis-new/ | grep -v ".git/"
    # Should return 0 results
    
    grep -rl "superpowers" quantis-new/ | grep -v ".git/" | grep -v "obra/superpowers"
    # Should return only attribution URLs
    ```
  </action>
  <verify>
    grep -rl "GSD\|get-shit-done" quantis-new/ | grep -v ".git/" | wc -l
    # Must be 0
    
    grep -rl "superpowers" quantis-new/ | grep -v ".git/" | grep -v "obra/superpowers" | wc -l
    # Must be 0 (only attribution URLs remain)
  </verify>
  <done>Zero stale GSD references. Zero non-attribution superpowers references. docs/ cleaned of upstream internal docs.</done>
</task>

## Success Criteria
- [ ] MANIFEST.md exists and every listed path resolves to a real file/directory
- [ ] Zero grep hits for GSD/get-shit-done in quantis-new/
- [ ] Zero non-attribution superpowers references
- [ ] docs/ contains only user-relevant documentation
