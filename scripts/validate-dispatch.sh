#!/bin/bash
# Quantis Dispatch-Wiring Validation Script
# Enforces the Phase 3.3 contract: every subagent dispatch hands its
# methodology skill BY PATH (Read and follow .agents/skills/<X>/SKILL.md),
# never pasted skill text.
#
# For every file that contains a dispatch keyword (invoke_subagent /
# define_subagent / fan-out), assert that a .agents/skills/<X>/SKILL.md
# path also appears in the file (near the dispatch site), OR that the
# file is on the explicit allow-list below with a reason.

error_count=0
files_checked=0

# Resolve repo root from this script's location so the validator works
# regardless of the caller's current working directory.
script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
cd "$repo_root" || exit 1

# Files that legitimately contain a dispatch keyword but do NOT need to hand
# a separate .agents/skills/<X>/SKILL.md path. Format: "path|reason".
# These are the methodology skills themselves, so the dispatch is either the
# subject being taught or hands its own in-skill template.
allow_list=(
    ".agents/skills/dispatching-parallel-agents/SKILL.md|This IS the parallel-dispatch methodology; its invoke_subagent lines are the lesson, not a fan-out to another skill."
    ".agents/skills/requesting-code-review/SKILL.md|This IS the code-review methodology; the dispatch hands its own code-reviewer.md template, not a separate SKILL.md."
    ".agents/skills/subagent-driven-development/SKILL.md|Dispatches via define_subagent handing the prompt files (implementer/spec-reviewer/code-quality-reviewer-prompt.md); each prompt carries its OWN REQUIRED SUB-SKILL real-skill path and is validated separately as a dispatch candidate."
)

# Dispatch keywords that mark a real or illustrative dispatch site.
dispatch_re='invoke_subagent|define_subagent|fan-out|fan out'

# A handed-by-path skill reference (the contract). Must be a REAL skill name
# ([a-zA-Z0-9_-]+) — a literal contract placeholder like `.agents/skills/<X>/SKILL.md`
# must NOT count as wiring (otherwise any file passes just by quoting the rule).
path_re='\.agents/skills/[a-zA-Z0-9_-]+/SKILL\.md'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Quantis ► VALIDATING DISPATCH WIRING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

in_allow_list() {
    local target="$1"
    local entry
    for entry in "${allow_list[@]}"; do
        if [ "${entry%%|*}" = "$target" ]; then
            return 0
        fi
    done
    return 1
}

allow_reason() {
    local target="$1"
    local entry
    for entry in "${allow_list[@]}"; do
        if [ "${entry%%|*}" = "$target" ]; then
            echo "${entry#*|}"
            return 0
        fi
    done
    echo ""
}

# Candidate files: all skill SKILL.md plus the SDD prompt files.
candidates=$(ls .agents/skills/*/SKILL.md .agents/skills/subagent-driven-development/*-prompt.md 2>/dev/null)

for file in $candidates; do
    # Only files that contain a dispatch keyword are subject to the contract.
    if ! grep -qE "$dispatch_re" "$file"; then
        continue
    fi

    ((files_checked++))

    if grep -qE "$path_re" "$file"; then
        echo "✅ $file (hands skill by path)"
        continue
    fi

    if in_allow_list "$file"; then
        echo "➖ $file (allow-listed: $(allow_reason "$file"))"
        continue
    fi

    echo "❌ $file: has a dispatch keyword but no .agents/skills/<X>/SKILL.md path handed over, and is not allow-listed"
    ((error_count++))
done

echo ""
echo "───────────────────────────────────────────────────────"
echo ""
echo "Dispatch files checked: $files_checked"
echo "Errors: $error_count"
echo ""

if [ $error_count -eq 0 ]; then
    echo "✅ All dispatch sites hand their skill by path (or are allow-listed)!"
    exit 0
else
    echo "❌ Validation failed: bare dispatcher(s) found"
    exit 1
fi
