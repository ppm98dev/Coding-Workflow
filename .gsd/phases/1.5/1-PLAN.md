---
phase: 1.5
plan: 1
wave: 1
---

# Plan 1.5.1: Physical Rename — Directory + File Structure

## Objective
Rename the `.gsd/` directory to `.quantis/` and rename `GSD-STYLE.md`. Then batch-replace all path references (`.gsd/` → `.quantis/`) across every file in the project.

## Context
- .gsd/ROADMAP.md (Phase 1.5 definition)
- .gsd/DECISIONS.md (rebranding decision)

## Tasks

<task type="auto">
  <name>Rename directories and files</name>
  <files>
    .gsd/ → .quantis/
    GSD-STYLE.md → QUANTIS-STYLE.md
  </files>
  <action>
    1. Use `git mv` to rename the directory:
       ```bash
       git mv .gsd .quantis
       ```

    2. Rename GSD-STYLE.md:
       ```bash
       git mv GSD-STYLE.md QUANTIS-STYLE.md
       ```

    3. Verify the moves:
       ```bash
       ls -la .quantis/
       ls -la QUANTIS-STYLE.md
       ```

    DO NOT modify any file contents yet — just physical renames.
  </action>
  <verify>
    test -d .quantis && test -f QUANTIS-STYLE.md && ! test -d .gsd && echo "PASS"
  </verify>
  <done>
    - .gsd/ directory renamed to .quantis/
    - GSD-STYLE.md renamed to QUANTIS-STYLE.md
    - Old names no longer exist
    - Git tracks the renames
  </done>
</task>

<task type="auto">
  <name>Batch replace all .gsd path references</name>
  <files>All 99+ files containing ".gsd"</files>
  <action>
    Use `sed` to replace all `.gsd/` → `.quantis/` and `.gsd` → `.quantis` path references.

    Target file groups (use `find` + `sed`):

    1. **Workflow files** (.agent/workflows/*.md):
       ```bash
       find .agent/workflows -name "*.md" -exec sed -i '' 's/\.gsd/\.quantis/g' {} +
       ```

    2. **Skill files** (.agents/skills/**/*.md):
       ```bash
       find .agents/skills -name "*.md" -exec sed -i '' 's/\.gsd/\.quantis/g' {} +
       ```

    3. **Quantis internal files** (.quantis/**/*.md):
       ```bash
       find .quantis -name "*.md" -exec sed -i '' 's/\.gsd/\.quantis/g' {} +
       ```

    4. **Root-level files**:
       ```bash
       for f in README.md CHANGELOG.md QUANTIS-STYLE.md PROJECT_RULES.md; do
         [ -f "$f" ] && sed -i '' 's/\.gsd/\.quantis/g' "$f"
       done
       ```

    5. **Scripts** (scripts/*.sh):
       ```bash
       find scripts -name "*.sh" -exec sed -i '' 's/\.gsd/\.quantis/g' {} +
       ```

    6. **Adapters and docs**:
       ```bash
       find adapters docs -name "*.md" -exec sed -i '' 's/\.gsd/\.quantis/g' {} +
       ```

    7. **Gemini config**:
       ```bash
       sed -i '' 's/\.gsd/\.quantis/g' .gemini/GEMINI.md
       ```

    8. **YAML files**:
       ```bash
       find . -name "*.yaml" -o -name "*.yml" | grep -v ".git/" | xargs sed -i '' 's/\.gsd/\.quantis/g'
       ```

    IMPORTANT: Do NOT touch files inside `.quantis/references/spec-kit/` — those are third-party.
    IMPORTANT: Use `sed -i '' ` (with empty string) for macOS compatibility.
  </action>
  <verify>
    echo "Remaining .gsd references:" && \
    grep -rl "\.gsd/" --include="*.md" --include="*.sh" --include="*.yaml" . | \
    grep -v ".git/" | grep -v "references/spec-kit" | \
    grep -v ".quantis/references" | wc -l
  </verify>
  <done>
    - Zero files contain ".gsd/" references (excluding spec-kit reference)
    - All paths point to .quantis/
  </done>
</task>

## Success Criteria
- [ ] .gsd/ directory no longer exists — renamed to .quantis/
- [ ] GSD-STYLE.md renamed to QUANTIS-STYLE.md
- [ ] Zero remaining .gsd/ path references in project files
