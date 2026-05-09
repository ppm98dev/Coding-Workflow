# Architecture

> Updated post-v2.0 milestone completion (2026-05-09)

## Overview

GSD (Get Shit Done) is a **meta-prompting framework** — a collection of markdown files that teach AI coding agents how to build software systematically. It is NOT executable software but rather a context engineering layer that sits inside any project and provides structured workflows via slash commands.

Adapted from [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done) (Claude Code-specific) for Google Antigravity (model-agnostic). **macOS/Linux only** (PowerShell removed in v2.0).

```
┌───────────────────────────────────────────────────────────────┐
│                          USER                                 │
│                    (Chat / Slash Commands)                     │
└────────────────────────┬──────────────────────────────────────┘
                         │
                         ▼
┌───────────────────────────────────────────────────────────────┐
│                    WORKFLOW LAYER                              │
│           .agent/workflows/ (27 commands)                     │
│  new-project → plan → execute → verify → complete-milestone   │
└──────────┬─────────────────────┬──────────────────────────────┘
           │                     │
           ▼                     ▼
┌─────────────────────┐ ┌───────────────────────────────────────┐
│    SKILLS LAYER     │ │          STATE LAYER                   │
│ .agents/skills/ (11)│ │  .gsd/ (SPEC, ROADMAP, STATE, etc.)   │
│  planner, executor, │ │  Templates (22), Examples (4)          │
│  verifier, debugger │ │  Phase directories & artifacts         │
└─────────────────────┘ └───────────────────────────────────────┘
           │                     │
           ▼                     ▼
┌───────────────────────────────────────────────────────────────┐
│                    ADAPTER LAYER                              │
│   adapters/ (ANTIGRAVITY.md, CLAUDE.md, GEMINI.md, GPT_OSS)  │
│   .gemini/GEMINI.md (entry point)                             │
│   model_capabilities.yaml (real model names)                  │
└───────────────────────────────────────────────────────────────┘
           │
           ▼
┌───────────────────────────────────────────────────────────────┐
│                  SUPPORT LAYER                                │
│   scripts/ (validation — Bash only, install.sh)               │
│   docs/ (runbook, model playbook, token guide)                │
│   PROJECT_RULES.md + GSD-STYLE.md (canonical rules)          │
└───────────────────────────────────────────────────────────────┘
```

## Components

### Workflow Layer (`.agent/workflows/`)
- **Purpose:** 27 slash commands that drive the development lifecycle
- **Location:** `.agent/workflows/*.md`
- **Key files:**
  - `new-project.md` — 10-phase project initialization with deep questioning
  - `plan.md` — Creates XML-structured PLAN.md files with wave grouping
  - `execute.md` — Wave-based parallel execution orchestrator
  - `verify.md` — Empirical verification with proof requirements
  - `map.md` — Codebase analysis (this output)
  - `debug.md` — 3-strike systematic debugging
  - `sprint.md` — Time-boxed sprint management
  - `pause.md` / `resume.md` — Session persistence
- **Total size:** ~100KB across 27 files

### Skills Layer (`.agents/skills/`)
- **Purpose:** 11 specialized agent behaviors that workflows reference
- **Location:** `.agents/skills/*/SKILL.md`
- **Key skills:**
  - `planner` (12.7KB) — Goal-backward planning, task anatomy, wave grouping
  - `executor` (11KB) — Atomic commits, deviation rules, checkpoint protocol
  - `verifier` (10KB) — Must-haves extraction, evidence requirements
  - `debugger` (7.2KB) — 3-strike rule, systematic diagnosis
  - `plan-checker` (6.3KB) — Pre-execution plan validation
  - `codebase-mapper` (4.5KB) — Structure analysis
  - Context skills: `context-compressor`, `context-fetch`, `context-health-monitor`, `token-budget`
  - `empirical-validation` (2.5KB) — Proof requirements
- **Note:** Skills currently have basic SKILL.md only — no scripts/, references/, or assets/ (upgrade planned for v2.1 Phase 4)

