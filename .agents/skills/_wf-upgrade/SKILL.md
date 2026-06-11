---
description: Migrate from GSD/v2.x to Quantis v3.0
---

# /upgrade Workflow

<objective>
One-time migration from GSD (Get Shit Done) v2.x to Quantis v3.0.
Replaces old core skills with Superpowers-powered skills, updates workflows,
preserves user state and custom skills.
</objective>

<process>

## 1. Detect Current Installation

```bash
# Check for old GSD v2.x core skills
if [ -d ".agents/skills/planner" ] || [ -d ".agents/skills/executor" ] || [ -d ".agents/skills/verifier" ]; then
    echo "GSD v2.x installation detected"
    INSTALL_TYPE="gsd-v2"
# Check for v3.0 skills
elif [ -d ".agents/skills/writing-plans" ] || [ -d ".agents/skills/brainstorming" ]; then
    echo "Quantis v3.0 already installed"
    INSTALL_TYPE="v3"
else
    echo "No recognized installation found"
    INSTALL_TYPE="none"
fi
```

**If already v3.0:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► ALREADY ON v3.0 ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

You're already running Quantis v3.0.

Use /update for incremental updates instead.

───────────────────────────────────────────────────────
```
Exit.

**If no installation:**
```
No Quantis/GSD installation detected.
Use /install for a fresh installation instead.
```
Exit.

---

## 2. Inventory Current Installation

```bash
# List current skills
echo "Current skills:"
ls .agents/skills/ 2>/dev/null

# List current workflows
echo "Current workflows:"
ls .agent/workflows/ 2>/dev/null

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

SKILLS TO REMOVE (old GSD core):
  ✗ planner
  ✗ executor
  ✗ verifier
  ✗ debugger
  ✗ context-fetch
  ✗ empirical-validation
  ✗ plan-checker

SKILLS TO ADD (Superpowers-powered):
  + brainstorming
  + writing-plans
  + executing-plans
  + subagent-driven-development
  + systematic-debugging
  + verification-before-completion
  + test-driven-development
  + receiving-code-review
  + requesting-code-review
  + finishing-a-development-branch
  + dispatching-parallel-agents
  + using-git-worktrees
  + writing-skills

SKILLS TO UPDATE (Quantis context skills):
  ↻ codebase-mapper
  ↻ context-compressor
  ↻ context-health-monitor
  ↻ token-budget
  ↻ using-quantis

WORKFLOWS:
  ↻ All 30 workflows replaced with v3.0 versions
  + /upgrade (this workflow)

───────────────────────────────────────────────────────

PRESERVED (untouched):
  ✓ .quantis/SPEC.md
  ✓ .quantis/ROADMAP.md
  ✓ .quantis/STATE.md
  ✓ .quantis/DECISIONS.md
  ✓ .quantis/JOURNAL.md
  ✓ .quantis/TODO.md
  ✓ .quantis/phases/* (all phase data)
  ✓ CONSTITUTION.md (your customized copy)
  ✓ Any skills NOT listed above (user-installed)

───────────────────────────────────────────────────────

Proceed with upgrade?
A) Yes — Upgrade to Quantis v3.0
B) No — Cancel

───────────────────────────────────────────────────────
```

**If user cancels:** Exit.

---

## 4. Clone v3.0

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

### 5b. Install v3.0 Core Skills

```bash
SOURCE=".quantis-upgrade-temp"

# Install all skills listed in MANIFEST.md
for skill_dir in $(ls "$SOURCE/.agents/skills/"); do
    rm -rf ".agents/skills/$skill_dir"
    cp -r "$SOURCE/.agents/skills/$skill_dir" ".agents/skills/"
    echo "Installed: $skill_dir"
done
```

### 5c. Replace Workflows

```bash
# Replace all workflows
rm -rf .agent/workflows/*
cp -r "$SOURCE/.agent/workflows/"* .agent/workflows/
echo "Replaced all workflows with v3.0 versions"
```

### 5d. Update Templates

```bash
cp -r "$SOURCE/.quantis/templates/"* .quantis/templates/
echo "Updated templates"
```

### 5e. Update Bootstrap and Adapters

```bash
cp "$SOURCE/.gemini/GEMINI.md" .gemini/GEMINI.md
cp -r "$SOURCE/adapters" ./ 2>/dev/null || true
echo "Updated bootstrap and adapters"
```

### 5e.5. Update Core Docs and Scripts

```bash
mkdir -p docs scripts
cp "$SOURCE/docs/model-selection-playbook.md" docs/
cp "$SOURCE/docs/runbook.md" docs/
cp "$SOURCE/docs/token-optimization-guide.md" docs/
cp "$SOURCE/scripts/search_repo.sh" scripts/
cp "$SOURCE/scripts/setup_search.sh" scripts/
cp "$SOURCE/scripts/validate-all.sh" scripts/
cp "$SOURCE/scripts/validate-skills.sh" scripts/
echo "Updated core docs and scripts"
```

### 5f. Update Root Files

```bash
# These are methodology files, safe to replace
cp "$SOURCE/.agents/rules/PROJECT_RULES.md" .agents/rules/
cp "$SOURCE/.agents/rules/QUANTIS-STYLE.md" .agents/rules/
cp "$SOURCE/VERSION" ./
cp "$SOURCE/model_capabilities.yaml" ./

echo "Updated root files"
```

> **Note:** CONSTITUTION.md is NOT replaced — it may have user customizations.

---

## 6. Verify Migration

```bash
# Check v3.0 skills are present
for skill in brainstorming writing-plans executing-plans systematic-debugging verification-before-completion; do
    if [ -d ".agents/skills/$skill" ]; then
        echo "✓ $skill"
    else
        echo "✗ MISSING: $skill"
    fi
done

# Check old skills are gone
for skill in planner executor verifier debugger; do
    if [ -d ".agents/skills/$skill" ]; then
        echo "✗ OLD SKILL STILL PRESENT: $skill"
    fi
done

# Check user state preserved
for file in .quantis/SPEC.md .quantis/ROADMAP.md .quantis/STATE.md; do
    if [ -f "$file" ]; then
        echo "✓ Preserved: $file"
    fi
done

# Check version
cat VERSION
```

---

## 7. Cleanup

```bash
rm -rf .quantis-upgrade-temp
```

---

## 8. Confirm Upgrade

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► UPGRADED TO v3.0 ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Migration complete!

• Old skills removed: {count}
• New skills installed: 18
• Workflows updated: 30
• Templates updated: 25
• User state preserved ✓

───────────────────────────────────────────────────────

Your .quantis/ state (SPEC, ROADMAP, phases, etc.)
is untouched. Continue where you left off.

▶ NEXT

/progress  — See your current position
/whats-new — See what's new in v3.0
/help      — See all commands

───────────────────────────────────────────────────────
```

</process>

<notes>
- This is a ONE-TIME migration workflow for GSD v2.x → Quantis v3.0
- After upgrading, use /update for future incremental updates
- User-installed skills (anything not in the old GSD core list) are preserved
- All .quantis/ state files are preserved — no data loss
- CONSTITUTION.md is preserved — user customizations are kept
</notes>
