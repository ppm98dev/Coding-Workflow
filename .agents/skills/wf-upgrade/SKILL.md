---
name: wf-upgrade
description: Migrate from GSD/v2.x or old Quantis v3.x to latest Quantis
---

# /upgrade Workflow

<objective>
One-time migration from GSD (Get Shit Done) v2.x or old Quantis v3.x to the latest Quantis.
Replaces old core skills, removes legacy directories (`.agent/`), migrates rules
to `.agents/rules/`, and preserves user state and custom skills.
</objective>

<process>

## 1. Detect Current Installation

```bash
# Check for old GSD v2.x core skills
if [ -d ".agents/skills/planner" ] || [ -d ".agents/skills/executor" ] || [ -d ".agents/skills/verifier" ]; then
    echo "GSD v2.x installation detected"
    INSTALL_TYPE="gsd-v2"
# Check for old Quantis v3.x (has .agent/workflows/ or _wf- symlinks)
elif [ -d ".agent/workflows" ] || ls .agents/skills/_wf-* 1>/dev/null 2>&1; then
    echo "Old Quantis v3.x detected — needs migration"
    INSTALL_TYPE="quantis-v3-old"
# Check for current Quantis (has wf-* dirs, no .agent/)
elif [ -d ".agents/skills/wf-plan" ] && [ ! -d ".agent" ]; then
    echo "Quantis already up to date"
    INSTALL_TYPE="current"
else
    echo "No recognized installation found"
    INSTALL_TYPE="none"
fi
```

**If already current:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► ALREADY UP TO DATE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Use /wf-update for incremental updates instead.

───────────────────────────────────────────────────────
```
Exit.

**If no installation:**
```
No Quantis/GSD installation detected.
Use /wf-install for a fresh installation instead.
```
Exit.

---

## 2. Inventory Current Installation

```bash
# List current skills
echo "Current skills:"
ls .agents/skills/ 2>/dev/null

# Check for legacy directories
echo "Legacy directories:"
ls .agent/workflows/ 2>/dev/null && echo "  ⚠ .agent/workflows/ exists (will be removed)"
ls .agents/skills/_wf-* 2>/dev/null && echo "  ⚠ _wf-* symlinks exist (will be replaced)"

# Check for root rules files (will be migrated to .agents/rules/)
for f in PROJECT_RULES.md CONSTITUTION.md QUANTIS-STYLE.md; do
    [ -f "$f" ] && echo "  ⚠ $f at root (will be moved to .agents/rules/)"
done

# Check for dead files
[ -f "model_capabilities.yaml" ] && echo "  ⚠ model_capabilities.yaml (will be removed)"
for f in adapters/CLAUDE.md adapters/GEMINI.md adapters/GPT_OSS.md; do
    [ -f "$f" ] && echo "  ⚠ $f (will be removed)"
done

