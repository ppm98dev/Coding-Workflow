#!/usr/bin/env bash
# Migrate a project from Quantis v3 (Antigravity) to v4 (Cursor).
# Mechanical: salvages old state into the v4 shape, archives originals
# (never deletes them), removes the Antigravity footprint, installs v4.
# Everything lands in ONE commit — `git revert` undoes the whole migration.
#
# Usage (from the project root):
#   curl -sSL https://raw.githubusercontent.com/ppm98dev/Coding-Workflow/main/scripts/migrate-v3-to-v4.sh | bash

set -euo pipefail

REPO="${QUANTIS_REPO:-https://github.com/ppm98dev/Coding-Workflow.git}"
Q=".quantis"

say() { printf '\033[1m» %s\033[0m\n' "$*"; }
die() { printf '❌ %s\n' "$*" >&2; exit 1; }

# ── 1. Guards ────────────────────────────────────────────────────────────
[ -d .git ] || die "Not a git repository. Run from the project root."
[ -d "$Q" ] || [ -d .agents ] || die "No Quantis footprint found — nothing to migrate. Use /q-init for a fresh setup."
if [ -f "$Q/VERSION" ] && [ "$(cut -d. -f1 "$Q/VERSION")" -ge 4 ]; then
    die "Already on Quantis v$(cat "$Q/VERSION"). Use /q-update instead."
fi
[ -z "$(git status --porcelain)" ] || die "Working tree not clean. Commit or stash first — the migration must be one revertable commit."

say "Migrating Quantis v3 → v4 in $(pwd)"

# ── 2. Salvage → build v4 ROADMAP.md ────────────────────────────────────
# extract_section FILE HEADING → prints the section body (until the next ## )
extract_section() {
    [ -f "$1" ] || return 0
    awk -v h="$2" '$0 ~ "^## " h {f=1; next} /^## / {f=0} f' "$1"
}

ARCHIVE="$Q/archive/v3"
mkdir -p "$ARCHIVE" "$Q/phases"

NEW_ROADMAP=$(mktemp)
{
    echo "# ROADMAP.md"
    echo
    echo "> **Project**: $(basename "$(pwd)")"
    MILESTONE=$(grep -m1 -oE 'Current Milestone[^A-Za-z0-9]*[[:alnum:]. -]+' "$Q/ROADMAP.md" 2>/dev/null | sed 's/Current Milestone[^A-Za-z0-9]*//' || true)
    echo "> **Milestone**: ${MILESTONE:-v1.0}"
    if grep -q 'FINALIZED' "$Q/SPEC.md" 2>/dev/null; then
        echo '> **Status**: `FINALIZED`'
    else
        echo '> **Status**: `DRAFT` <!-- resolve [NEEDS CLARIFICATION] markers, then set FINALIZED -->'
    fi
    echo
    echo "## Vision"
    extract_section "$Q/SPEC.md" "Vision"
    echo
    echo "## Non-Goals"
    extract_section "$Q/SPEC.md" "Non-Goals.*"
    echo
    echo "## Success Criteria"
    extract_section "$Q/SPEC.md" "Success Criteria"
    echo
    echo "---"
    echo
    echo "## Phases"
    # copy the phases as-is from the old roadmap (### Phase blocks); statuses survive
    awk '/^#{2,4} Phase /{f=1} f' "$Q/ROADMAP.md" 2>/dev/null || echo "<!-- no phases found in old ROADMAP — define with /q-next -->"
    echo
    echo "---"
    echo
    echo "## Decisions"
    if [ -f "$Q/DECISIONS.md" ]; then tail -n +2 "$Q/DECISIONS.md"; fi
    echo
    if [ -f "$Q/SPEC.md" ]; then
        echo "## Notes from v3 SPEC (distill or delete)"
        for s in "Goals" "Users" "Constraints" "Edge Cases"; do
            body=$(extract_section "$Q/SPEC.md" "$s")
            [ -n "$body" ] && { echo "### $s"; echo "$body"; }
        done
    fi
} > "$NEW_ROADMAP"

# ── 2b. Link existing v3 plan files into the new roadmap ────────────────
# Old phase dirs (.quantis/phases/{N}[.{M}]-{slug}/) stay where they are;
# each "### Phase N:" heading gets Plan: links to its *PLAN*.md files so
# /q-next sees in-flight phases as planned, not unplanned.
if [ -d "$Q/phases" ]; then
    MAP=$(mktemp)
    for d in "$Q"/phases/*/; do
        [ -d "$d" ] || continue
        num=$(basename "$d" | grep -oE '^[0-9]+(\.[0-9]+)?' || true)
        plans=$(find "$d" -maxdepth 1 -name '*PLAN*.md' 2>/dev/null | sort | paste -sd';' -)
        [ -n "$num" ] && [ -n "$plans" ] && printf '%s\t%s\n' "$num" "$plans" >> "$MAP"
    done
    if [ -s "$MAP" ]; then
        awk -v mapfile="$MAP" '
            BEGIN { while ((getline l < mapfile) > 0) { split(l, a, "\t"); m[a[1]] = a[2] } }
            { print }
            /^#{2,4} Phase [0-9]/ {
                n = $0; sub(/^#+ Phase /, "", n); sub(/[:. ]*$/, "", n); sub(/:.*/, "", n)
                if (n in m) { c = split(m[n], p, ";"); for (i = 1; i <= c; i++) print "Plan: " p[i] }
            }' "$NEW_ROADMAP" > "$NEW_ROADMAP.linked" && mv "$NEW_ROADMAP.linked" "$NEW_ROADMAP"
    fi
    rm -f "$MAP"
