# ROADMAP.md

> **Current Phase**: Not started
> **Milestone**: v2.0 — Antigravity-Native GSD

## Must-Haves (from SPEC)
- [ ] Antigravity adapter (`adapters/ANTIGRAVITY.md`)
- [ ] Bash-first scripts and examples
- [ ] Accurate README
- [ ] Install automation script
- [ ] All templates cross-referenced
- [ ] Real model capabilities
- [ ] Versioned CHANGELOG
- [ ] Current attribution links

## Phases

### Phase 1: Antigravity Integration
**Status**: ✅ Complete
**Objective**: Create a proper Antigravity adapter and update the Gemini entry point so GSD actually works in Antigravity.
**Deliverables:**
- `adapters/ANTIGRAVITY.md` — Antigravity-specific tool guidance (browser_subagent, run_command, generate_image, persistent context, knowledge items)
- Updated `.gemini/GEMINI.md` — Proper Antigravity entry point with tool mapping
- Updated `model_capabilities.yaml` — Real model names (Claude Opus 4, Gemini 2.5 Pro, GPT-4.1, etc.)

### Phase 2: Remove PowerShell — Bash Only
**Status**: ⬜ Not Started
**Objective**: Remove all PowerShell content (scripts + code blocks) to reduce context noise by ~1,300 lines (~10% of framework). macOS/Linux only fork.
**Deliverables:**
- Delete 6 `.ps1` script files
- Strip PowerShell code blocks from 20 workflows
- Strip PowerShell code blocks from 5 skills
- Add "macOS/Linux only" note to README

### Phase 3: Core Fixes
**Status**: ⬜ Not Started
**Objective**: Fix README accuracy, CHANGELOG formatting, attribution links, and template orphans.
**Deliverables:**
- README.md — Accurate command count, fixed mermaid diagrams, Bash-first Getting Started
- CHANGELOG.md — Proper version headers (## [1.5.0], ## [1.4.0], etc.)
- Attribution links updated to `gsd-build/get-shit-done`
- All templates cross-referenced in at least one workflow
- `.gitignore` updated for state files

### Phase 4: Install Automation & Polish
**Status**: ⬜ Not Started
**Objective**: Create a real install script and finalize the v2.0 release.
**Deliverables:**
- `scripts/install.sh` — One-command install for macOS/Linux
- `scripts/install.ps1` — One-command install for Windows
- VERSION bumped to 2.0.0
- CHANGELOG updated with v2.0.0 entry
- Final validation pass (all validators green)
