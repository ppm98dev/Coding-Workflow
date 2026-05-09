# Audit: `toonight/get-shit-done-for-antigravity`

> **Repo**: https://github.com/toonight/get-shit-done-for-antigravity
> **Version**: 1.5.0 · **License**: MIT · **Stars**: 832 · **Forks**: 134
> **Language split**: PowerShell 55.4% / Shell 44.6% · **53 commits**
> **Origin**: Adapted from [glittercowboy/get-shit-done](https://github.com/glittercowboy/get-shit-done) (Claude Code-specific) for Google Antigravity (model-agnostic)

---

## What Is It?

GSD is a **meta-prompting / context engineering framework** — NOT executable software. It's a collection of **markdown files** that teach AI coding agents how to build software systematically. You drop it into any project and use slash commands (typed as chat messages) to drive a structured workflow:

```
/new-project → SPEC.md → /plan → PLAN.md → /execute → /verify → /complete-milestone
```

The core thesis: **AI coding fails not because models are bad, but because humans give them terrible context.** GSD solves this with structured specs, wave-based execution, atomic commits, and empirical verification.

---

## Architecture Overview

```
├── PROJECT_RULES.md            # Single source of truth (model-agnostic rules)
├── GSD-STYLE.md                # Writing conventions for the framework itself
├── model_capabilities.yaml     # Optional model capability registry
├── VERSION                     # 1.5.0
│
├── .agent/workflows/           # 27 slash commands (markdown "programs")
│   ├── new-project.md          # Deep-questioning project init
│   ├── plan.md                 # Creates XML-structured PLAN.md files
│   ├── execute.md              # Wave-based parallel execution
│   ├── verify.md               # Empirical proof verification
│   ├── debug.md                # 3-strike debugging with state dump
│   ├── sprint.md               # Time-boxed sprints
│   ├── pause.md / resume.md    # Session persistence
│   └── ... (21 more)
│
├── .agents/skills/             # 11 agent specializations
│   ├── planner/SKILL.md        # Goal-backward planning methodology
│   ├── executor/SKILL.md       # Atomic commits, deviation handling
│   ├── verifier/SKILL.md       # Must-haves extraction
│   ├── debugger/SKILL.md       # 3-strike systematic diagnosis
│   ├── codebase-mapper/        # Structure analysis
│   ├── context-compressor/     # Token optimization
│   ├── context-fetch/          # Smart context loading
│   ├── context-health-monitor/ # Prevents context rot
│   ├── empirical-validation/   # Proof requirements
│   ├── plan-checker/           # Pre-execution validation
│   └── token-budget/           # Usage tracking
│
├── .gsd/                       # Project state (populated per-project)
│   ├── templates/              # 22 document templates
│   └── examples/               # 4 usage walkthroughs
│
├── adapters/                   # Optional model-specific enhancements
│   ├── CLAUDE.md               # Extended thinking, effort levels
│   ├── GEMINI.md               # Flash vs Pro selection
│   └── GPT_OSS.md              # Function calling guidance
│
├── .gemini/GEMINI.md           # Gemini CLI integration entry point
├── docs/                       # Runbook, model playbook, token guide
└── scripts/                    # Validation & search scripts (PS1 + SH pairs)
```

---

## Strengths

| Area | What's Good |
|------|-------------|
| **Core methodology** | The SPEC→PLAN→EXECUTE→VERIFY pipeline is solid and well-thought-out |
| **Context engineering** | Explicit context budgets, compression protocols, fresh-context-per-task pattern |
| **Deviation rules** | Smart 4-rule system (auto-fix bugs, auto-add critical, auto-fix blockers, ASK about architecture) |
| **Wave execution** | Dependency-based grouping for parallel execution is clever |
| **Empirical verification** | "No trust me, it works" — forces captured proof |
| **Model agnosticism** | Clean adapter pattern, nothing hard-depends on a specific provider |
| **Cross-platform** | Every script has both PowerShell and Bash versions |
| **Templates** | 22 templates covering virtually every doc type |
| **Self-documenting** | GSD-STYLE.md explains how to write GSD files consistently |

---

## Weaknesses & Issues

### 🔴 Critical

| Issue | Detail |
|-------|--------|
| **No Antigravity adapter** | Despite being "for Antigravity", there's NO `adapters/ANTIGRAVITY.md`. The `.gemini/GEMINI.md` entry point redirects to `adapters/GEMINI.md` but there's nothing Antigravity-specific (skill discovery, browser tools, image generation, persistent terminals, etc.) |
| **Slash commands don't work in Antigravity** | GSD assumes `/plan`, `/execute` etc. are recognized as chat commands. Antigravity uses `.agent/workflows/` but the discovery mechanism differs — users typing `/plan` may not trigger the workflow |
| **PowerShell-first bias** | Despite "cross-platform", executor SKILL.md shows PowerShell examples first (e.g., `git log` via PowerShell). macOS/Linux users (your primary platform) hit friction |
| **No actual test suite** | "Testing" is validation scripts that check file existence. Zero unit tests, zero integration tests on the methodology itself |

### 🟡 Significant

| Issue | Detail |
|-------|--------|
| **README is misleading** | Claims 29 commands but tree shows 27 workflow files. Mermaid diagrams render as code blocks (not rendered in GitHub's viewer for this format) |
| **Stale upstream** | Original repo ([glittercowboy/get-shit-done](https://github.com/glittercowboy/get-shit-done)) has been moved to `gsd-build/get-shit-done` — attribution links are stale |
| **No install automation** | Getting Started requires 10+ manual `cp` commands. The `/install` workflow exists but is itself a markdown file the AI reads — no actual shell script |
| **Token optimization is theoretical** | The token-budget skill and context-health-monitor describe rules but have no actual measurement mechanism |
| **Templates are orphans** | 22 templates exist but many aren't referenced by any workflow (e.g., `user-setup.md`, `discovery.md`) |
| **No version pinning** | `/update` workflow pulls from HEAD with no version compatibility checking |

### 🟢 Minor

| Issue | Detail |
|-------|--------|
| **Duplicate content** | CHANGELOG has no version headers (just `---` separators), making it hard to parse programmatically |
| **model_capabilities.yaml** | Uses generic "Flash/Turbo variants" instead of actual model names — not actionable |
| **No `.gitignore` for state files** | `.gsd/STATE.md`, `JOURNAL.md` etc. would be committed to the template repo, polluting clean starts |
| **Missing GSD-STYLE.md headers** | Section headers are missing from the rendered content (likely stripped during parsing) |

---

## Improvement Roadmap

### Phase 1: Make It Actually Work in Antigravity

| Task | Priority | Effort |
|------|----------|--------|
| Create `adapters/ANTIGRAVITY.md` with Antigravity-specific tool guidance (browser_subagent, run_command, image generation, persistent context) | 🔴 P0 | Medium |
| Rewrite `.gemini/GEMINI.md` → add Antigravity-native instructions (how to use planning mode, how tools map to GSD phases) | 🔴 P0 | Medium |
| Add a real `scripts/install.sh` that automates the 10-step copy process | 🔴 P0 | Small |
| Fix workflow discovery — ensure `.agent/workflows/` files are picked up correctly, or document how to invoke them | 🔴 P0 | Small |

### Phase 2: Fix Core Issues

| Task | Priority | Effort |
|------|----------|--------|
| Remove PowerShell-first bias — make Bash the primary, PowerShell secondary (matching macOS/Linux target) | 🟡 P1 | Medium |
| Fix README — accurate command count, fix mermaid rendering, update attribution links | 🟡 P1 | Small |
| Add version headers to CHANGELOG | 🟡 P1 | Small |
| Make model_capabilities.yaml reference real models (Claude Opus 4, Gemini 2.5 Pro, GPT-4.1, etc.) | 🟡 P1 | Small |
| Add proper `.gitignore` for state files that shouldn't be in the template | 🟡 P1 | Small |

### Phase 3: Add Real Value

| Task | Priority | Effort |
|------|----------|--------|
| Create a `gsd` CLI tool (Python or Node) that wraps the methodology — real commands, real state management, not just markdown prompts | 🟢 P2 | Large |
| Add automated context measurement — actually track token usage, warn at thresholds | 🟢 P2 | Medium |
| Build a `/migrate` command for bringing existing projects into GSD (scan existing code → generate SPEC.md + ARCHITECTURE.md) | 🟢 P2 | Medium |
| Add CI/GitHub Actions integration — auto-verify on PR, auto-generate SUMMARY.md | 🟢 P2 | Medium |
| Create visual dashboard (HTML) for project state — phases, progress, verification status | 🟢 P2 | Large |

### Phase 4: Differentiate from Upstream

| Task | Priority | Effort |
|------|----------|--------|
| Support multi-agent orchestration (Antigravity's subagent pattern) — plan in one context, execute tasks in parallel browser/terminal subagents | 🔵 P3 | Large |
| Add cost tracking per phase (token costs by model) | 🔵 P3 | Medium |
| Create "GSD Lite" mode — minimal overhead for small scripts/quick projects | 🔵 P3 | Medium |

---

## Verdict

> [!IMPORTANT]
> **Worth cloning and improving, but NOT ready to use as-is in Antigravity.** The core methodology (SPEC→PLAN→EXECUTE→VERIFY) is genuinely good context engineering. But the "for Antigravity" adaptation is superficial — it's basically the original GSD with a Gemini entry point bolted on. The biggest wins come from Phase 1 (make it actually work) and Phase 3 (add a real CLI instead of markdown-as-code).

### Recommendation

Clone it into your `Coding-Workflow` workspace, then focus on:
1. **Antigravity adapter** — this is the #1 gap
2. **Install script** — reduce friction to zero
3. **Bash-first rewrite** — you're on macOS
4. **Eventually: a real CLI** — the markdown-only approach is clever but fragile

Want me to proceed with cloning and start on Phase 1?
