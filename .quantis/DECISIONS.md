# Decisions

> Previous milestone decisions archived in `.quantis/milestones/v3.2/DECISIONS.md`

---

### D-010: Plan-writer reads the change's full blast radius, not just edited files (gather-digest refinement)
**Decision:** Refine the **Gather → Digest → Generate** rule so the plan-writer reads **in full** the SPEC **plus every file in the change's *blast radius*** — the files it edits *and* everything those connect to (callers, dependents, shared config/contracts, anything its behavior could ripple into) — never a ≤400-word digest *of those*. The "don't re-read the pile" prohibition now scopes to **genuinely-unrelated** files only (surveyed but neither touched nor affected). Mapping the blast radius is made an explicit job of the **Gather** step, so the writer knows which connected files to read fully.
**Rationale:** A plan's correctness lives in exact detail (signatures, line numbers, literal config values) *and* in downstream implications — a lossy summary carries neither. The prior wording ("inject the brief + a PATH to the one source [SPEC]; don't hand the writer the pile"), read literally, would have the writer plan a change from a 400-word digest of the very files it's changing — the mechanism behind plan↔code mismatches (e.g. the 5.5 review's F-03: digest-level "use the domain" vs. the real "it's the IP"). Empirically the 5.5 `/wf-plan` run already did the *right* thing despite the rule — it read `routes.py` (edited) **and** `settings.yaml`/`app.py`/`.env` (connected: CORS values, settings flow, env format) inline before writing — and produced a sound plan. This aligns the written rule with that proven behavior. Principle: **not-lazy, not-starved — read everything the change touches *or reaches*; summarize only what it cannot affect.**
**Files:** `.agents/rules/QUANTIS-STYLE.md` (Gather→Digest→Generate — gather, digest, anti-pattern; 3 edits), `.agents/skills/wf-plan/SKILL.md` (Subagent Planning inputs + writer-inputs list; 2 edits).
**Relationship to D-009:** Complements it. D-009 fixed *who* writes (lean subagent / inline, never `self`) and *how* (paths, incremental). D-010 fixes *what the writer must read* (the full blast radius), so "paths-not-paste" is never misread as "summaries-not-files" for the change-critical set.

---

### D-009: Subagent dispatch corrected — analysis→`research`+paths, generation→inline (post-forensics)
**Decision:** Reverse the H11 "MUST dispatch a `self` subagent + paste all content" pattern. (a) **Generation** (writing PLAN/SPEC/VERIFICATION files) → dispatch to a **LEAN subagent** (minimal/templated `define_subagent`, never a raw `self` clone) given **paths**, and **write the file INCREMENTALLY**; inline (still incremental) only as fallback. (b) **Analysis/read** → lightweight **`research`** subagents given **paths**, not paste. (c) Blanket "MUST dispatch / never inline" softens to "dispatch (lean) is the default; inline fallback if it stalls."
**Rationale:** `subagent_failure_forensics.md` (filed in this phase dir) — a real run — shows `self` subagents told to write a file failed 3/3: a `self` inherits the full parent config (~60 skills + rules) and, with a large pasted payload on top, stalls before emitting any tool call; `research` subagents (light, paths, small calls) succeeded 2/2. Antigravity's documented design also intends subagents to take a clean isolated window and read what they need (paths), not pasted dumps. No published context limit exists, so the fix is principle-based + always-has-an-inline-fallback, not number-based. This partially reverses the H11 edits applied earlier the same day — the empirical loop catching over-instrumentation, as predicted.
**Real root cause (confirmed against `5.5-origin-resolution-PLAN.md` + the forensics):** the `self` clone's massive **INPUT** context — ~148–157 KB of inherited system prompt + 60 skills + rules + paste — stalled the model before it emitted any write. Proof: that plan (~5,600 output tokens, **well under** the 16,384/turn cap) was written successfully **inline** once the `self` attempts were abandoned. So the load-bearing fix is **"lean subagent or inline, never `self`" + paths-not-paste**; the 16,384/turn output cap is real (research wb9ocq3jb) but was NOT the binding cause here — incremental writing is insurance for genuinely huge files, not the primary fix. A lean `define_subagent` (TemplatedSystemInstructions) can be made clean, unlike `self`.

**Caveat:** Defensible, not verified — based on one forensic run + documented design intent. A clean isolated test would be biased (strips the loaded-session conditions that caused the failure); real verification is observing actual runs over time.


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

