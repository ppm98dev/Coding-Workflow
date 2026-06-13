## Current Position
- **Phase**: 3.4 (Parallel-Dispatch Concurrency Cap & Rate Limits) ✅ Complete (2026-06-13)
- **Task**: Fixed the `/wf-stress-test` `429` rate-limit failures — all fan-out workflows now cap at **≤3 concurrent (waves)** + 429 wait-then-inline, via one shared `dispatching-parallel-agents` contract. Empirically validated (≤3 doesn't crash on the user's agy tier). See `.quantis/phases/3.4-dispatch-concurrency-cap/`. D-012 recorded.
- **Status**: ✅ Complete. Phase 3.3 also ✅ verified (PASS). Next: commit + push the Phase 3.4 fix as **v3.4.1** (v3.4.0 already released; VERSION + CHANGELOG bumped).
- **Prior**: Phase 3.1 (Workflow Reliability Fixes) 🔄 Implemented — still pending its end-to-end `/verify` run (separate deliverable).

## Last Session Summary

Audited the whole Quantis workflow system, then remediated every finding — nothing deferred.

1. **Audit** (8 known issues + 8 systematic dimensions, adversarially verified) → `claude-audit-report.md` + `claude-audit-findings-raw.md` in the phase dir
2. **Core fix set** (C1–C8, H1–H12, all Medium/Low, Issue 5): 150 edits across 32 core files, reconciled into **5 file-organized plans** (one task per file), applied deterministically + independently reviewed
3. **Untouched-set sweep**: 35 edits across 17 workflows/adapters/docs/scripts the audit never covered (phase-mgmt resolution + STOP gates, `/debug`→`/debug-issue`, stale command maps)
4. **Superpowers integration** reconciled (terminal-state conflicts, phantom modes, upstream dead-refs); fork is complete (all 14 upstream skills) but now divergent from upstream
5. **Context-skill island closed**: `context-health-monitor` Rule 4 now routes to `context-compressor` + `token-budget`
6. **Self-state + scripts**: ROADMAP 3.1 status corrected, install/upgrade `docs` residue removed

### Key Discoveries
- The "intermittent" failures were deterministic written contradictions (two competing state machines: wf-* orchestration vs forked Superpowers skills)
- `/execute 3.1` previously found 0 plans (glob mismatch) → would mark the phase Complete without executing — now finds all 5 (mechanically verified)
- Everything is **statically** verified (validators pass, anchors match, simulation clean) but has **never been run** end-to-end

## In-Progress Work
~22 files modified in the working tree, **uncommitted** (per user instruction): 17 sweep files + 2 scripts + ROADMAP + STATE + context-skill wiring. Core 32-file fix set + 5 plans already committed (`e469ed0`, `1a2d9ac`).

## Blockers
None — but Phase 3.1 cannot be marked **verified** until `/verify` runs.

## Context Dump

### Decisions Made
Recorded as D-001…D-012 in `.quantis/DECISIONS.md` (D-001–D-008 Phase 3.1 scope/fallback/format; D-009 subagent-dispatch correction; D-010 blast-radius gather; D-011 dispatch contract; D-012 ≤3 concurrency cap + 429 backoff).

### Repository Structure (Current)
```
.agents/skills/   30 wf-* workflows + 18 methodology skills (all audited or swept)
.agents/rules/    PROJECT_RULES, CONSTITUTION, QUANTIS-STYLE
.quantis/         state + 25 templates + phases/3.1-* (SPEC, 5 plans, audit reports)
adapters/         ANTIGRAVITY.md   scripts/  install/upgrade/validate
```

## Next Steps
1. **End-to-end `/verify` run** — drive `discuss→plan→execute→verify` on a real/sandbox project; the only behavioral gap (tracked in ROADMAP Phase 3.1 + 3.3)
2. **Commit** the working-tree changes (or revert) — user reviewing first
3. **Optional**: whole-system coherence read; methodology-fidelity diff vs upstream Superpowers
4. **Watch for over-instrumentation** on the first real run — trim gates/dispatch that add friction without compliance