# Check for user state
echo "User state files:"
ls .quantis/*.md 2>/dev/null
ls .quantis/phases/ 2>/dev/null
```

---

## 3. Show Migration Preview

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► UPGRADE PREVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WILL BE REMOVED:
  ✗ .agent/ directory (legacy — workflows now in .agents/skills/wf-*)
  ✗ _wf-* symlinks (replaced with real wf-* directories)
  ✗ Old GSD skills (planner, executor, verifier, debugger, etc.)
  ✗ Dead adapters (CLAUDE.md, GEMINI.md, GPT_OSS.md)
  ✗ model_capabilities.yaml

WILL BE MIGRATED:
  → PROJECT_RULES.md (root → .agents/rules/)
  → CONSTITUTION.md (root → .agents/rules/)
  → QUANTIS-STYLE.md (root → .agents/rules/)

WILL BE INSTALLED:
  + 30 workflow skills (wf-*) — real files, spec-compliant
  + 18 methodology skills (brainstorming, writing-plans, etc.)
  + 3 rules in .agents/rules/ (auto-discovered by all platforms)

───────────────────────────────────────────────────────

PRESERVED (untouched):
  ✓ .quantis/SPEC.md
  ✓ .quantis/ROADMAP.md
  ✓ .quantis/STATE.md
  ✓ .quantis/DECISIONS.md
  ✓ .quantis/JOURNAL.md
  ✓ .quantis/TODO.md
  ✓ .quantis/phases/* (all phase data)
  ✓ .agents/rules/CONSTITUTION.md (your customized copy)
  ✓ Any skills NOT listed above (user-installed)

───────────────────────────────────────────────────────

Proceed with upgrade?
A) Yes — Upgrade to latest Quantis
B) No — Cancel

───────────────────────────────────────────────────────
```

**If user cancels:** Exit.

---

## 4. Clone Latest

```bash
git clone --depth 1 https://github.com/ppm98dev/Coding-Workflow.git .quantis-upgrade-temp
```

---

## 5. Execute Migration

### 5a. Remove Old Core Skills

```bash
# Remove GSD v2.x core skills
OLD_SKILLS="planner executor verifier debugger context-fetch empirical-validation plan-checker"
for skill in $OLD_SKILLS; do
    if [ -d ".agents/skills/$skill" ]; then
        rm -rf ".agents/skills/$skill"
        echo "Removed: $skill"
    fi
done
```

### 5b. Remove Legacy Directories

```bash
# Remove .agent/ directory (workflows now in .agents/skills/wf-*)
if [ -d ".agent" ]; then
    rm -rf .agent
    echo "Removed: .agent/ (legacy workflows directory)"
fi

# Remove _wf-* symlinks (replaced by wf-* real dirs)
for link in .agents/skills/_wf-*; do
    if [ -e "$link" ]; then
        rm -rf "$link"
        echo "Removed: $(basename $link) (old symlink)"
    fi
done

# Remove dead files
rm -f model_capabilities.yaml
rm -f adapters/CLAUDE.md adapters/GEMINI.md adapters/GPT_OSS.md
echo "Removed dead files"
```

### 5c. Migrate Root Rules to .agents/rules/

```bash
mkdir -p .agents/rules

# Move root rules files if they exist (don't overwrite if already in .agents/rules/)
for f in PROJECT_RULES.md QUANTIS-STYLE.md; do
    if [ -f "$f" ] && [ ! -f ".agents/rules/$f" ]; then
        mv "$f" ".agents/rules/"
        echo "Migrated: $f → .agents/rules/"
    elif [ -f "$f" ]; then
        rm "$f"
        echo "Removed root copy: $f (already in .agents/rules/)"
    fi
done

# CONSTITUTION.md — preserve user's copy
if [ -f "CONSTITUTION.md" ] && [ ! -f ".agents/rules/CONSTITUTION.md" ]; then
    mv "CONSTITUTION.md" ".agents/rules/"
    echo "Migrated: CONSTITUTION.md → .agents/rules/ (preserved)"
elif [ -f "CONSTITUTION.md" ]; then
    rm "CONSTITUTION.md"
    echo "Removed root copy: CONSTITUTION.md (already in .agents/rules/)"
fi

# Remove stale symlinks in .agents/rules/
find .agents/rules/ -type l -delete 2>/dev/null || true
```

### 5d. Install Latest Skills + Workflows

```bash
SOURCE=".quantis-upgrade-temp"

# Install all skills listed in MANIFEST.md
for skill_dir in $(ls "$SOURCE/.agents/skills/"); do
    rm -rf ".agents/skills/$skill_dir"
    cp -r "$SOURCE/.agents/skills/$skill_dir" ".agents/skills/"
    echo "Installed: $skill_dir"
done
```

### 5e. Update Templates

```bash
cp -r "$SOURCE/.quantis/templates/"* .quantis/templates/
echo "Updated templates"
```

### 5f. Update Bootstrap and Adapters

```bash
mkdir -p .gemini adapters
cp "$SOURCE/.gemini/GEMINI.md" .gemini/GEMINI.md
cp "$SOURCE/adapters/ANTIGRAVITY.md" adapters/ 2>/dev/null || true
echo "Updated bootstrap and adapter"
```

### 5g. Update Core Docs and Scripts

```bash
mkdir -p docs scripts
cp "$SOURCE/docs/model-selection-playbook.md" docs/
cp "$SOURCE/docs/runbook.md" docs/
cp "$SOURCE/docs/token-optimization-guide.md" docs/
cp "$SOURCE/scripts/search_repo.sh" scripts/
cp "$SOURCE/scripts/setup_search.sh" scripts/
cp "$SOURCE/scripts/validate-all.sh" scripts/
cp "$SOURCE/scripts/validate-skills.sh" scripts/
cp "$SOURCE/scripts/validate-workflows.sh" scripts/
cp "$SOURCE/scripts/validate-templates.sh" scripts/
echo "Updated core docs and scripts"
```

### 5h. Update Root Files

```bash
# Rules (overwrite methodology files, NOT CONSTITUTION.md)
cp "$SOURCE/.agents/rules/PROJECT_RULES.md" .agents/rules/
cp "$SOURCE/.agents/rules/QUANTIS-STYLE.md" .agents/rules/
cp "$SOURCE/VERSION" ./
echo "Updated rules and version"
```

> **Note:** `.agents/rules/CONSTITUTION.md` is NOT replaced — it may have user customizations.

---

## 6. Replace GSD References

```bash
# In .quantis/ state files, replace GSD → Quantis
find .quantis -type f -name "*.md" | while read -r file; do
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's/\.gsd\//\.quantis\//g' "$file" 2>/dev/null || true
        sed -i '' 's/GSD/Quantis/g' "$file" 2>/dev/null || true
    else
        sed -i 's/\.gsd\//\.quantis\//g' "$file" 2>/dev/null || true
        sed -i 's/GSD/Quantis/g' "$file" 2>/dev/null || true
    fi
done

# In CONSTITUTION.md
if [ -f ".agents/rules/CONSTITUTION.md" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's/GSD/Quantis/g' .agents/rules/CONSTITUTION.md 2>/dev/null || true
        sed -i '' 's/Get Shit Done/Quantis/g' .agents/rules/CONSTITUTION.md 2>/dev/null || true
    else
        sed -i 's/GSD/Quantis/g' .agents/rules/CONSTITUTION.md 2>/dev/null || true
        sed -i 's/Get Shit Done/Quantis/g' .agents/rules/CONSTITUTION.md 2>/dev/null || true
    fi
fi
```

---

## 7. Verify Migration

```bash
# Check key skills are present
for skill in brainstorming writing-plans executing-plans systematic-debugging verification-before-completion; do
    if [ -d ".agents/skills/$skill" ]; then
        echo "✓ $skill"
    else
        echo "✗ MISSING: $skill"
    fi
done

# Check workflows
wf_count=$(ls -d .agents/skills/wf-* 2>/dev/null | wc -l | xargs)
echo "✓ $wf_count workflows installed"

# Check rules
for f in PROJECT_RULES.md CONSTITUTION.md QUANTIS-STYLE.md; do
    [ -f ".agents/rules/$f" ] && echo "✓ .agents/rules/$f" || echo "✗ MISSING: .agents/rules/$f"
done

# Check legacy removed
[ ! -d ".agent" ] && echo "✓ .agent/ removed" || echo "✗ .agent/ still exists"
[ ! -f "model_capabilities.yaml" ] && echo "✓ model_capabilities.yaml removed" || echo "✗ still exists"

# Check user state preserved
for file in .quantis/SPEC.md .quantis/ROADMAP.md .quantis/STATE.md; do
    if [ -f "$file" ]; then
        echo "✓ Preserved: $file"
    fi
done

cat VERSION
```

---

## 8. Cleanup

```bash
rm -rf .quantis-upgrade-temp
```

---

## 9. Confirm Upgrade

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► UPGRADED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Migration complete!

• Old skills removed
• Legacy .agent/ directory removed
• Rules migrated to .agents/rules/ (auto-discovered)
• 30 workflows installed (wf-*)
• 18 methodology skills installed
• Templates updated
• User state preserved ✓

───────────────────────────────────────────────────────

Your .quantis/ state (SPEC, ROADMAP, phases, etc.)
is untouched. Continue where you left off.

▶ NEXT

/wf-progress  — See your current position
/wf-whats-new — See what's new
/wf-quantis-help — See all commands

───────────────────────────────────────────────────────
```

</process>

<notes>
- This workflow handles GSD v2.x → Quantis AND old Quantis v3.x → latest Quantis
- After upgrading, use /wf-update for future incremental updates
- User-installed skills (anything not in MANIFEST.md) are preserved
- All .quantis/ state files are preserved — no data loss
- .agents/rules/CONSTITUTION.md is preserved — user customizations are kept
- The .agent/ directory is deleted (workflows now in .agents/skills/wf-*)
- Root PROJECT_RULES.md, CONSTITUTION.md, QUANTIS-STYLE.md are moved to .agents/rules/
</notes>
