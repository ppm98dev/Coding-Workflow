# Quantis

> Spec-driven development methodology for AI coding agents.

Quantis turns AI-assisted coding from "vibecoding" into a structured, repeatable process. It gives your AI agent persistent memory across sessions, battle-tested code quality skills, and project management workflows.

**Core workflow:** Spec → Plan → Execute → Verify → Commit

## Quick Start

### 1. Install

Run this single-line command in your target project directory to download and set up Quantis dynamically:

```bash
curl -sSL https://raw.githubusercontent.com/ppm98dev/Coding-Workflow/main/scripts/install.sh | bash
```

### 2. Initialize

Tell your AI agent:
```
/new-project    → Deep questioning to create SPEC.md
/plan 1         → Create execution plans for Phase 1
/execute 1      → Implement Phase 1
/verify 1       → Prove it works with evidence
```

> **Already installed?** Use `/install` to reinstall, `/update` for incremental updates, or `/upgrade` to migrate from GSD v2.x.

## Architecture

Quantis has three layers:

### Skills (18) — The Methodology Engine

Auto-triggered skills that fire based on task context. Powered by [obra/superpowers](https://github.com/obra/superpowers) v5.1.0.

| Category | Skills | Purpose |
|----------|--------|---------|
| **Code Quality** | subagent-driven-development, test-driven-development, receiving-code-review, requesting-code-review | Build code right |
| **Planning** | brainstorming, writing-plans, executing-plans | Think before building |
| **Debugging** | systematic-debugging, verification-before-completion | Fix and prove |
| **Context** | codebase-mapper, context-compressor, context-health-monitor, token-budget | Stay efficient |
| **Git** | using-git-worktrees, finishing-a-development-branch | Clean version control |
| **Meta** | writing-skills, dispatching-parallel-agents, using-quantis | Extend the system |

### Workflows (30) — Project Management

Slash commands for project orchestration. Skills handle methodology; workflows handle process.

> **Ecosystem Discovery:** `/plan` automatically detects custom skills (from [skills.sh](https://www.skills.sh)) and active MCP servers, injecting them into the planning context so your agent leverages your full toolkit.

**Core Lifecycle**

| Command | Purpose |
|---------|---------|
| `/new-project` | Initialize with deep questioning → SPEC.md |
| `/plan [N]` | Decompose requirements into executable phase plans |
| `/execute [N]` | Execute a phase with focused context |
| `/verify [N]` | Validate work against spec with empirical evidence |
| `/debug` | Systematic debugging with persistent state |
| `/complete-milestone` | Archive milestone and prepare for next |

**Planning & Research**

| Command | Purpose |
|---------|---------|
| `/discuss-phase` | Clarify scope and approach before planning |
| `/research-phase` | Deep technical research for a phase |
| `/stress-test` | Adversarial spec review — find ambiguity and gaps |
| `/update-plan` | Revise plans based on discussion |
| `/plan-milestone-gaps` | Create plans to address gaps found in audit |
| `/list-phase-assumptions` | List assumptions made during planning |

**Roadmap Management**

| Command | Purpose |
|---------|---------|
| `/new-milestone` | Create a new milestone with phases |
| `/add-phase` | Add a phase to the end of the roadmap |
| `/insert-phase` | Insert a phase between existing phases |
| `/remove-phase` | Remove a phase (with safety checks) |
| `/audit-milestone` | Audit a milestone for quality and completeness |

**Session & State**

| Command | Purpose |
|---------|---------|
| `/pause` | Dump state for clean session handoff |
| `/resume` | Restore context from previous session |
| `/progress` | Show current position in roadmap |
| `/map` | Analyze codebase → ARCHITECTURE.md + STACK.md |
| `/sprint` | Time-boxed sprint for quick focused work |
| `/add-todo` / `/check-todos` | Task capture and review |

**Package Management**

| Command | Purpose |
|---------|---------|
| `/install` | Install Quantis from GitHub |
| `/update` | Update to latest version |
| `/upgrade` | Migrate from GSD v2.x → Quantis |
| `/whats-new` | Show recent changes and features |
| `/web-search` | Search the web to inform decisions |
| `/help` | Show all available commands |

### State (`.quantis/`) — Persistent Memory

Project state that survives across sessions:

| File | Purpose |
|------|---------|
| `SPEC.md` | Requirements (must be FINALIZED before coding) |
| `ROADMAP.md` | Phases, milestones, progress tracking |
| `STATE.md` | Current position, session handoffs |
| `JOURNAL.md` | Session logs, decisions, handoff notes |
| `DECISIONS.md` | Architectural and design decisions |
| `phases/` | Isolated, descriptive subphase folders (e.g. `1.1-user-auth/`) containing specs, plans, and reports |

## Core Rules

| Rule | What It Means |
|------|--------------|
| 🔒 **Planning Lock** | No code until SPEC.md is FINALIZED |
| 💾 **State Persistence** | Update STATE.md after every task |
| 🧹 **Context Hygiene** | 3 failures → state dump → fresh session |
| ✅ **Empirical Validation** | Proof required, not "trust me, it works" |

## Platform Support

| Platform | Command Prefix | Subagents | Browser |
|----------|---------------|:---------:|:-------:|
| **Antigravity IDE** | `/command` | ❌ inline | ✅ `browser_subagent` |
| **Antigravity CLI** (`agy`) | `/wf-command` | ✅ `invoke_subagent` | ❌ |
| **Standalone** (Antigravity 2.0) | `/command` | ✅ `invoke_subagent` | ✅ `/browser` |

All workflows and skills live in `.agents/skills/`. No platform-specific setup needed after install.

### CLI Quick Start (`agy`)

```bash
agy                           # Start Antigravity CLI
/wf-new-project              # Initialize with deep questioning
/wf-plan 1                   # Create Phase 1 plans
/wf-execute 1                # Execute (uses real subagents!)
/wf-verify 1                 # Verify implementation
```

## File Structure

```
.agents/
├── skills/       30 workflow commands (wf-*) + 18 auto-triggered skills
└── rules/        PROJECT_RULES.md, CONSTITUTION.md, QUANTIS-STYLE.md
.gemini/              Platform bootstrap
.quantis/             Project state + 25 templates
adapters/             Platform-specific guidance
docs/                 Runbook, model playbook, token guide
scripts/              Validation scripts + one-liner installer

CHANGELOG.md          Release history
LICENSE               MIT license
MANIFEST.md           Core file listing (for safe updates)
VERSION               Current version number
```

## Credits

- **Skills engine:** [obra/superpowers](https://github.com/obra/superpowers) v5.1.0 — Battle-tested code quality skills (TDD, SDD, code review, debugging)
- **Methodology & orchestration:** Quantis — Project management, state persistence, workflow layer
- **Platform:** [Google Antigravity](https://blog.google/technology/google-deepmind/antigravity/) — AI coding IDE

## License

MIT
