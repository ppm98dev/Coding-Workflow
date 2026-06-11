# Quantis v3.2 Manifest

> Core files managed by Quantis. Used by `/install`, `/update`, and `/upgrade`
> to determine what to replace vs preserve.

## Core Directories

### Workflows (`.agents/skills/wf-*/` — 30 directories)
- wf-add-phase
- wf-add-todo
- wf-audit-milestone
- wf-check-todos
- wf-complete-milestone
- wf-debug-issue
- wf-discuss-phase
- wf-execute
- wf-insert-phase
- wf-install
- wf-list-phase-assumptions
- wf-map
- wf-new-milestone
- wf-new-project
- wf-pause
- wf-plan-milestone-gaps
- wf-plan
- wf-progress
- wf-quantis-help
- wf-remove-phase
- wf-research-phase
- wf-resume-session
- wf-sprint
- wf-stress-test
- wf-update-plan
- wf-update
- wf-upgrade
- wf-verify
- wf-web-search
- wf-whats-new

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

### Adapters (`adapters/` — 1 file)
- ANTIGRAVITY.md

### Documentation (`docs/`)
- README.opencode.md
- windows/polyglot-hooks.md
- model-selection-playbook.md
- runbook.md
- token-optimization-guide.md

### Scripts (`scripts/`)
- install.sh
- search_repo.sh
- setup_search.sh
- validate-all.sh
- validate-skills.sh
- validate-templates.sh
- validate-workflows.sh

### Rules (`.agents/rules/` — 3 files, auto-discovered)
- CONSTITUTION.md
- PROJECT_RULES.md
- QUANTIS-STYLE.md

### Root Files (project root)
- CHANGELOG.md
- MANIFEST.md
- README.md
- VERSION

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
- .agents/rules/CONSTITUTION.md (user's customized copy)
