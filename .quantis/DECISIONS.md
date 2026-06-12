# Decisions

> Previous milestone decisions archived in `.quantis/milestones/v3.2/DECISIONS.md`

---

### D-001: Expand Phase 3.1 to full-audit remediation (nothing deferred)
**Decision:** Pull every audit finding (incl. Issue 5, H7, H11, state-schema, error-paths originally slated for 3.4/3.5) into Phase 3.1.
**Rationale:** User directive; the deferred items were cheap prose fixes and splitting them across phases left the system half-coherent.

### D-002: `/execute` uses subagent-driven-development as the single execution path
**Decision:** SDD (with its own inline mode when `invoke_subagent` is absent) is the only execution methodology inside `/execute`; `executing-plans` is not the in-`/execute` fallback.
**Rationale:** Removes the two-different-fallbacks contradiction (Issue 2); SDD already platform-detects.

### D-003: `/verify` routes gap closure to `/plan {N} --gaps`
**Decision:** `/verify` records gaps and recommends `/plan {N} --gaps`; it no longer authors fix plans inline.
**Rationale:** Single owner of plan creation; checkbox format consistent with D-004 (audit H8).

### D-004: Plan format is markdown checkbox, not XML
**Decision:** Plans use `### Task N` + `- [ ]` steps with `Run:`/`Expected:`; XML `<task>` retained only for legacy gap plans and the task-type/effort vocabulary.
**Rationale:** Plans-are-prompts; `/execute` parses checkbox; the real plans on disk already used it (audit C2).

### D-005: Plans are one-task-per-file with descriptive slugs
**Decision:** `{N}.{M}-{plan-slug}-PLAN.md`; ordering via the `wave:` frontmatter field, not the filename. No A/B/C prefixes, no sub-numbers.
**Rationale:** Eliminates cross-plan edit collisions; conforms to the C1 naming convention.

### D-006: Phase 3.1 marked "Implemented — pending /verify", not "verified"
**Decision:** Status reflects that edits were applied by hand and statically verified, but `/execute`+`/verify` never ran.
**Rationale:** verification-before-completion — no completion/verified claim without a fresh run (Issue 8 remains open).

### D-007: Quantis treats the Superpowers fork as a hard fork
**Decision:** The forked Superpowers skills are Antigravity-adapted and Quantis-integrated; upstream updates will not be auto-synced.
**Rationale:** Deep divergence (tool names, `.quantis/` paths, wf-* layer, Phase 3.1 edits). Attribution preserved in GEMINI.md/ROADMAP.

### D-008: context-health-monitor Rule 4 routes to the context-engineering skills
**Decision:** When context volume is high, `context-health-monitor` invokes `context-compressor` + `token-budget` (compress first, `/pause` last resort).
**Rationale:** Those two skills were orphaned (reachable only by auto-trigger); the detector now explicitly calls the solvers.

