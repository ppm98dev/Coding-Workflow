# Quantis v3.2 Manifest

> Core files managed by Quantis. Used by `/install`, `/update`, and `/upgrade`
> to determine what to replace vs preserve.

## Core Directories

### Workflows (`.agents/skills/_wf-*/` — 30 directories)
- _wf-add-phase
- _wf-add-todo
- _wf-audit-milestone
- _wf-check-todos
- _wf-complete-milestone
- _wf-debug-issue
- _wf-discuss-phase
- _wf-execute
- _wf-insert-phase
- _wf-install
- _wf-list-phase-assumptions
- _wf-map
- _wf-new-milestone
- _wf-new-project
- _wf-pause
- _wf-plan-milestone-gaps
- _wf-plan
- _wf-progress
- _wf-quantis-help
- _wf-remove-phase
- _wf-research-phase
- _wf-resume-session
- _wf-sprint
- _wf-stress-test
- _wf-update-plan
- _wf-update
- _wf-upgrade
- _wf-verify
- _wf-web-search
- _wf-whats-new

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
