---
description: Install GSD into the current project from GitHub
---

# /install Workflow

<objective>
Install GSD for Antigravity into the current project from GitHub.
</objective>

<process>

## 1. Check for Existing Installation

Look for GSD marker directories:

```bash
if [ -d ".agents" ] || [ -d ".agent" ] || [ -d ".quantis" ]; then
    echo "GSD files detected in this project."
fi
```

**If already installed:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► ALREADY INSTALLED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GSD files already exist in this project.

───────────────────────────────────────────────────────

A) Reinstall — Overwrite with latest version
B) Cancel — Keep current installation

If you want to update instead: /update

───────────────────────────────────────────────────────
```

If user chooses Cancel, exit.
If user chooses Reinstall, continue to Step 2.

---

## 2. Clone from GitHub

```bash
git clone --depth 1 https://github.com/toonight/get-shit-done-for-antigravity.git .quantis-install-temp
```

---

## 3. Copy Files

```bash
# Core directories
cp -r .quantis-install-temp/.agent ./
cp -r .quantis-install-temp/.agents ./
cp -r .quantis-install-temp/.gemini ./
cp -r .quantis-install-temp/.quantis ./
cp -r .quantis-install-temp/adapters ./
cp -r .quantis-install-temp/docs ./
cp -r .quantis-install-temp/scripts ./

# Root files
cp .quantis-install-temp/PROJECT_RULES.md ./
cp .quantis-install-temp/GSD-STYLE.md ./
cp .quantis-install-temp/model_capabilities.yaml ./
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
 GSD ► ADD TO .gitignore?
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
 GSD ► INSTALLED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GSD for Antigravity has been installed.

Files installed:
• .agent/        (workflows)
• .agents/       (skills — Agent Skills standard)
• .gemini/       (Gemini integration)
• .quantis/          (project state templates)
• adapters/      (model-specific enhancements)
• docs/          (operational documentation)
• scripts/       (utility scripts)
• PROJECT_RULES.md
• GSD-STYLE.md
• model_capabilities.yaml

───────────────────────────────────────────────────────

Next step:

/new-project — Initialize your project with GSD

───────────────────────────────────────────────────────
```

</process>

<notes>
- This workflow is designed to work from a clean project (no prior GSD installation)
- It copies ALL necessary files, unlike manual installation which may miss some
- For updates to an existing installation, use /update instead
- The /new-project command should be run after installation to set up SPEC.md
</notes>
