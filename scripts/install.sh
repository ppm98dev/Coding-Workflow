#!/usr/bin/env bash
# Install Quantis v4 (Cursor) into the current project.
# Additive: copies skills, rules, and templates — never touches project state
# (.quantis/ROADMAP.md, STATE.md, phases/, archive/, constitution.mdc).
# Idempotent: re-running refreshes the Quantis files to the latest version.
#
# Usage (from the project root):
#   curl -sSL https://raw.githubusercontent.com/ppm98dev/Coding-Workflow/main/scripts/install.sh | bash

set -euo pipefail

REPO="${QUANTIS_REPO:-https://github.com/ppm98dev/Coding-Workflow.git}"
Q=".quantis"

say() { printf '\033[1m» %s\033[0m\n' "$*"; }
die() { printf '❌ %s\n' "$*" >&2; exit 1; }

# ── Guards ───────────────────────────────────────────────────────────────
if [ -d .agents/skills ] || [ -f "$Q/SPEC.md" ]; then
    die "Quantis v3 (Antigravity) footprint detected — use the migration script instead:
  curl -sSL https://raw.githubusercontent.com/ppm98dev/Coding-Workflow/main/scripts/migrate-v3-to-v4.sh | bash"
fi

# ── Fetch ────────────────────────────────────────────────────────────────
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
say "Fetching Quantis…"
git clone --quiet --depth 1 "$REPO" "$TMP"
[ -d "$TMP/.cursor/skills" ] || die "The Quantis repo at $REPO doesn't ship v4 (.cursor/skills missing)."

# ── Install (Quantis files only) ─────────────────────────────────────────
UPDATING=false; [ -f "$Q/VERSION" ] && UPDATING=true

mkdir -p .cursor/skills .cursor/rules "$Q"
# remove stale q-* skills so renamed/deleted ones don't linger, then copy fresh
find .cursor/skills -maxdepth 1 -type d -name 'q-*' -exec rm -rf {} +
cp -R "$TMP/.cursor/skills/." .cursor/skills/
cp "$TMP/.cursor/rules/quantis.mdc" .cursor/rules/
rm -rf "$Q/templates" && cp -R "$TMP/.quantis/templates" "$Q/templates"
cp "$TMP/.quantis/VERSION" "$Q/VERSION"

VERSION=$(cat "$Q/VERSION")
if $UPDATING; then
    say "Quantis updated to v$VERSION (project state untouched)."
else
    say "Quantis v$VERSION installed."
fi

echo
echo "Installed: .cursor/skills/q-*  ·  .cursor/rules/quantis.mdc  ·  $Q/templates/"
echo "Review with git status, then commit."
echo
echo "Next, in Cursor:"
if [ -f "$Q/ROADMAP.md" ]; then
    echo "  /q-status  — see where the project stands"
else
    echo "  /q-init    — set up ROADMAP.md and STATE.md"
fi
