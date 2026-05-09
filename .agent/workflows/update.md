---
description: Update GSD to the latest version from GitHub
---

# /update Workflow

<objective>
Update GSD for Antigravity to the latest version from GitHub.
</objective>

<process>

## 1. Check Current Version

```bash
if [ -f "CHANGELOG.md" ]; then
    version=$(grep -oP '## \[\K[0-9]+\.[0-9]+\.[0-9]+' CHANGELOG.md | head -1)
    echo "Current version: $version"
fi
```

---

## 2. Fetch Latest from GitHub

```bash
# Clone latest to temp directory
git clone --depth 1 https://github.com/toonight/get-shit-done-for-antigravity.git .quantis-update-temp
```

---

## 3. Compare Versions

```bash
remote_version=$(grep -oP '## \[\K[0-9]+\.[0-9]+\.[0-9]+' .quantis-update-temp/CHANGELOG.md | head -1)
echo "Remote version: $remote_version"
```

**If same version:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► ALREADY UP TO DATE ✓
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
 GSD ► UPDATE AVAILABLE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current: {current-version}
Latest:  {remote-version}

Changes:
{Extract from CHANGELOG.md}

───────────────────────────────────────────────────────

Update now?
A) Yes — Apply updates
B) No — Cancel

───────────────────────────────────────────────────────
```

---

## 5. Apply Updates

**If user confirms:**

```bash
# Backup current
cp -r .agent .agent.backup
cp -r .agents .agents.backup
cp -r .quantis/templates .quantis/templates.backup

# Update workflows (preserve user's .quantis docs)
cp -r .quantis-update-temp/.agent/* .agent/

# Update skills (Agent Skills standard)
cp -r .quantis-update-temp/.agents/* .agents/

# Update templates only
cp -r .quantis-update-temp/.quantis/templates/* .quantis/templates/

# Update root files
cp .quantis-update-temp/GSD-STYLE.md ./
cp .quantis-update-temp/CHANGELOG.md ./
cp .quantis-update-temp/PROJECT_RULES.md ./
cp .quantis-update-temp/VERSION ./
```

---

## 6. Cleanup

```bash
rm -rf .quantis-update-temp
rm -rf .agent.backup
rm -rf .agents.backup
rm -rf .quantis/templates.backup
```

---

## 7. Confirm

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► UPDATED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Updated to version {remote-version}

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
- .gemini/GEMINI.md
</preserved_files>
