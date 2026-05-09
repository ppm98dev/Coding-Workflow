# Decisions

> Previous milestone decisions archived in `.quantis/milestones/v2.0/DECISIONS.md`

---

## Phase 1 Decisions (Constitution & Spec Rigor)

**Date:** 2026-05-09
**Context:** Discussion before planning Phase 1. Studied Spec-Kit repo (cloned to `.quantis/references/spec-kit/`) for implementation patterns.

### D-001: Constitution Scope — Comprehensive
**Decision:** ~150 lines covering 10 articles: Code Quality, Error Handling, Logging, Input Validation, Testing Strategy, Security Defaults, Documentation, Performance, Dependency Policy, Architecture.
**Rationale:** The #1 gap is "it works" code vs production code. A comprehensive constitution is the enforcement mechanism.

### D-002: Clarification Markers — Both Inline + Summary
**Decision:** Use inline `[NEEDS CLARIFICATION: specific question]` markers in SPEC.md body AND an auto-generated "Unresolved Questions" summary section at the bottom.
**Rationale:** Inline markers keep ambiguity visible in context. Summary section gives a scannable overview. `/stress-test` auto-generates the summary from inline markers.

### D-003: Spec/Plan Separation — Strict (Additive)
**Decision:** SPEC = pure user intent, PLAN = technical choices. But existing Constraints section stays as-is — "MIT licensed", "macOS only" are legitimate project constraints, not tech implementation details.
**Rationale:** Studied Spec-Kit's spec template — their spec has zero tech details. Our existing constraints are business constraints, not tech choices. No restructuring needed, just add new sections.

### D-004: Stress-Test Mode — Adversarial
**Decision:** `/stress-test` adversarially argues with the spec: finds vague terms, probes failure modes, spots contradictions, challenges assumptions, surfaces edge cases.
**Rationale:** A checklist catches known gaps. Adversarial questioning catches unknown unknowns.

### D-005: Constitution Creation — Interactive Q&A in /new-project
**Decision:** Add constitution creation as a new phase in `/new-project` with interactive Q&A about code style, error handling, testing strategy, etc.
**Rationale:** Each project has different quality standards. Interactive creation ensures the constitution reflects actual project needs.

### D-006: Missing Constitution — Hard Fail
**Decision:** `/plan` hard-fails if CONSTITUTION.md doesn't exist.
**Rationale:** The constitution is the enforcement mechanism for production code quality. Without it, the entire v2.1 purpose is defeated.

### D-007: SPEC Template Changes — Additive Only
**Decision:** Add new sections (Quality Requirements, Unresolved Questions, Edge Cases, `[NEEDS CLARIFICATION]` instructions) without removing or restructuring existing sections.
**Rationale:** No breaking changes. Existing projects continue working.

### D-008: Constitution vs PROJECT_RULES — Separate Concerns
**Decision:** Constitution is project-specific (per-project, filled during `/new-project`). PROJECT_RULES.md and QUANTIS-STYLE.md stay as framework-level rules.
**Rationale:** PROJECT_RULES defines Quantis framework conventions. Constitution defines project-specific quality standards. Different scopes, no overlap.

### D-009: Constitution Articles — 10 Articles
**Decision:** Template includes 10 articles:
1. Code Quality Standards (naming, function length, separation of concerns)
2. Error Handling (strategy, patterns, logging on errors)
3. Logging & Observability (structured/plaintext, levels, what to log)
4. Input Validation (boundaries, schemas, sanitization)
5. Testing Strategy (unit/integration/e2e balance, coverage, test-first)
6. Security Defaults (no hardcoded secrets, parameterized queries, CORS)
7. Documentation (docstrings, README, API docs)
8. Performance (N+1, unbounded loops, memory)
9. Dependency Policy (approval, max deps, version pinning)
10. Architecture (separation of concerns, layers, dependency direction)

### D-010: Constitution Placement in /new-project — First Step
**Decision:** Constitution Q&A is the very first step in `/new-project`, before spec creation.
**Rationale:** Quality standards should be defined before writing requirements. The constitution informs how the spec is written.

### D-011: Stress-Test Trigger — Suggested, Not Forced
**Decision:** `/new-project` suggests running `/stress-test` after SPEC creation but doesn't force it. `/plan` hard-fails on unresolved `[NEEDS CLARIFICATION]` markers as the actual safety net.
**Rationale:** Two-layer protection — stress-test catches gaps proactively, plan-checker catches them mandatorily. Forcing stress-test on every project is heavy for simple projects.
