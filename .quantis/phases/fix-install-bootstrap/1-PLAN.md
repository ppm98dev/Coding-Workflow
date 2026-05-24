# Fix Install Bootstrap & Dead Paths — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use subagent-driven-development (recommended) or executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix the broken installation flow so new users can actually install Quantis, and correct all stale `quantis-new/` path references left over from the dogfood migration.

**Architecture:** Three workflows (`install.md`, `update.md`, `upgrade.md`) reference a `quantis-new/` subdirectory inside the cloned repo that no longer exists — files now live at the repo root. The README has a chicken-and-egg problem: it tells users to run `/install` but that workflow only exists after installation. We fix the paths, fix the README, and correct stale counts (29 → 30 workflows).

**Tech Stack:** Markdown (workflow files, README)

---

## Audit Summary

| Issue | Files Affected |
|-------|---------------|
| **Dead `quantis-new/` paths** | `install.md` (14 refs), `update.md` (2 refs), `upgrade.md` (1 ref) |
| **README bootstrap problem** | `README.md` — Quick Start assumes `/install` exists before installation |
| **Wrong workflow count (29 → 30)** | `install.md:122`, `update.md:152`, `upgrade.md:113,275` |
| **README file tree incomplete** | Missing CHANGELOG.md, VERSION, model_capabilities.yaml, LICENSE |
| **README docs/ description misleading** | Says "Reference documentation" but only has 2 platform-specific files |

---

### Task 1: Fix `install.md` — Dead Paths + Wrong Count

**Files:**
- Modify: `.agent/workflows/install.md:59-74` (dead `quantis-new/` paths)
- Modify: `.agent/workflows/install.md:122` (wrong count: 29 → 30)

- [ ] **Step 1: Fix copy paths — remove `quantis-new/` from all source paths**

Replace lines 57–75 in `.agent/workflows/install.md`. Change every occurrence of `.quantis-install-temp/quantis-new/` to `.quantis-install-temp/`:

```bash
# Core directories
cp -r .quantis-install-temp/.agent ./
cp -r .quantis-install-temp/.agents ./
cp -r .quantis-install-temp/.gemini ./
cp -r .quantis-install-temp/.quantis ./
cp -r .quantis-install-temp/adapters ./
cp -r .quantis-install-temp/docs ./

# Root files
cp .quantis-install-temp/CONSTITUTION.md ./
cp .quantis-install-temp/MANIFEST.md ./
cp .quantis-install-temp/PROJECT_RULES.md ./
cp .quantis-install-temp/QUANTIS-STYLE.md ./
cp .quantis-install-temp/README.md ./
cp .quantis-install-temp/CHANGELOG.md ./
cp .quantis-install-temp/VERSION ./
cp .quantis-install-temp/model_capabilities.yaml ./
```

- [ ] **Step 2: Fix workflow count on line 122**

Change:
```
• .agent/        (29 workflows)
```
To:
```
• .agent/        (30 workflows)
```

- [ ] **Step 3: Verify no remaining `quantis-new` references**

Run: `grep -n "quantis-new" .agent/workflows/install.md`
Expected: No output (zero matches)

- [ ] **Step 4: Commit**

```bash
git add .agent/workflows/install.md
git commit -m "fix(install): remove dead quantis-new/ paths, fix workflow count"
```

---

### Task 2: Fix `update.md` — Dead Paths + Wrong Count

**Files:**
- Modify: `.agent/workflows/update.md:39` (VERSION path)
- Modify: `.agent/workflows/update.md:92` (SOURCE variable)
- Modify: `.agent/workflows/update.md:152` (wrong count: 29 → 30)

- [ ] **Step 1: Fix VERSION check path on line 39**

Change:
```bash
remote_version=$(cat .quantis-update-temp/quantis-new/VERSION 2>/dev/null || echo "unknown")
```
To:
```bash
remote_version=$(cat .quantis-update-temp/VERSION 2>/dev/null || echo "unknown")
```

- [ ] **Step 2: Fix SOURCE variable on line 92**

Change:
```bash
SOURCE=".quantis-update-temp/quantis-new"
```
To:
```bash
SOURCE=".quantis-update-temp"
```

- [ ] **Step 3: Fix workflow count on line 152**

Change:
```
• Workflows (29)
```
To:
```
• Workflows (30)
```

- [ ] **Step 4: Verify no remaining `quantis-new` references**

Run: `grep -n "quantis-new" .agent/workflows/update.md`
Expected: No output (zero matches)

- [ ] **Step 5: Commit**

```bash
git add .agent/workflows/update.md
git commit -m "fix(update): remove dead quantis-new/ paths, fix workflow count"
```

---

### Task 3: Fix `upgrade.md` — Dead Path + Wrong Counts

**Files:**
- Modify: `.agent/workflows/upgrade.md:168` (SOURCE variable)
- Modify: `.agent/workflows/upgrade.md:113` (workflow count in preview)
- Modify: `.agent/workflows/upgrade.md:275` (workflow count in confirmation)

