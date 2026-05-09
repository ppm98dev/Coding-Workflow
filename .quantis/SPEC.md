# SPEC.md — Project Specification

> **Status**: `FINALIZED`

## Vision
Transform GSD-for-Antigravity from a shallow port of the Claude Code-specific GSD framework into a genuinely useful, Antigravity-native coding workflow system. Make it Bash-first (macOS/Linux primary), create a real Antigravity adapter that leverages the platform's unique capabilities (browser subagents, persistent context, image generation), fix all documented issues, and optionally create a real CLI tool.

## Goals
1. **Antigravity-native integration** — Create a proper adapter and entry point for Antigravity's toolset (browser_subagent, run_command, generate_image, persistent terminals, knowledge items)
2. **Bash-first rewrite** — Make macOS/Linux the primary platform, PowerShell secondary
3. **Fix core issues** — Accurate README, proper CHANGELOG versioning, updated attribution, actionable model_capabilities.yaml
4. **Add real install automation** — Shell script that handles the entire setup, not 10+ manual `cp` commands
5. **Improve workflow quality** — Fix orphaned templates, add missing cross-references, ensure all 27 workflows are discoverable

## Non-Goals (Out of Scope)
- Building a full CLI tool (Phase 3 from audit — deferred to future milestone)
- CI/GitHub Actions integration (future work)
- Visual dashboard (future work)
- Multi-agent orchestration (future work)
- Cost tracking per phase (future work)

## Users
Solo developers using Google Antigravity (or compatible AI coding agents) who want structured, reliable AI-assisted development instead of "vibecoding."

## Constraints
- Must remain MIT licensed
- Must stay backward-compatible with original GSD workflows
- Must remain model-agnostic (adapters are optional, never required)
- Must work on macOS (primary platform)
- No runtime dependencies — stays as a pure markdown framework

## Success Criteria
- [ ] Antigravity adapter exists and covers all major Antigravity tools
- [ ] All scripts run on macOS without modification (Bash-first)
- [ ] README accurately reflects actual command count and features
- [ ] Install script works end-to-end in a single command
- [ ] All 22 templates are referenced by at least one workflow
- [ ] model_capabilities.yaml references real, current models
- [ ] CHANGELOG has proper version headers
- [ ] Attribution links are current and correct
