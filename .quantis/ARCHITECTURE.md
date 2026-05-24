# Architecture

> Updated post-v3.2 milestone completion (2026-05-24)

## Overview

Quantis is a **meta-prompting framework** — a collection of markdown files that teach AI coding agents how to build software systematically. It is NOT executable software but rather a context engineering layer that sits inside any project and provides structured workflows via slash commands.

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
│           .agent/workflows/ (30 commands)                     │
│  new-project → plan → execute → verify → complete-milestone   │
└──────────┬─────────────────────┬──────────────────────────────┘
           │                     │
           ▼                     ▼
┌─────────────────────┐ ┌───────────────────────────────────────┐
│    SKILLS LAYER     │ │          STATE LAYER                   │
│ .agents/skills/ (18)│ │  .quantis/ (SPEC, ROADMAP, STATE, etc.)   │
│  brainstorming,     │ │  Templates (25), Examples (4)          │
│  writing-plans,     │ │  Phase directories & artifacts         │
│  executing-plans,SDD│ │  (in hierarchical subphase folders)   │
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
│   PROJECT_RULES.md + QUANTIS-STYLE.md (canonical rules)          │
└───────────────────────────────────────────────────────────────┘
```

## Components

### Workflow Layer (`.agent/workflows/`)
- **Purpose:** 30 slash commands that drive the development lifecycle
- **Location:** `.agent/workflows/*.md`
- **Key files:**
  - `new-project.md` — 10-phase project initialization with deep questioning
  - `plan.md` — Discovers active MCP tools and custom skills dynamically (from skills.sh), prints a high-visibility ecosystem discovery card, and generates execution plans inside dynamic hierarchical phase folders
  - `execute.md` — Dynamic subphase directory resolution and plan execution
  - `verify.md` — Empirical verification with prefix-based resolution
  - `map.md` — Codebase analysis (this output)
  - `debug.md` — 3-strike systematic debugging
  - `sprint.md` — Time-boxed sprint management
  - `pause.md` / `resume.md` — Session persistence
- **Total size:** ~120KB across 30 files

### Skills Layer (`.agents/skills/`)
- **Purpose:** 18 specialized agent behaviors that workflows reference
- **Location:** `.agents/skills/*/SKILL.md`
- **Key skills:**
  - `brainstorming` — Collaborative specification and design (Phase SPEC.md)
  - `writing-plans` — Goal-backward planning with aggressive wave-based atomicity
  - `executing-plans` — Inline wave-based plan execution
  - `subagent-driven-development` — Coordination of specialized subagents
  - `verification-before-completion` — Empirical verification of must-haves
  - `systematic-debugging` — 3-strike rule and state isolation
  - `using-quantis` — Entry point bootstrap skill
  - `using-git-worktrees` — Isolated git workspaces
  - `requesting-code-review` / `receiving-code-review` — Feedback loops
  - Context skills: `codebase-mapper`, `context-health-monitor`, `context-compressor`, `token-budget`

### State Layer (`.quantis/`)
- **Purpose:** Project state, templates, and examples (populated per-project)
- **Location:** `.quantis/`
- **Templates (25):** PLAN, SUMMARY, VERIFICATION, DEBUG, UAT, architecture, spec, roadmap, state, decisions, journal, todo, sprint, milestone, phase-summary, requirements, discovery, context, stack, state_snapshot, token_report, user-setup, project
- **Examples (4):** workflow-example, quick-reference, cross-platform, multi-wave-workflow
- **Milestones archive:** `.quantis/milestones/` — completed milestone artifacts
- **Phase folders:** `.quantis/phases/{N}.{M}-{slug}/` — descriptive subphase directories (e.g. `1.1-hierarchical-folders`) containing SPEC.md, PLANS.md, summaries, and verification reports.

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
- **Scripts** (`scripts/`): 7 Bash scripts
  - `validate-all.sh`, `validate-workflows.sh`, `validate-skills.sh`, `validate-templates.sh`
  - `setup_search.sh`, `search_repo.sh`
  - `install.sh` — One-command cURL install for macOS/Linux
- **Docs** (`docs/`): model-selection-playbook, runbook, token-optimization-guide
- **Rules:** `PROJECT_RULES.md` (canonical, 260 lines), `QUANTIS-STYLE.md` (conventions, 272 lines)

## Data Flow

1. **User invokes** slash command (e.g., `/plan 1.1`)
2. **Workflow loads** from `.agent/workflows/plan.md`
3. **Workflow reads** state from `.quantis/` (SPEC, ROADMAP, STATE)
4. **Workflow resolves** descriptive subphase directory (e.g. `.quantis/phases/1.1-hierarchical-folders/`)
5. **Workflow invokes** skills from `.agents/skills/` as needed
6. **Workflow writes** outputs back to `.quantis/phases/{N}.{M}-{slug}/`
7. **Workflow commits** changes via git with conventional commit format
8. **Workflow routes** user to next step

## Technical Debt (post-v3.1)

- [x] ~~No Antigravity adapter~~ — `adapters/ANTIGRAVITY.md` created (v2.0 Phase 1)
- [x] ~~PowerShell-first bias~~ — PowerShell fully removed (v2.0 Phase 2)
- [x] ~~Stale upstream attribution~~ — Updated to `gsd-build/get-shit-done` (v2.0 Phase 3)
- [x] ~~README command count incorrect~~ — Fixed (v2.0 Phase 3)
- [x] ~~model_capabilities.yaml generic~~ — Real model names added (v2.0 Phase 1)
- [x] ~~Templates orphaned~~ — All cross-referenced (v2.0 Phase 3)
- [x] ~~Primitive GSD Skills~~ — Upgraded to Superpowers skills (v3.0 Phase 1)
- [x] ~~Hardcoded phases/N paths~~ — Migrated to dynamic hierarchical subphase folders (v3.1 Phase 1.1)
- [ ] **No executable CLI** — Everything is markdown prompts, no actual executable tool
- [ ] **No test infrastructure** — Validation scripts check file existence only
- [ ] **Token optimization is theoretical** — No measurement mechanism exists
- [ ] **Single-user only** — No multi-user state management (v2.1 Phase 6)

## Conventions

**Naming:** Workflows use kebab-case (`add-phase.md`), skills use kebab-case folders (`context-compressor/`), templates use mixed case
**Structure:** Workflows use XML semantic containers (`<role>`, `<objective>`, `<process>`), skills use YAML frontmatter
**Testing:** Validation scripts only (no unit/integration tests)
**Commits:** `type(scope): description` — one task per commit
**Platform:** macOS/Linux only (Bash). No Windows/PowerShell support.
