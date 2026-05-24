# Quantis v3.0 Manifest

> Core files managed by Quantis. Used by `/install`, `/update`, and `/upgrade`
> to determine what to replace vs preserve.

## Core Directories

### Workflows (`.agent/workflows/` — 29 files)
- add-phase.md
- add-todo.md
- audit-milestone.md
- check-todos.md
- complete-milestone.md
- debug.md
- discuss-phase.md
- execute.md
- help.md
- insert-phase.md
- install.md
- list-phase-assumptions.md
- map.md
- new-milestone.md
- new-project.md
- pause.md
- plan-milestone-gaps.md
- plan.md
- progress.md
- remove-phase.md
- research-phase.md
- resume.md
- sprint.md
- stress-test.md
- update-plan.md
- update.md
- upgrade.md
- verify.md
- web-search.md
- whats-new.md

### Skills (`.agents/skills/` — 18 directories)
- brainstorming
- codebase-mapper
- context-compressor
- context-health-monitor
- dispatching-parallel-agents
- executing-plans
- finishing-a-development-branch
- receiving-code-review
- requesting-code-review
- subagent-driven-development
- systematic-debugging
- test-driven-development
- token-budget
- using-git-worktrees
- using-quantis
- verification-before-completion
- writing-plans
- writing-skills

### Templates (`.quantis/templates/` — 25 files)
- DEBUG.md
- PLAN.md
- RESEARCH.md
- SUMMARY.md
- UAT.md
- VERIFICATION.md
- architecture.md
- constitution.md
- context.md
- decisions.md
- discovery.md
- journal.md
- milestone.md
- phase-summary.md
- project.md
- requirements.md
- roadmap.md
- spec.md
- sprint.md
- stack.md
- state.md
- state_snapshot.md
- todo.md
- token_report.md
- user-setup.md

### Bootstrap (`.gemini/`)
- GEMINI.md

### Adapters (`adapters/` — 4 files)
- ANTIGRAVITY.md
- CLAUDE.md
- GEMINI.md
- GPT_OSS.md

### Documentation (`docs/`)
- README.opencode.md
- windows/polyglot-hooks.md

## Core Root Files
- CHANGELOG.md
- CONSTITUTION.md
- MANIFEST.md
- PROJECT_RULES.md
- QUANTIS-STYLE.md
- README.md
- VERSION
- model_capabilities.yaml

## User Files (NEVER overwritten by /update or /upgrade)
- .quantis/SPEC.md
- .quantis/ROADMAP.md
- .quantis/STATE.md
- .quantis/ARCHITECTURE.md
- .quantis/STACK.md
- .quantis/DECISIONS.md
- .quantis/JOURNAL.md
- .quantis/TODO.md
- .quantis/phases/* (all phase plans, summaries, research)
- CONSTITUTION.md (user's customized copy)
