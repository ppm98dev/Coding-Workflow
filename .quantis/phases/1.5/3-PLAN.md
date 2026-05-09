---
phase: 1.5
plan: 3
wave: 3
---

# Plan 1.5.3: README Rewrite + External Docs

## Objective
Full README rewrite with Quantis branding. Update to reflect Phase 1 features (constitution, stress-test, clarification markers). Update scripts, adapters, and LICENSE references.

## Context
- .quantis/ROADMAP.md (Phase 1.5 definition)
- .quantis/DECISIONS.md (all Phase 1 decisions)
- README.md (current 543-line version — needs full rewrite)

## Tasks

<task type="auto">
  <name>Rewrite README.md with Quantis branding</name>
  <files>README.md</files>
  <action>
    Full rewrite of README.md. Key changes:

    1. **Header/Banner**: Replace "Get Shit Done for Antigravity" with "Quantis" branding
       - Update version badge to 2.1.0
       - Replace "Based on GSD" badge with "Evolved from GSD" or remove
       - New tagline: something like "Spec-Driven Development for AI Coding"

    2. **The Problem section**: Update to mention constitution and spec rigor, not just "inconsistent garbage"
       - "Without Quantis" vs "With Quantis" comparison should highlight constitution + clarification markers

    3. **How It Works section**: Update the mermaid diagram to include:
       - Constitution creation (first step)
       - Stress-test (after SPEC)
       - The flow: Constitution → SPEC → /stress-test → /plan → /execute → /verify

    4. **New section: "Quality Governance"** (after How It Works):
       - CONSTITUTION.md — project-level quality standards (10 articles)
       - [NEEDS CLARIFICATION] markers — forced rigor in specs
       - /stress-test — adversarial spec review
       - Separation Rule — SPEC = WHAT, PLAN = HOW

    5. **Commands section**: Add new commands:
       - `/stress-test` in Core Workflow table
       - Update `/new-project` description to mention constitution creation
       - Total should now be 28 (27 + stress-test)

    6. **File Structure**: Update `.gsd/` → `.quantis/`, add CONSTITUTION.md, add stress-test.md
       - `GSD-STYLE.md` → `QUANTIS-STYLE.md`

    7. **Philosophy section**: Add "Spec-driven" and "Constitutional governance" principles

    8. **Footer**: Update attribution. Keep "Evolved from GSD" credit but establish Quantis as its own project.

    Keep the same visual quality — badges, mermaid diagrams, tables, emoji.
    The README should be ~500-550 lines (similar to current).
  </action>
  <verify>
    grep -q "Quantis" README.md && \
    grep -q "CONSTITUTION" README.md && \
    grep -q "stress-test" README.md && \
    grep -q ".quantis" README.md && \
    ! grep -q "GSD" README.md | head -5 && \
    echo "PASS"
  </verify>
  <done>
    - README branded as Quantis
    - Phase 1 features highlighted (constitution, stress-test, markers)
    - Mermaid diagrams updated
    - File structure shows .quantis/
    - Command count updated (28)
    - Attribution credits original GSD
  </done>
</task>

<task type="auto">
  <name>Update scripts and adapters</name>
  <files>
    scripts/install.sh
    scripts/validate-all.sh
    scripts/validate-workflows.sh
    scripts/validate-skills.sh
    scripts/validate-templates.sh
    adapters/ANTIGRAVITY.md
    adapters/CLAUDE.md
    docs/runbook.md
    docs/model-selection-playbook.md
    docs/token-optimization-guide.md
  </files>
  <action>
    1. **install.sh**: Update all references:
       - "GSD" → "Quantis" in echo messages
       - `.gsd` → `.quantis` in paths
       - `GSD-STYLE.md` → `QUANTIS-STYLE.md` in copy commands

    2. **validate-*.sh**: Update:
       - `.gsd` → `.quantis` in all path checks
       - "GSD" → "Quantis" in echo messages

    3. **adapters/*.md**: Update framework references

    4. **docs/*.md**: Update all internal references

    Use sed for batch processing:
    ```bash
    find scripts -name "*.sh" -exec sed -i '' 's/\.gsd/\.quantis/g; s/GSD/Quantis/g; s/GSD-STYLE/QUANTIS-STYLE/g' {} +
    find adapters docs -name "*.md" -exec sed -i '' 's/GSD/Quantis/g' {} +
    ```
  </action>
  <verify>
    grep -rl "GSD\|\.gsd" scripts/ adapters/ docs/ | grep -v ".git/" | wc -l
  </verify>
  <done>
    - All scripts reference .quantis/ paths
    - All adapters reference Quantis framework
    - All docs updated
    - Zero remaining GSD/gsd references in scripts, adapters, docs
  </done>
</task>

## Success Criteria
- [ ] README fully rebranded as Quantis with Phase 1 features
- [ ] All scripts work with .quantis/ paths
- [ ] All adapters and docs reference Quantis
