# DECISIONS.md — Architecture Decision Records

> Decisions made during v2.0 development.

## ADR-001: Bash-First Platform Strategy
**Date:** 2026-04-30
**Status:** Accepted
**Context:** Original GSD shows PowerShell examples first (55.4% PowerShell). Primary user is on macOS.
**Decision:** Reorder all examples to Bash-first, PowerShell-second. macOS/Linux is primary target.
**Consequence:** Better DX for macOS/Linux users. Windows users still supported via secondary examples.

## ADR-002: No CLI Tool in v2.0
**Date:** 2026-04-30
**Status:** Accepted
**Context:** A real CLI would add significant value but also complexity and runtime dependencies.
**Decision:** Defer CLI tool to future milestone. Keep v2.0 as pure markdown framework.
**Consequence:** Faster delivery. Markdown-only approach maintained. CLI can build on v2.0 foundations.

## ADR-003: Real Model Names in Capabilities
**Date:** 2026-04-30
**Status:** Accepted
**Context:** `model_capabilities.yaml` uses generic profiles ("Flash/Turbo variants"). Not actionable.
**Decision:** Keep category profiles but add real model names as examples in comments. Category + examples pattern stays useful longer than hardcoded names.
**Consequence:** More useful guidance without going stale quickly.

## ADR-004: Phase 1 Scope — Deep Adapter + Workflow Patches
**Date:** 2026-04-30
**Status:** Accepted
**Context:** Three options considered: (A) lightweight adapter, (B) deep adapter, (C) deep adapter + workflow patches.
**Decision:** Option C — Create a comprehensive `adapters/ANTIGRAVITY.md` (~200 lines) AND modify key workflows (`execute.md`, `verify.md`) to reference Antigravity tools natively.
**Consequence:** GSD feels Antigravity-native, not just documented. More work in Phase 1 but better end result.

## ADR-005: GSD Replaces Antigravity Planning Mode
**Date:** 2026-04-30
**Status:** Accepted
**Context:** Antigravity has built-in planning artifacts (implementation_plan, task, walkthrough) that overlap with GSD's PLAN.md, wave tasks, and SUMMARY.md.
**Decision:** GSD replaces Antigravity's planning mode entirely. Use only GSD's system (SPEC→PLAN→EXECUTE→VERIFY). Ignore Antigravity's planning artifacts.
**Consequence:** Clean single system, no confusion about which artifacts to use. Loses some Antigravity UI integration but gains methodology consistency.

## ADR-006: STATE.md Stays as Primary Memory
**Date:** 2026-04-30
**Status:** Accepted
**Context:** Antigravity has Knowledge Items (KIs) for persistent cross-conversation memory. Could replace or supplement STATE.md.
**Decision:** Keep STATE.md as the canonical session memory. No KI integration in v2.0. `/pause` and `/resume` workflows stay unchanged.
**Consequence:** Simpler, portable across agents. KI integration can be explored in future milestones.

## ADR-007: A/B Testing via Dogfooding
**Date:** 2026-04-30
**Status:** Accepted
**Context:** Need to verify that v2.0 improvements actually improve workflow quality.
**Decision:** Use self-validation (dogfooding). Phase 1-2 built with GSD v1.5, Phase 3-4 built with improved v2.0 workflows. Track metrics per phase in JOURNAL.md (debug cycles, verification passes, time spent).
**Consequence:** Built-in quality signal. No separate test project needed. Add metrics tracking to JOURNAL.md template.
