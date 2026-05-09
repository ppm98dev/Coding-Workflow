---
phase: 1
plan: 3
wave: 2
---

# Plan 1.3: /plan + /execute Constitution Loading

## Objective
Make `/plan` and `/execute` workflows load CONSTITUTION.md as required context. `/plan` hard-fails if CONSTITUTION.md doesn't exist (D-006). This ensures every plan and execution respects project quality standards.

## Context
- .gsd/DECISIONS.md (D-006, D-008)
- .agent/workflows/plan.md
- .agent/workflows/execute.md
- .gsd/templates/constitution.md (created in Plan 1.1)

## Tasks

<task type="auto">
  <name>Update /plan to require and load CONSTITUTION.md</name>
  <files>.agent/workflows/plan.md</files>
  <action>
    Make two changes to plan.md:

    1. In Step 1 (Validate Environment), add constitution check AFTER the SPEC finalization check:
       ```bash
       # Check CONSTITUTION.md exists
       if [ ! -f ".gsd/CONSTITUTION.md" ]; then
           echo "Error: CONSTITUTION.md required. Run /new-project or create one from .gsd/templates/constitution.md" >&2
           exit 1
       fi
       ```

    2. In Step 6a (Gather Context), add CONSTITUTION.md to the context loading list:
       ```markdown
       ### 6a. Gather Context
       Load:
       - `.gsd/CONSTITUTION.md` — Project quality standards (REQUIRED)
       - `.gsd/SPEC.md` — Requirements
       - `.gsd/REQUIREMENTS.md` — Formal requirements tracking (if exists)
       - `.gsd/ROADMAP.md` — Phase description
       - `$PHASE_DIR/RESEARCH.md` — If exists
       - `.gsd/ARCHITECTURE.md` — If exists
       ```

    3. Add a note in the philosophy section or process section:
       ```markdown
       ## Constitutional Compliance
       Every plan MUST comply with CONSTITUTION.md. Tasks that would violate 
       constitutional articles must either:
       - Be restructured to comply, or
       - Document the violation with justification in the plan
       ```

    DO NOT change the existing plan structure, task types, or wave logic.
    These are additive changes only.
  </action>
  <verify>
    grep -q "CONSTITUTION.md" .agent/workflows/plan.md && \
    grep -q "CONSTITUTION.md required" .agent/workflows/plan.md && \
    echo "PASS: /plan requires and loads CONSTITUTION.md"
  </verify>
  <done>
    - /plan hard-fails if CONSTITUTION.md doesn't exist
    - CONSTITUTION.md is in the context loading list
    - Constitutional compliance note added
    - Existing workflow logic unchanged
  </done>
</task>

<task type="auto">
  <name>Update /execute to load CONSTITUTION.md</name>
  <files>.agent/workflows/execute.md</files>
  <action>
    Make two changes to execute.md:

    1. In Step 1 (Validate Environment), add constitution check:
       ```bash
       test -f ".gsd/CONSTITUTION.md"
       ```
       If not found: Warning (not hard fail — /plan already gates this, but /execute should still check).

    2. In Step 6a (Execute Plans in Wave), add instruction to load CONSTITUTION.md as context alongside the PLAN.md:
       ```markdown
       1. **Load plan context** — Read the PLAN.md file AND `.gsd/CONSTITUTION.md`
       ```

    3. Add a note about constitutional compliance during execution:
       ```markdown
       > **Constitutional Compliance**: While executing tasks, verify code follows 
       > CONSTITUTION.md articles. Error handling, logging, validation, and testing 
       > must match constitutional requirements. If a task produces code that violates 
       > the constitution, fix it before committing.
       ```

    DO NOT change the existing execution flow, wave logic, or commit structure.
    These are additive changes only.
  </action>
  <verify>
    grep -q "CONSTITUTION.md" .agent/workflows/execute.md && \
    echo "PASS: /execute loads CONSTITUTION.md"
  </verify>
  <done>
    - /execute checks for CONSTITUTION.md existence
    - CONSTITUTION.md loaded alongside plan context
    - Constitutional compliance instruction added
    - Existing workflow logic unchanged
  </done>
</task>

## Success Criteria
- [ ] /plan hard-fails without CONSTITUTION.md
- [ ] /plan loads CONSTITUTION.md in context gathering
- [ ] /execute loads CONSTITUTION.md during plan execution
- [ ] Both workflows have constitutional compliance notes