fi

# ── 3. Archive originals (never delete state) ───────────────────────────
# Catch-all: everything in .quantis/ moves to the archive EXCEPT what v4 keeps.
# Keeps: phases/ (plans + verification, linked in place), STATE.md (still valid),
# ARCHITECTURE.md/STACK.md (useful planning context), templates/ (replaced below),
# VERSION (overwritten below). Catches milestones/, brainstorm/, DEBUG.md, and
# anything else a v3 project accumulated.
for item in "$Q"/*; do
    base=$(basename "$item")
    case "$base" in
        phases|archive|templates|STATE.md|ARCHITECTURE.md|STACK.md|VERSION) ;;
        *) mv "$item" "$ARCHIVE/$base" ;;
    esac
done
mv "$NEW_ROADMAP" "$Q/ROADMAP.md"
# STATE.md keeps working as-is in v4; create a stub if missing
[ -f "$Q/STATE.md" ] || printf '# STATE.md\n\n## Position\n- **Phase**: see ROADMAP.md\n- **Status**: migrated from v3\n\n## Next Steps\n1. /q-status\n' > "$Q/STATE.md"

# preserve a filled constitution before removing .agents/ (never overwrite an existing one)
if [ -f .agents/rules/CONSTITUTION.md ] && [ ! -f .cursor/rules/constitution.mdc ]; then
    mkdir -p .cursor/rules
    { printf -- '---\ndescription: Project quality standards (migrated from v3 CONSTITUTION.md)\nalwaysApply: true\n---\n\n'; cat .agents/rules/CONSTITUTION.md; } > .cursor/rules/constitution.mdc
fi

# ── 4. Remove the Antigravity footprint (surgically — never whole dirs
#      that might contain project code) ──────────────────────────────────
rm -rf .agents .gemini "$Q/templates"
# adapters/ may be application code in some stacks — only remove the Quantis file
rm -f adapters/ANTIGRAVITY.md 2>/dev/null || true
rmdir adapters 2>/dev/null || true
# root MANIFEST.md: old-installer debris — archive it only if it is Quantis's
if [ -f MANIFEST.md ] && grep -qi quantis MANIFEST.md; then
    mv MANIFEST.md "$ARCHIVE/MANIFEST.md"
fi
# old Quantis validators in scripts/: remove only files that mention Quantis
for s in scripts/validate-*.sh scripts/setup_search.sh scripts/search_repo.sh scripts/upgrade.sh; do
    if [ -f "$s" ] && grep -qi quantis "$s"; then rm -f "$s"; fi
done
rmdir scripts 2>/dev/null || true

# ── 5. Install v4 (skills, rules, templates, VERSION) ───────────────────
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
say "Fetching Quantis v4…"
git clone --quiet --depth 1 "$REPO" "$TMP"
[ -d "$TMP/.cursor/skills" ] || die "The Quantis repo at $REPO doesn't ship v4 (.cursor/skills missing). Nothing was committed — restore with: git checkout -- . && git clean -fd"
mkdir -p .cursor/skills .cursor/rules
cp -R "$TMP/.cursor/skills/." .cursor/skills/
cp "$TMP/.cursor/rules/quantis.mdc" .cursor/rules/
cp -R "$TMP/.quantis/templates" "$Q/templates"
cp "$TMP/.quantis/VERSION" "$Q/VERSION"

# ── 6. One commit ────────────────────────────────────────────────────────
git add -A
git commit -q -m "chore: migrate Quantis v3 (Antigravity) -> v4 (Cursor)

- SPEC/ROADMAP/DECISIONS salvaged into .quantis/ROADMAP.md (v4 schema)
- v3 originals archived under .quantis/archive/v3/ (nothing deleted)
- Antigravity footprint removed (.agents/, .gemini/, adapters/)
- v4 skills + rules + templates installed"

say "Done — one commit, revert with: git revert HEAD"
echo
echo "Next, in Cursor:"
echo "  /q-status   — review the migrated roadmap (tidy the 'Notes from v3 SPEC' section)"
echo "  /q-next     — continue where the project left off"
