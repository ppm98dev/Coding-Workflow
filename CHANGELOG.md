# Changelog

All notable changes to Quantis.

## [3.4.1] — 2026-06-13

### Fixed
- **Parallel-dispatch rate limits (Phase 3.4)** — fan-out workflows (`/wf-stress-test`, `/wf-research-phase`, `/wf-map`, `/wf-debug-issue`) now dispatch in **waves of ≤3 concurrent** with 429-aware backoff (wait → retry once → inline), via a shared **"Concurrency Cap & Rate Limits"** contract in `dispatching-parallel-agents`. Fixes `429 "exhausted capacity"` failures when stress-testing (7-at-once burst). `≤3` is a validated, tunable default. (D-012)

## [3.4.0] — 2026-06-13

### 🔌 Subagent Skill-Wiring & Workflow Reliability

The central theme: a dispatched subagent is a fresh context that inherits none of the orchestrator's loaded skills, so every dispatch must hand the subagent its methodology skill by path. Plus the Phase 3.1 reliability remediation lands.

#### Added
- **Dispatch Contract (D-011)**: every subagent dispatch hands its methodology skill by path — `REQUIRED SUB-SKILL: Read and follow .agents/skills/<X>/SKILL.md` — never pasted skill text (documented in QUANTIS-STYLE).
- **`scripts/validate-dispatch.sh`** — enforces the contract (no bare dispatchers; allow-list with reasons); wired into `validate-all.sh`.
- **TDD wired into execution**: the SDD `implementer` and `executing-plans` now force-load `test-driven-development`; `spec-reviewer` → `verification-before-completion`; `code-quality-reviewer` → `requesting-code-review`.
- **Methodology handed to dispatched subagents** in `wf-stress-test`, `wf-research-phase`, `wf-debug-issue`, `wf-audit-milestone`; `wf-plan-milestone-gaps` → `writing-plans`; `wf-sprint` → SDD.

#### Changed
- **All skill commands prefixed `/wf-`** (e.g. `/wf-plan`, `/wf-execute`) — workflows now suggest the correct CLI command names.
- **Gather→Digest→Generate**: the plan-writer now reads the change's full *blast radius* (files it edits **and** what those connect to), not just edited files (D-010).
- `writing-plans` IDE fallback reconciled to D-002: `/wf-execute` always uses subagent-driven-development (self-selects real subagents or inline by platform); `executing-plans` is standalone/separate-session only.

#### Fixed
- **Phase 3.1 workflow reliability remediation** — full audit fix set across the discuss→plan→execute→verify core (STOP gates, unified phase-dir resolution, completion ownership, per-task verify gate).
- Removed a verbatim-paste anti-pattern in `wf-stress-test`'s fan-out dispatch.
- `validate-dispatch.sh` now ships via `install.sh` / `upgrade.sh` and is listed in `MANIFEST.md`.
- `install.sh` now **preserves an existing `CONSTITUTION.md`** on reinstall (no longer resets a filled one to the template).
- `/wf-update` script copy is now **MANIFEST-aware** — new validators (e.g. `validate-dispatch.sh`) ship automatically instead of being missed by a hardcoded list.

## [3.3.0] — 2026-06-11

### 🎉 CLI-First Migration

**BREAKING**: `.agent/workflows/` directory removed — all workflows now live in `.agents/skills/wf-*/SKILL.md`.

#### Added
- Platform compatibility matrix (IDE, CLI, Standalone) in `adapters/ANTIGRAVITY.md`
- Capability-based platform detection (no hardcoded platform names)
- Subagent dispatch for all major workflows: discuss-phase, plan, stress-test, execute, verify
- CLI quick start section in README
- `/wf-` prefix documentation in `/quantis-help`

#### Changed
- SDD is now the **default** execution path (CLI-first); IDE gets inline fallback
- `wf-execute`: deterministic SDD selection, no user menu
- `wf-verify`: `browser_subagent` graceful fallback when unavailable
- `wf-install`: updated paths for unified structure
- All root docs updated: PROJECT_RULES, QUANTIS-STYLE, MANIFEST, README
- Scripts updated: validate-workflows.sh, install.sh, upgrade.sh

#### Removed
- `.agent/workflows/` directory (workflows moved to `.agents/skills/wf-*/`)
- 30 `wf-*` symlinks replaced with real files

---

## [3.2.0] — 2026-05-24

### Added
- Dynamic ecosystem discovery in `/plan` — auto-detects custom skills and active MCP servers
- Context injection card printed before planning delegation
- `scripts/install.sh` — One-liner cURL install for macOS/Linux

