# [PROJECT_NAME] Constitution

> **Purpose**: Project-level quality standards that govern how code is written.
> Loaded by `/plan` and `/execute` on every run. Violations must be justified.
>
> ⚠️ Fill this during `/new-project`. Each article has defaults — accept or customize.

---

## Core Principles

### Article 1: Code Quality Standards
<!-- What: naming, function size, structure -->
- **Naming**: Use descriptive names. No single-letter variables except loop counters (`i`, `j`).
  - Functions: `verb_noun` (Python) or `verbNoun` (JS/TS). Example: `fetch_user`, `validateInput`
  - Constants: `UPPER_SNAKE_CASE`
- **Function Length**: Max ~20 lines. If longer, extract a helper.
- **Single Responsibility**: Each function does ONE thing. Each module has ONE reason to change.
- **No God Functions**: If a function has more than 3 levels of nesting, refactor it.
<!-- Customize: adjust naming convention, max line count, nesting limits for your stack -->

### Article 2: Error Handling
<!-- What: strategy, patterns, required behavior on failure -->
- **Strategy**: [FILL: fail-fast / graceful degradation / hybrid]
- **Pattern**: Every external call (API, DB, file I/O) MUST be wrapped in error handling.
- **Required**: Log the error with context (what was attempted, what input caused it).
- **Forbidden**: Empty catch blocks. Silent swallowing of exceptions. Generic `catch (e) {}`.
- **User-Facing Errors**: Return meaningful messages, never stack traces.
<!-- Customize: choose strategy, define retry policy, set max retries -->

### Article 3: Logging & Observability
<!-- What: log format, levels, what events to capture -->
- **Format**: [FILL: structured JSON / plaintext / framework default]
- **Minimum Level**: [FILL: DEBUG in dev, INFO in prod / WARNING in prod]
- **Required Events**: Application start/stop, authentication attempts, errors, external API calls.
- **Forbidden**: Logging sensitive data (passwords, tokens, PII). Logging inside tight loops.
- **Correlation**: Include request/trace IDs where applicable.
<!-- Customize: choose log library, define log rotation, set alert thresholds -->

### Article 4: Input Validation
<!-- What: where to validate, how, sanitization rules -->
- **Boundary Rule**: Validate at system boundaries (API endpoints, CLI args, file inputs). Trust nothing from outside.
- **Method**: Use schema-based validation where possible (Pydantic, Zod, JSON Schema).
- **Sanitization**: Strip/escape user input before rendering or database insertion.
- **Type Safety**: Prefer typed parameters over raw strings. Parse, don't validate.
- **Fail Early**: Reject invalid input immediately with clear error messages.
<!-- Customize: choose validation library, define custom rules -->

### Article 5: Testing Strategy
<!-- What: test types, coverage, test-first mandate -->
- **Test-First**: [FILL: mandatory TDD / tests alongside code / tests after code]
- **Coverage Target**: [FILL: 80% / 90% / best-effort]
- **Test Types**: Unit tests for logic, integration tests for boundaries, e2e tests for critical paths.
- **Anti-Patterns**: No mocking the thing you're testing. No `assert True`. No tests that pass with implementation deleted.
- **File Creation Order**: Contracts → Tests → Source (tests must exist before source files).
<!-- Customize: set coverage threshold, choose test framework, define what gets e2e tested -->

### Article 6: Security Defaults
<!-- What: secrets, queries, auth, CORS -->
- **Secrets**: NEVER hardcode. Use environment variables or secret managers. No secrets in git.
- **Queries**: Use parameterized queries / prepared statements. No string concatenation for SQL.
- **Authentication**: [FILL: auth method — JWT, session, OAuth, none for internal tools]
- **CORS**: Whitelist specific origins. Never use `*` in production.
- **Dependencies**: Audit for known vulnerabilities before adding. Keep updated.
<!-- Customize: define auth flow, set CORS origins, choose secret manager -->

### Article 7: Documentation
<!-- What: docstrings, READMEs, API docs -->
- **Functions**: [FILL: docstrings required on public functions / all functions / critical only]
- **Modules**: Each module/package should have a brief README or top-level docstring explaining purpose.
- **API Endpoints**: Document request/response schemas, error codes, and examples.
- **Inline Comments**: Explain WHY, not WHAT. Code should be self-documenting for the WHAT.
- **Keep Updated**: Delete stale comments. Outdated docs are worse than no docs.
<!-- Customize: choose doc format (JSDoc, Google-style, NumPy-style), set doc requirements -->

### Article 8: Performance
<!-- What: common pitfalls to avoid, awareness rules -->
- **N+1 Queries**: Never fetch related data in a loop. Use joins, eager loading, or batch queries.
- **Unbounded Operations**: Every loop/query/collection MUST have a reasonable limit. No `SELECT *` without `LIMIT`.
- **Memory**: Close resources (file handles, DB connections, streams). Use `with`/`using`/`try-finally`.
- **Caching**: Cache expensive computations. Invalidate on mutation. Define TTL.
- **Performance Targets**: [FILL: p95 latency target, throughput target, or "best effort"]
<!-- Customize: set specific latency/throughput targets, define caching strategy -->

### Article 9: Dependency Policy
<!-- What: adding, updating, managing external dependencies -->
- **Approval**: [FILL: any dep allowed / review before adding / max N dependencies]
- **Version Pinning**: Pin exact versions in lockfiles. Use ranges only in library code.
- **Evaluation Criteria**: Maintained (updated in last 6 months)? >1000 stars/downloads? Known vulnerabilities?
- **Minimize**: Prefer standard library over external deps. Don't add a library for one function.
- **Audit**: Run `npm audit` / `pip audit` / equivalent before releases.
<!-- Customize: set max dependency count, define evaluation criteria -->

### Article 10: Architecture
<!-- What: structure, layers, dependency direction -->
- **Separation of Concerns**: UI, business logic, and data access in separate layers/modules.
- **Dependency Direction**: Dependencies point inward (UI → Business Logic → Data). Never reverse.
- **No Circular Dependencies**: If A imports B, B must NEVER import A (directly or transitively).
- **Interface Boundaries**: Modules communicate through well-defined interfaces, not internal details.
- **Simplicity**: Start with the simplest architecture that works. Add layers only when proven necessary.
<!-- Customize: define your specific layers, set module boundaries -->

---

## Governance

- This constitution supersedes personal coding habits during this project.
- All plans and code must comply. Violations require documented justification in the plan.
- Amendments: update this file, document rationale, commit with `docs: amend constitution`.

**Version**: 1.0.0 | **Ratified**: [DATE] | **Last Amended**: [DATE]
