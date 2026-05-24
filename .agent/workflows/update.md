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
remote_version=$(cat .quantis-update-temp/quantis-new/VERSION 2>/dev/null || echo "unknown")
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
SOURCE=".quantis-update-temp/quantis-new"

# --- Core Workflows ---
# Replace all workflows listed in MANIFEST.md
cp -r "$SOURCE/.agent/workflows/"* .agent/workflows/

# --- Core Skills (MANIFEST-aware) ---
# Only replace skills listed in MANIFEST.md
# This preserves any user-installed skills not in the manifest
for skill_dir in $(ls "$SOURCE/.agents/skills/"); do
    if grep -q "^- $skill_dir$" "$SOURCE/MANIFEST.md"; then
        rm -rf ".agents/skills/$skill_dir"
        cp -r "$SOURCE/.agents/skills/$skill_dir" ".agents/skills/"
    fi
done

# --- Templates ---
cp -r "$SOURCE/.quantis/templates/"* .quantis/templates/

# --- Bootstrap ---
cp "$SOURCE/.gemini/GEMINI.md" .gemini/GEMINI.md

# --- Adapters ---
cp -r "$SOURCE/adapters/"* adapters/

# --- Docs ---
cp -r "$SOURCE/docs/"* docs/ 2>/dev/null || true

# --- Core Root Files ---
cp "$SOURCE/PROJECT_RULES.md" ./
cp "$SOURCE/QUANTIS-STYLE.md" ./
cp "$SOURCE/CHANGELOG.md" ./
cp "$SOURCE/VERSION" ./
cp "$SOURCE/MANIFEST.md" ./
cp "$SOURCE/model_capabilities.yaml" ./
```

> **Note:** CONSTITUTION.md is NOT overwritten — it's a user file that may have been customized.
> README.md is updated since it's project documentation, not user state.

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
• Workflows (29)
• Core skills (18 from MANIFEST)
• Templates, adapters, docs
• Root files (PROJECT_RULES, CHANGELOG, VERSION, etc.)

Preserved:
• Your .quantis/ state (SPEC, ROADMAP, STATE, etc.)
• Your CONSTITUTION.md
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
- CONSTITUTION.md
</preserved_files>
