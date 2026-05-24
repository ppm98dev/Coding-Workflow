---
phase: fix-install-bootstrap
verified_at: 2026-05-24T15:54
verdict: PASS
---

# Fix Install Bootstrap — Verification Report

## Summary
5/5 must-haves verified with empirical evidence.

## Must-Haves

### ✅ 1. Zero `quantis-new/` references in active workflows
**Status:** PASS
**Evidence:**
```
$ grep -rn "quantis-new" .agent/workflows/install.md .agent/workflows/update.md .agent/workflows/upgrade.md
(exit code 1 — zero matches)
```

### ✅ 2. All workflow counts say 30 (not 29)
**Status:** PASS
**Evidence:**
```
install.md:122:  • .agent/        (30 workflows)
update.md:152:  • Workflows (30)
upgrade.md:113:  ↻ All 30 workflows replaced with v3.0 versions
upgrade.md:275:  • Workflows updated: 30
```

### ✅ 3. README has manual install steps (no bootstrap chicken-and-egg)
**Status:** PASS
**Evidence:** Quick Start section now shows `git clone --depth 1` + `cp` commands before any `/` workflow commands. The `/install` workflow is referenced only in a note for reinstalls.

### ✅ 4. README file tree lists all root files
**Status:** PASS
**Evidence:** File tree now includes: CHANGELOG.md, CONSTITUTION.md, LICENSE, MANIFEST.md, model_capabilities.yaml, PROJECT_RULES.md, QUANTIS-STYLE.md, VERSION (8 files, up from 4).

### ✅ 5. Install/update/upgrade paths point to repo root
**Status:** PASS
**Evidence:**
```
install.md:  cp -r .quantis-install-temp/.agent ./  (14 lines, all correct)
update.md:   SOURCE=".quantis-update-temp"
upgrade.md:  SOURCE=".quantis-upgrade-temp"
```

## Commits
```
dbd1e54 fix(readme): add manual install steps, fix file structure tree
45142d2 fix(upgrade): remove dead quantis-new/ path, fix workflow counts
6844423 fix(update): remove dead quantis-new/ paths, fix workflow count
2957f24 fix(install): remove dead quantis-new/ paths, fix workflow count
```

## Verdict
**PASS** — All 5 must-haves verified. Installation flow is now correct for new users.
