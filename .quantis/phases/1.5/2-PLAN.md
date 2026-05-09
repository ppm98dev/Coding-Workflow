---
phase: 1.5
plan: 2
wave: 2
---

# Plan 1.5.2: Brand Name Rename — GSD → Quantis

## Objective
Replace all "GSD" brand name references with "Quantis" in file contents. This covers titles, descriptions, banners, role descriptions, and documentation text. Must be done AFTER Plan 1.5.1 (path rename).

## Context
- .quantis/ROADMAP.md (Phase 1.5 definition)
- All workflow, skill, template, and doc files

## Tasks

<task type="auto">
  <name>Replace GSD brand name with Quantis</name>
  <files>All files containing "GSD" as brand name</files>
  <action>
    Replace "GSD" with "Quantis" across all files. This requires careful handling:

    **Pattern replacements (in order):**

    1. **Banner patterns** — `GSD ►` → `Quantis ►`:
       ```bash
       find .agent .agents .quantis adapters docs scripts -name "*.md" -exec sed -i '' 's/GSD ►/Quantis ►/g' {} +
       ```

    2. **Role/title references** — "GSD planner", "GSD executor", etc.:
       ```bash
       find .agent .agents .quantis -name "*.md" -exec sed -i '' 's/GSD planner/Quantis planner/g; s/GSD executor/Quantis executor/g; s/GSD verifier/Quantis verifier/g; s/GSD plan checker/Quantis plan checker/g; s/GSD debugger/Quantis debugger/g' {} +
       ```

    3. **General "GSD" brand references** — "GSD project", "GSD framework", etc.:
       ```bash
       find . -name "*.md" -not -path "./.git/*" -not -path "./.quantis/references/*" -exec sed -i '' 's/GSD framework/Quantis framework/g; s/GSD project/Quantis project/g; s/GSD commands/Quantis commands/g; s/GSD workflows/Quantis workflows/g; s/GSD system/Quantis system/g' {} +
       ```

    4. **Remaining standalone "GSD"** — catch remaining instances:
       ```bash
       # First check what's left
       grep -rn "GSD" --include="*.md" --include="*.sh" --include="*.yaml" . | grep -v ".git/" | grep -v "references/spec-kit" | grep -v "QUANTIS-STYLE"
       ```
       Then handle case-by-case. Some "GSD" references in archived milestones may be kept for historical accuracy.

    5. **QUANTIS-STYLE.md content** — update internal references:
       ```bash
       sed -i '' 's/GSD-STYLE/QUANTIS-STYLE/g; s/GSD/Quantis/g' QUANTIS-STYLE.md
       ```

    6. **PROJECT_RULES.md** — update framework name:
       ```bash
       sed -i '' 's/GSD/Quantis/g' PROJECT_RULES.md
       ```

    7. **CHANGELOG.md** — update framework name in header, keep historical entries as-is.

    IMPORTANT: Do NOT rename inside `.quantis/references/spec-kit/` — third-party files.
    IMPORTANT: Archived milestones (.quantis/milestones/v2.0/) can keep historical "GSD" references for accuracy.
    IMPORTANT: The `.gemini/GEMINI.md` should reference "Quantis" not "GSD".
  </action>
  <verify>
    echo "=== Remaining GSD references (excluding archives + spec-kit) ===" && \
    grep -rn "GSD" --include="*.md" --include="*.sh" --include="*.yaml" . | \
    grep -v ".git/" | grep -v "references/spec-kit" | grep -v "milestones/v2.0" | \
    grep -v "CHANGELOG" | wc -l
  </verify>
  <done>
    - All active files use "Quantis" instead of "GSD"
    - Banners show "Quantis ►" instead of "GSD ►"
    - Role descriptions say "Quantis planner/executor/etc."
    - Historical archives may retain "GSD" for accuracy
  </done>
</task>

<task type="auto">
  <name>Update .gemini/GEMINI.md</name>
  <files>.gemini/GEMINI.md</files>
  <action>
    Update the Gemini configuration file to reference "Quantis" and `.quantis/` paths.

    ```bash
    sed -i '' 's/GSD/Quantis/g; s/\.quantis/\.quantis/g' .gemini/GEMINI.md
    ```
  </action>
  <verify>
    grep -c "Quantis\|\.quantis" .gemini/GEMINI.md
  </verify>
  <done>
    - GEMINI.md references Quantis framework
    - All .quantis/ paths correct
  </done>
</task>

## Success Criteria
- [ ] Zero "GSD" brand references in active files (excluding archives)
- [ ] All banners show "Quantis ►"
- [ ] .gemini/GEMINI.md updated
