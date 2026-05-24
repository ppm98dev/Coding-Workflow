# Changelog

## [3.0.0] — 2026-05-24

### 🎉 Major Release: Superpowers Integration

Complete methodology overhaul powered by [obra/superpowers](https://github.com/obra/superpowers) v5.1.0.

#### Added
- 18 skills (13 from Superpowers + 5 Quantis context skills)
- Subagent-driven development (SDD) for Antigravity 2.0
- TDD, code review, systematic debugging skills
- Brainstorming skill (replaces /discuss-phase, /stress-test, /research-phase)
- Writing-plans skill (replaces /plan methodology)
- Executing-plans skill (replaces /execute methodology)
- /upgrade workflow for GSD→v3.0 migration
- MANIFEST.md for safe, non-destructive updates
- Platform adapters (Antigravity, Gemini CLI, Claude, GPT/OSS)

#### Changed
- Skills auto-trigger based on task context (no explicit invocation needed)
- /update is now MANIFEST-aware (preserves user-installed skills)
- /install updated for v3.0 package structure
- Skill-powered slash commands preserved as aliases (/plan, /execute, etc.)
- docs/ cleaned to user-relevant content only

#### Removed
- Old core skills (planner, executor, verifier, debugger, context-fetch, empirical-validation)
- tests/ directory (Claude Code-specific, incompatible with Antigravity)
- docs/superpowers/ internal development docs
- scripts/ directory (no longer needed)