### State Layer (`.gsd/`)
- **Purpose:** Project state, templates, and examples (populated per-project)
- **Location:** `.gsd/`
- **Templates (22):** PLAN, SUMMARY, VERIFICATION, DEBUG, UAT, architecture, spec, roadmap, state, decisions, journal, todo, sprint, milestone, phase-summary, requirements, discovery, context, stack, state_snapshot, token_report, user-setup, project
- **Examples (4):** workflow-example, quick-reference, cross-platform, multi-wave-workflow
- **Milestones archive:** `.gsd/milestones/` — completed milestone artifacts

### Adapter Layer (`adapters/`)
- **Purpose:** Optional model-specific enhancements (never required)
- **Location:** `adapters/*.md` + `.gemini/GEMINI.md`
- **Files:**
  - `ANTIGRAVITY.md` — Comprehensive Antigravity tool mapping (browser_subagent, run_command, generate_image, persistent context, knowledge items)
  - `CLAUDE.md` — Extended thinking, effort levels, artifacts mode
  - `GEMINI.md` — Flash vs Pro selection, context tips
  - `GPT_OSS.md` — Function calling, context handling
  - `.gemini/GEMINI.md` — Gemini CLI entry point (redirects to PROJECT_RULES.md)
- **model_capabilities.yaml** — Real model names (Claude Opus 4, Gemini 2.5 Pro, GPT-4.1)

### Support Layer
- **Scripts** (`scripts/`): 6 Bash scripts (PowerShell removed in v2.0)
  - `validate-all.sh`, `validate-workflows.sh`, `validate-skills.sh`, `validate-templates.sh`
  - `setup_search.sh`, `search_repo.sh`
  - `install.sh` — One-command install for macOS/Linux
- **Docs** (`docs/`): model-selection-playbook, runbook, token-optimization-guide
- **Rules:** `PROJECT_RULES.md` (canonical, 260 lines), `GSD-STYLE.md` (conventions, 272 lines)

## Data Flow

1. **User invokes** slash command (e.g., `/plan 1`)
2. **Workflow loads** from `.agent/workflows/plan.md`
3. **Workflow reads** state from `.gsd/` (SPEC, ROADMAP, STATE)
4. **Workflow invokes** skills from `.agents/skills/` as needed
5. **Workflow writes** outputs back to `.gsd/` (PLAN.md, STATE.md updates)
6. **Workflow commits** changes via git with conventional commit format
7. **Workflow routes** user to next step

## Technical Debt (post-v2.0)

- [x] ~~No Antigravity adapter~~ — `adapters/ANTIGRAVITY.md` created (v2.0 Phase 1)
- [x] ~~PowerShell-first bias~~ — PowerShell fully removed (v2.0 Phase 2)
- [x] ~~Stale upstream attribution~~ — Updated to `gsd-build/get-shit-done` (v2.0 Phase 3)
- [x] ~~README command count incorrect~~ — Fixed (v2.0 Phase 3)
- [x] ~~model_capabilities.yaml generic~~ — Real model names added (v2.0 Phase 1)
- [x] ~~Templates orphaned~~ — All cross-referenced (v2.0 Phase 3)
- [ ] **No executable CLI** — Everything is markdown prompts, no actual executable tool
- [ ] **No test infrastructure** — Validation scripts check file existence only
- [ ] **Token optimization is theoretical** — No measurement mechanism exists
- [ ] **Skills are primitive** — SKILL.md only, no scripts/references/assets (v2.1 Phase 4)
- [ ] **No production code enforcement** — Agent writes "it works" code (v2.1 Phase 3)
- [ ] **No spec quality gate** — Specs can be finalized while ambiguous (v2.1 Phase 1)
- [ ] **Single-user only** — No multi-user state management (v2.1 Phase 6)

## Conventions

**Naming:** Workflows use kebab-case (`add-phase.md`), skills use kebab-case folders (`context-compressor/`), templates use mixed case
**Structure:** Workflows use XML semantic containers (`<role>`, `<objective>`, `<process>`), skills use YAML frontmatter
**Testing:** Validation scripts only (no unit/integration tests)
**Commits:** `type(scope): description` — one task per commit
**Platform:** macOS/Linux only (Bash). No Windows/PowerShell support.
