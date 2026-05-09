---
phase: 1
plan: 1
wave: 1
---

# Plan 1.1: Constitution Template + /new-project Integration

## Objective
Create the CONSTITUTION.md template with 10 comprehensive articles and integrate constitution creation as the first step in `/new-project`. This is the foundation — everything else in Phase 1 depends on the constitution existing.

## Context
- .quantis/DECISIONS.md (D-001, D-005, D-008, D-009, D-010)
- .quantis/references/spec-kit/templates/constitution-template.md
- .quantis/references/spec-kit/spec-driven.md (Articles I-IX, constitutional enforcement)
- .quantis/templates/spec.md (existing template structure for reference)
- .agent/workflows/new-project.md

## Tasks

<task type="auto">
  <name>Create CONSTITUTION.md template</name>
  <files>.quantis/templates/constitution.md</files>
  <action>
    Create a comprehensive constitution template with 10 articles. Each article should have:
    - A clear principle name and description
    - Concrete rules (not vague guidance)
    - Examples of what's acceptable and what's NOT
    - Placeholder comments for project-specific customization

    Articles (from D-009):
    1. Code Quality Standards — naming conventions, max function length (~20 lines), no God functions, single responsibility
    2. Error Handling — strategy choice (fail-fast/graceful), required patterns, mandatory error logging
    3. Logging & Observability — structured vs plaintext, required log levels, what events to log
    4. Input Validation — validate at boundaries, schema-based validation, sanitization rules
    5. Testing Strategy — unit/integration/e2e balance, coverage targets, test-first mandate
    6. Security Defaults — no hardcoded secrets, parameterized queries, CORS policy, auth patterns
    7. Documentation — docstring requirements, README per module, API doc format
    8. Performance — N+1 query awareness, unbounded loop prevention, memory leak patterns to avoid
    9. Dependency Policy — max dependencies, version pinning, approval process for new deps
    10. Architecture — separation of concerns, layer boundaries, dependency direction (inward)

    Include sections for:
    - Governance (constitution supersedes project habits, amendment process)
    - Version/ratification metadata

    Reference: .quantis/references/spec-kit/templates/constitution-template.md for structure patterns.
    DO NOT copy their content — their articles (Library-First, CLI Interface) are project-specific to Specify. Ours are about code quality.

    Target: ~150 lines. Each article: ~10-12 lines.
  </action>
  <verify>
    test -f .quantis/templates/constitution.md && \
    grep -c "^### Article" .quantis/templates/constitution.md | grep -q "10" && \
    echo "PASS: Template exists with 10 articles"
  </verify>
  <done>
    - constitution.md template exists in .quantis/templates/
    - Contains exactly 10 numbered articles
    - Each article has principle, rules, and placeholder comments
    - Governance section present
    - Version metadata present
    - ~150 lines total
  </done>
</task>

<task type="auto">
  <name>Add constitution Q&A to /new-project as first step</name>
  <files>.agent/workflows/new-project.md</files>
  <action>
    Modify /new-project workflow to add constitution creation as Phase 1 (renumber existing phases +1).

    New Phase 1: "Create Constitution"
    - Display banner: "GSD ► CONSTITUTION"
    - Explain: "Before defining what to build, let's define HOW you want to build it."
    - Walk through each of the 10 articles with focused questions:
      - "What's your error handling strategy? (fail-fast / graceful degradation / hybrid)"
      - "Logging: structured JSON or plaintext? What events must be logged?"
      - "Testing: what's your minimum coverage target? Test-first mandatory?"
      - etc.
    - For each answer, fill in the corresponding article in the template
    - Create `.quantis/CONSTITUTION.md` from filled template
    - Decision gate: "Review your constitution? (A) Looks good (B) Edit further"

    Renumber existing phases:
    - Old Phase 1 (Setup) → Phase 2
    - Old Phase 2 (Brownfield) → Phase 3
    - Old Phase 3 (Deep Questioning) → Phase 4
    - etc.

    Keep the new phase concise — the Q&A should be conversational, not an interrogation.
    Each article question should have sensible defaults the user can accept or override.
  </action>
  <verify>
    grep -q "Constitution" .agent/workflows/new-project.md && \
    grep -q "CONSTITUTION.md" .agent/workflows/new-project.md && \
    echo "PASS: Constitution phase added to /new-project"
  </verify>
  <done>
    - /new-project has constitution creation as first interactive step
    - All 10 articles covered with focused questions
    - Sensible defaults offered for each article
    - Creates .quantis/CONSTITUTION.md
    - Existing phases renumbered correctly
  </done>
</task>

## Success Criteria
- [ ] Constitution template exists with 10 articles (~150 lines)
- [ ] /new-project creates CONSTITUTION.md as first step
- [ ] Template references are project-specific (not Spec-Kit's articles)
