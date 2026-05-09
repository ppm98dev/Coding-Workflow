---
phase: 4
plan: 1
wave: 1
---

# Plan 4.1: Install Script + v2.0 Release

## Objective
Create scripts/install.sh for one-command GSD installation into any project, bump version to 2.0.0, and write CHANGELOG entry summarizing the Antigravity-native evolution.

## Context
- .gsd/ROADMAP.md (Phase 4 scope)
- .agent/workflows/install.md (existing install workflow — describes what to copy)
- README.md (Getting Started section — matches install logic)

## Tasks

<task type="auto">
  <name>Create scripts/install.sh</name>
  <files>scripts/install.sh</files>
  <action>
    Create a Bash install script that:
    1. Accepts optional --force flag to overwrite existing GSD files
    2. Checks if GSD is already installed (test -d .gsd)
    3. Clones ppm98dev/Coding-Workflow to a temp dir
    4. Copies: .agent/, .agents/, .gemini/, .gsd/, adapters/, docs/, scripts/, PROJECT_RULES.md, GSD-STYLE.md, model_capabilities.yaml
    5. Cleans up temp dir
    6. Prints success message with next steps (/new-project)
    
    Keep it clean and minimal (~40-50 lines). Use colored output (green/red/yellow).
    Make it executable (chmod +x).
  </action>
  <verify>bash scripts/install.sh --help 2>&1 | head -5</verify>
  <done>Script exists, is executable, shows usage when run with --help or no args in wrong context</done>
</task>

<task type="auto">
  <name>Bump VERSION + CHANGELOG</name>
  <files>VERSION, CHANGELOG.md, README.md</files>
  <action>
    1. Update VERSION file: 1.5.0 → 2.0.0
    2. Update README badge: version-1.5.0 → version-2.0.0
    3. Add CHANGELOG entry at top (after header):
       ## [2.0.0] - 2026-05-01
       ### Breaking Changes
       - macOS/Linux only — all PowerShell content removed (ADR-008)
       ### Added
       - Antigravity adapter (adapters/ANTIGRAVITY.md)
       - Real model profiles in model_capabilities.yaml
       - browser_subagent guidance in /verify and /execute workflows
       - scripts/install.sh — one-command install for any project
       ### Changed
       - Attribution: glittercowboy → gsd-build
       - README: accurate command count (27), updated clone URL
       - All skills converted to Bash-only examples
  </action>
  <verify>cat VERSION && grep "2.0.0" CHANGELOG.md | head -1</verify>
  <done>VERSION reads "2.0.0", CHANGELOG has [2.0.0] entry</done>
</task>

## Success Criteria
- [ ] scripts/install.sh exists and is executable
- [ ] VERSION is 2.0.0
- [ ] CHANGELOG has v2.0.0 entry with breaking changes
- [ ] README badge says 2.0.0
- [ ] All validators pass
