---
description: Update Quantis to the latest version from GitHub
---

# /update Workflow

<objective>
Update Quantis for Antigravity to the latest version from GitHub.
Uses MANIFEST.md to only replace core files — preserves user-installed skills and state.
</objective>

<process>

## 1. Check Current Version

```bash
if [ -f "VERSION" ]; then
    version=$(cat VERSION)
    echo "Current version: $version"
else
    echo "No VERSION file found. Current version unknown."
fi
```

---

## 2. Fetch Latest from GitHub

```bash
# Clone latest to temp directory
git clone --depth 1 https://github.com/ppm98dev/Coding-Workflow.git .quantis-update-temp
```

---

## 3. Compare Versions

```bash
remote_version=$(cat .quantis-update-temp/VERSION 2>/dev/null || echo "unknown")
echo "Remote version: $remote_version"
```

**If same version:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► ALREADY UP TO DATE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Version: {version}

No updates available.

───────────────────────────────────────────────────────
```
Exit after cleanup.

---

## 4. Show Changes

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► UPDATE AVAILABLE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current: {current-version}
Latest:  {remote-version}

Changes:
{Extract from CHANGELOG.md}

───────────────────────────────────────────────────────

Update now?
A) Yes — Apply updates (MANIFEST-aware, preserves your skills)
B) No — Cancel

───────────────────────────────────────────────────────
```

---

## 5. Apply Updates (MANIFEST-aware)

**If user confirms:**

Read MANIFEST.md from the remote copy to determine what to update.
Only replace files and directories listed in the **Core** sections.
Never touch files listed in **User Files**.

```bash
SOURCE=".quantis-update-temp"

# --- Core Workflows + Skills (MANIFEST-aware) ---
# Replace all workflows and core skills listed in MANIFEST.md
# This preserves any user-installed skills not in the manifest
for skill_dir in $(ls "$SOURCE/.agents/skills/"); do
    if grep -q "^- $skill_dir$" "$SOURCE/MANIFEST.md"; then
        rm -rf ".agents/skills/$skill_dir"
        cp -r "$SOURCE/.agents/skills/$skill_dir" ".agents/skills/"
    fi
done

# --- Templates ---
cp -r "$SOURCE/.quantis/templates/"* .quantis/templates/

# --- Bootstrap and Adapters ---
cp "$SOURCE/.gemini/GEMINI.md" .gemini/GEMINI.md
cp -r "$SOURCE/adapters" ./ 2>/dev/null || true

# --- Core Docs and Scripts ---
mkdir -p docs scripts
cp "$SOURCE/docs/model-selection-playbook.md" docs/
cp "$SOURCE/docs/runbook.md" docs/
cp "$SOURCE/docs/token-optimization-guide.md" docs/
cp "$SOURCE/scripts/search_repo.sh" scripts/
cp "$SOURCE/scripts/setup_search.sh" scripts/
cp "$SOURCE/scripts/validate-all.sh" scripts/
cp "$SOURCE/scripts/validate-skills.sh" scripts/

# --- Core Root Files ---
cp "$SOURCE/.agents/rules/PROJECT_RULES.md" .agents/rules/
cp "$SOURCE/.agents/rules/QUANTIS-STYLE.md" .agents/rules/
cp "$SOURCE/VERSION" ./
```

> **Note:** `.agents/rules/CONSTITUTION.md` is NOT overwritten — it's a user file that may have been customized.

---

## 6. Cleanup

```bash
rm -rf .quantis-update-temp
```

---

## 7. Confirm

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► UPDATED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Updated to version {remote-version}

Updated:
• Workflows (30 _wf-* dirs)
• Core skills (18 from MANIFEST)
• Templates, Adapters
• Core Docs and Scripts
• Rules (.agents/rules/PROJECT_RULES.md, QUANTIS-STYLE.md)

Preserved:
• Your .quantis/ state (SPEC, ROADMAP, STATE, etc.)
• Your .agents/rules/CONSTITUTION.md
• Any user-installed skills not in MANIFEST

───────────────────────────────────────────────────────

/whats-new — See what changed

───────────────────────────────────────────────────────
```

</process>

<preserved_files>
These user files are NEVER overwritten:
- .quantis/SPEC.md
- .quantis/ROADMAP.md
- .quantis/STATE.md
- .quantis/ARCHITECTURE.md
- .quantis/STACK.md
- .quantis/DECISIONS.md
- .quantis/JOURNAL.md
- .quantis/TODO.md
- .quantis/phases/*
- .agents/rules/CONSTITUTION.md
</preserved_files>
