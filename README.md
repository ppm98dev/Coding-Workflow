# Quantis

> Spec-driven development methodology for AI coding agents.

Quantis turns AI-assisted coding from "vibecoding" into a structured, repeatable process. It gives your AI agent persistent memory across sessions, battle-tested code quality skills, and project management workflows.

**Core workflow:** Spec → Plan → Execute → Verify → Commit

## Quick Start

### 1. Install

```bash
# In your project directory:
git clone --depth 1 https://github.com/ppm98dev/Coding-Workflow.git .quantis-tmp && \
  cp -r .quantis-tmp/.agent .quantis-tmp/.agents .quantis-tmp/.gemini .quantis-tmp/.quantis .quantis-tmp/adapters .quantis-tmp/docs . && \
  cp .quantis-tmp/CONSTITUTION.md .quantis-tmp/MANIFEST.md .quantis-tmp/PROJECT_RULES.md .quantis-tmp/QUANTIS-STYLE.md .quantis-tmp/CHANGELOG.md .quantis-tmp/VERSION .quantis-tmp/model_capabilities.yaml . && \
  rm -rf .quantis-tmp
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

| Command | Purpose |
|---------|---------|
| `/new-project` | Initialize with deep questioning → SPEC.md |
| `/plan [N]` | Create phase execution plans |
| `/execute [N]` | Wave-based plan execution |
| `/verify [N]` | Empirical validation of work |
| `/debug` | Systematic debugging with state tracking |
| `/pause` / `/resume` | Session state management |
| `/progress` | See current position in roadmap |
| `/map` | Analyze codebase → ARCHITECTURE.md |
| `/discuss-phase` | Clarify scope before planning |
| `/stress-test` | Adversarial spec review |
| `/install` / `/update` / `/upgrade` | Package management |
| `/help` | Full command listing |

### State (`.quantis/`) — Persistent Memory

Project state that survives across sessions:

| File | Purpose |
|------|---------|
| `SPEC.md` | Requirements (must be FINALIZED before coding) |
| `ROADMAP.md` | Phases, milestones, progress tracking |
| `STATE.md` | Current position, session handoffs |
| `JOURNAL.md` | Session logs, decisions, handoff notes |
| `DECISIONS.md` | Architectural and design decisions |
| `phases/` | Phase plans, summaries, research |

## Core Rules

| Rule | What It Means |
|------|--------------|
| 🔒 **Planning Lock** | No code until SPEC.md is FINALIZED |
| 💾 **State Persistence** | Update STATE.md after every task |
| 🧹 **Context Hygiene** | 3 failures → state dump → fresh session |
| ✅ **Empirical Validation** | Proof required, not "trust me, it works" |

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| **Google Antigravity** | Primary | Native skill auto-discovery, subagent support |
| Gemini CLI | Adapter | Via `.gemini/GEMINI.md` + adapters |
| Claude | Adapter | Via `adapters/CLAUDE.md` |
| GPT / OSS | Adapter | Via `adapters/GPT_OSS.md` |

Skills are platform-agnostic. Adapters handle tool name mapping per platform.

## File Structure

```
.agent/workflows/     30 slash command workflows
.agents/skills/       18 auto-triggered skills
.gemini/              Platform bootstrap
.quantis/             Project state + 25 templates
adapters/             Platform-specific guidance
docs/                 Platform-specific guides (OpenCode, Windows)

CHANGELOG.md          Release history
CONSTITUTION.md       Project quality standards
LICENSE               MIT license
MANIFEST.md           Core file listing (for safe updates)
model_capabilities.yaml  Model capability matrix
PROJECT_RULES.md      Canonical methodology rules
QUANTIS-STYLE.md      Style and conventions
VERSION               Current version number
```

## Credits

- **Skills engine:** [obra/superpowers](https://github.com/obra/superpowers) v5.1.0 — Battle-tested code quality skills (TDD, SDD, code review, debugging)
- **Methodology & orchestration:** Quantis — Project management, state persistence, workflow layer
- **Platform:** [Google Antigravity](https://blog.google/technology/google-deepmind/antigravity/) — AI coding IDE

## License

MIT
