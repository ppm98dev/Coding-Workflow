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
**Decision:** Reference actual models (Claude Opus 4, Gemini 2.5 Pro, GPT-4.1) while keeping model-agnostic principles.
**Consequence:** More useful guidance. Needs periodic updates as models change.
