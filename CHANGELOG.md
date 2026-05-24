# Changelog

All notable changes to Quantis.

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
