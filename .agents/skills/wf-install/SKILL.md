---
name: wf-install
description: Install Quantis into the current project from GitHub
---

# /wf-install Workflow

<objective>
Install Quantis for Antigravity into the current project from GitHub.
</objective>

<process>

## 1. Check for Existing Installation

Look for Quantis marker directories:

```bash
if [ -d ".agents" ] || [ -d ".quantis" ]; then
    echo "Quantis files detected in this project."
fi
```

**If already installed:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► ALREADY INSTALLED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Quantis files already exist in this project.

───────────────────────────────────────────────────────

A) Reinstall — Overwrite with latest version
B) Cancel — Keep current installation

If you want to update instead: /wf-update
If you want to migrate from GSD: /wf-upgrade

───────────────────────────────────────────────────────
```

If user chooses Cancel, exit.
If user chooses Reinstall, continue to Step 2.

---

## 2. Clone from GitHub

```bash
git clone --depth 1 https://github.com/ppm98dev/Coding-Workflow.git .quantis-install-temp
```

---

## 3. Copy Files

```bash
# Core directories (workflows + skills all in .agents/skills/)
cp -r .quantis-install-temp/.agents ./
cp -r .quantis-install-temp/.gemini ./
cp -r .quantis-install-temp/adapters ./

mkdir -p scripts
cp .quantis-install-temp/scripts/search_repo.sh scripts/
cp .quantis-install-temp/scripts/setup_search.sh scripts/
cp .quantis-install-temp/scripts/validate-all.sh scripts/
cp .quantis-install-temp/scripts/validate-skills.sh scripts/

# Copy only .quantis templates (NOT the source repo's own dev state)
mkdir -p .quantis/templates
cp -r .quantis-install-temp/.quantis/templates/ .quantis/

# Rules (auto-discovered by all platforms)
cp .quantis-install-temp/.agents/rules/CONSTITUTION.md .agents/rules/
cp .quantis-install-temp/.agents/rules/PROJECT_RULES.md .agents/rules/
cp .quantis-install-temp/.agents/rules/QUANTIS-STYLE.md .agents/rules/
cp .quantis-install-temp/.quantis/VERSION .quantis/
```

> All workflows live in `.agents/skills/wf-*/SKILL.md` alongside methodology
> skills. This unified structure works on IDE, CLI, and Standalone without
> platform-specific setup.

---

## 4. Cleanup

```bash
rm -rf .quantis-install-temp
```

---

## 5. Add to .gitignore (Optional)

Check if `.quantis/STATE.md` and other session files should be gitignored:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► ADD TO .gitignore?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Recommended .gitignore additions for session-specific files:

.quantis/STATE.md
.quantis/JOURNAL.md
.quantis/TODO.md

───────────────────────────────────────────────────────

A) Yes — Add recommended entries
B) No — Skip

───────────────────────────────────────────────────────
```

---

## 6. Confirm Installation

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► INSTALLED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Quantis v3.3 has been installed.

Files installed:
• .agents/       (30 workflows + 18 skills + 3 rules — unified structure)
• .gemini/       (Antigravity bootstrap)
• .quantis/      (project state templates)
• adapters/      (platform-specific guidance)
• scripts/       (validation & search tools)
• VERSION

Rules auto-discovered:
• .agents/rules/PROJECT_RULES.md
• .agents/rules/CONSTITUTION.md
• .agents/rules/QUANTIS-STYLE.md

───────────────────────────────────────────────────────

Next step:

/wf-new-project — Initialize your project with Quantis

───────────────────────────────────────────────────────
```

</process>

<notes>
- This workflow is designed to work from a clean project (no prior Quantis installation)
- It copies ALL necessary files, unlike manual installation which may miss some
- For updates to an existing installation, use /wf-update instead
- For migration from GSD/v2.x, use /wf-upgrade instead
- The /wf-new-project command should be run after installation to set up SPEC.md
</notes>