- [ ] **Step 1: Fix SOURCE variable on line 168**

Change:
```bash
SOURCE=".quantis-upgrade-temp/quantis-new"
```
To:
```bash
SOURCE=".quantis-upgrade-temp"
```

- [ ] **Step 2: Fix workflow count on line 113**

Change:
```
  ↻ All 29 workflows replaced with v3.0 versions
```
To:
```
  ↻ All 30 workflows replaced with v3.0 versions
```

- [ ] **Step 3: Fix workflow count on line 275**

Change:
```
• Workflows updated: 29 (+ /upgrade)
```
To:
```
• Workflows updated: 30
```

Note: `/upgrade` is already one of the 30, so the `(+ /upgrade)` phrasing was misleading.

- [ ] **Step 4: Verify no remaining `quantis-new` references**

Run: `grep -n "quantis-new" .agent/workflows/upgrade.md`
Expected: No output (zero matches)

- [ ] **Step 5: Commit**

```bash
git add .agent/workflows/upgrade.md
git commit -m "fix(upgrade): remove dead quantis-new/ path, fix workflow counts"
```

---

### Task 4: Fix `README.md` — Bootstrap Problem + Incomplete File Tree

**Files:**
- Modify: `README.md:9-22` (Quick Start — add manual install before `/install`)
- Modify: `README.md:95-107` (File Structure — add missing root files, fix docs/ description)

- [ ] **Step 1: Rewrite Quick Start section (lines 9–22)**

Replace the Quick Start with a two-step flow that shows manual install first:

```markdown
## Quick Start

### 1. Install

```bash
# In your project directory:
git clone --depth 1 https://github.com/ppm98dev/Coding-Workflow.git .quantis-tmp && \
  cp -r .quantis-tmp/.agent .quantis-tmp/.agents .quantis-tmp/.gemini .quantis-tmp/.quantis .quantis-tmp/adapters .quantis-tmp/docs . && \
  cp .quantis-tmp/CONSTITUTION.md .quantis-tmp/MANIFEST.md .quantis-tmp/PROJECT_RULES.md .quantis-tmp/QUANTIS-STYLE.md .quantis-tmp/CHANGELOG.md .quantis-tmp/VERSION .quantis-tmp/model_capabilities.yaml . && \
  rm -rf .quantis-tmp
```

### 2. Initialize

Tell your AI agent:
```
/new-project    → Deep questioning to create SPEC.md
/plan 1         → Create execution plans for Phase 1
/execute 1      → Implement Phase 1
/verify 1       → Prove it works with evidence
```

> **Already installed?** Use `/install` to reinstall, `/update` for incremental updates, or `/upgrade` to migrate from GSD v2.x.
```

- [ ] **Step 2: Fix File Structure section (lines 95–107)**

Replace with:

```markdown
## File Structure

```
.agent/workflows/     30 slash command workflows
.agents/skills/       18 auto-triggered skills
.gemini/              Platform bootstrap
.quantis/             Project state + 25 templates
adapters/             Platform-specific guidance
docs/                 Platform-specific guides (OpenCode, Windows)

CHANGELOG.md          Release history
CONSTITUTION.md       Project quality standards
LICENSE               MIT license
MANIFEST.md           Core file listing (for safe updates)
model_capabilities.yaml  Model capability matrix
PROJECT_RULES.md      Canonical methodology rules
QUANTIS-STYLE.md      Style and conventions
VERSION               Current version number
```
```

- [ ] **Step 3: Verify README renders correctly**

Visually scan the markdown for broken formatting. Check that the one-liner command has no line-break issues.

- [ ] **Step 4: Commit**

```bash
git add README.md
git commit -m "fix(readme): add manual install steps, fix file structure tree"
```

---

### Task 5: Final Verification

- [ ] **Step 1: Verify zero `quantis-new` references remain across all workflows**

```bash
grep -r "quantis-new" .agent/workflows/
```
Expected: No output

- [ ] **Step 2: Verify all workflow count references say 30**

```bash
grep -rn "29.*workflow\|workflow.*29" .agent/workflows/ README.md MANIFEST.md
```
Expected: No matches with "29 workflows" (only "30" or no count)

- [ ] **Step 3: Verify README install command would work**

Dry-run mental check: after `git clone ... .quantis-tmp`, files are at `.quantis-tmp/.agent`, `.quantis-tmp/.agents`, etc. (at root, not in a subdirectory). The `cp` commands copy from those root paths. ✓

- [ ] **Step 4: Check MANIFEST.md for stale counts**

```bash
grep -n "29\|quantis-new" MANIFEST.md
```
Expected: No stale references

- [ ] **Step 5: Final commit (if any fixups needed)**

```bash
git add -A
git commit -m "fix: final cleanup of install bootstrap issues"
```