### Changed
- `/install`, `/update`, `/upgrade` workflows now include `scripts/` and `docs/` directories
- VERSION bumped to 3.2.0
- MANIFEST updated to v3.2

## [3.1.0] — 2026-05-24

### Added
- Hierarchical subphase folders (e.g. `1.1-user-auth/` instead of flat `1/`)
- Dynamic subphase folder support in `/plan`, `/execute`, `/verify`, and 6 other workflows

### Changed
- Core workflows updated for descriptive folder naming convention
- Milestone archive structure updated

## [3.0.0] — 2026-05-24

### 🎉 Major Release: Superpowers Integration

Complete methodology overhaul powered by [obra/superpowers](https://github.com/obra/superpowers) v5.1.0.

#### Added
- 18 skills (13 from Superpowers + 5 Quantis context skills)
- Subagent-driven development (SDD) for Antigravity 2.0
- TDD, code review, systematic debugging skills
- Brainstorming skill (powers /discuss-phase, /stress-test, /research-phase)
- Writing-plans skill (powers /plan methodology)
- Executing-plans skill (powers /execute methodology)
- /upgrade workflow for GSD→v3.0 migration
- MANIFEST.md for safe, non-destructive updates
- Platform adapters (Antigravity, Gemini CLI, Claude, GPT/OSS)
- Full Antigravity 2.0 subagent support (invoke_subagent, define_subagent)

#### Changed
- Skills auto-trigger based on task context (no explicit invocation needed)
- /update is now MANIFEST-aware (preserves user-installed skills)
- /install updated for v3.0 package structure
- Skill-powered slash commands preserved as aliases (/plan, /execute, etc.)
- docs/ cleaned to user-relevant content only
- Brand renamed from GSD → Quantis

#### Removed
- Old core skills (planner, executor, verifier, debugger, context-fetch, empirical-validation, plan-checker)
- tests/ directory (Claude Code-specific, incompatible with Antigravity)
- docs/superpowers/ internal development docs

---

## [2.0.0] — 2026-05-01

### Breaking Changes
- **macOS/Linux only** — All PowerShell scripts and code blocks removed. Windows users should use v1.5.0.

### Added
- Antigravity adapter (`adapters/ANTIGRAVITY.md`)
- `scripts/install.sh` — One-command install for any project
- Real model profiles in `model_capabilities.yaml` — Gemini 2.5 Pro, Claude Opus 4, GPT-4.1
- `browser_subagent` guidance in `/verify` and `/execute` workflows
- Planning Mode integration in `.gemini/GEMINI.md`

### Changed
- All 5 skills converted from PowerShell to Bash
- 21 workflows stripped of PowerShell blocks (~396 lines removed)

### Removed
- 6 PowerShell scripts (`validate-*.ps1`, `setup_search.ps1`, `search_repo.ps1`)
- Dual-syntax documentation sections

---

## [1.5.0] — 2026-04-01

### Breaking Changes
- Skills moved from `.agent/skills/` to `.agents/skills/` — aligns with [Agent Skills open standard](https://agentskills.io/specification)
- SKILL.md `name` fields updated to lowercase-hyphenated names

### Added
- `/sprint` workflow — time-boxed sprints for quick focused work
- Test Quality Rules in `/plan`
- Discovery template reference (Level 1.5) in `/plan`
- Journal/decisions archival in `/complete-milestone`
- Architecture auto-refresh in `/complete-milestone`
- Requirements tracking across workflows

### Changed
- All references updated for `.agents/skills/` path
- Validation scripts updated to scan `.agents/skills/`

---

## [1.4.0] — 2026-01-17

### Added
- 8 new templates (22 total): architecture, decisions, journal, stack, phase-summary, sprint, todo, spec
- `validate-templates.ps1/.sh` — template validation scripts

---

## [1.3.0] — 2026-01-17

### Added
- Validation scripts: `validate-skills`, `validate-all`
- VERSION file — single source of truth for version
- `/help` displays current version

---

## [1.2.0] — 2026-01-17

### Added
- Cross-platform support — all 16 workflow files with Bash equivalents
- `/web-search` workflow

---

## [1.1.0] — 2026-01-17

### Added
- 14 templates aligned with original repository
- Examples directory with workflow walkthrough and quick reference
- `/add-todo`, `/check-todos`, `/whats-new` workflows

---

## [1.0.0] — 2026-01-17

### Added
- 21 core workflows (map, plan, execute, verify, debug, etc.)
- 8 skills (planner, executor, verifier, debugger, codebase-mapper, etc.)
- README, QUANTIS-STYLE, templates, GEMINI.md bootstrap
- Core rules: Planning Lock, State Persistence, Context Hygiene, Empirical Validation
