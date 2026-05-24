---
description: Install Quantis into the current project from GitHub
---

# /install Workflow

<objective>
Install Quantis for Antigravity into the current project from GitHub.
</objective>

<process>

## 1. Check for Existing Installation

Look for Quantis marker directories:

```bash
if [ -d ".agents" ] || [ -d ".agent" ] || [ -d ".quantis" ]; then
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

If you want to update instead: /update
If you want to migrate from GSD: /upgrade

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
# Core directories
cp -r .quantis-install-temp/quantis-new/.agent ./
cp -r .quantis-install-temp/quantis-new/.agents ./
cp -r .quantis-install-temp/quantis-new/.gemini ./
cp -r .quantis-install-temp/quantis-new/.quantis ./
cp -r .quantis-install-temp/quantis-new/adapters ./
cp -r .quantis-install-temp/quantis-new/docs ./

# Root files
cp .quantis-install-temp/quantis-new/CONSTITUTION.md ./
cp .quantis-install-temp/quantis-new/MANIFEST.md ./
cp .quantis-install-temp/quantis-new/PROJECT_RULES.md ./
cp .quantis-install-temp/quantis-new/QUANTIS-STYLE.md ./
cp .quantis-install-temp/quantis-new/README.md ./
cp .quantis-install-temp/quantis-new/CHANGELOG.md ./
cp .quantis-install-temp/quantis-new/VERSION ./
cp .quantis-install-temp/quantis-new/model_capabilities.yaml ./
```

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

Quantis v3.0 has been installed.

Files installed:
• .agent/        (29 workflows)
• .agents/       (18 skills — Agent Skills standard)
• .gemini/       (Antigravity bootstrap)
• .quantis/      (project state templates)
• adapters/      (platform-specific guidance)
• docs/          (reference documentation)
• CONSTITUTION.md
• MANIFEST.md
• PROJECT_RULES.md
• QUANTIS-STYLE.md
• CHANGELOG.md
• VERSION
• model_capabilities.yaml

───────────────────────────────────────────────────────

Next step:

/new-project — Initialize your project with Quantis

───────────────────────────────────────────────────────
```

</process>

<notes>
- This workflow is designed to work from a clean project (no prior Quantis installation)
- It copies ALL necessary files, unlike manual installation which may miss some
- For updates to an existing installation, use /update instead
- For migration from GSD/v2.x, use /upgrade instead
- The /new-project command should be run after installation to set up SPEC.md
</notes>
