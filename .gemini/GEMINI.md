# Quantis Methodology — Mission Control Rules

> **Quantis**: A spec-driven, context-engineered development methodology.
>
> These rules enforce disciplined, high-quality autonomous development.
> Quantis replaces Antigravity's built-in planning mode — use Quantis workflows exclusively.

---

## Canonical Rules

**All canonical rules are in [PROJECT_RULES.md](../PROJECT_RULES.md).**

This file provides Antigravity integration. For the complete methodology, see PROJECT_RULES.md.

---

## Core Principles

1. **Plan Before You Build** — No code without specification
2. **State Is Sacred** — Every action updates persistent memory
3. **Context Is Limited** — Prevent degradation through hygiene
4. **Verify Empirically** — No "trust me, it works"

---

## Quick Reference

```
Before coding    → Check SPEC.md is FINALIZED
Before file read → Search first (grep_search), then targeted read (view_file)
After each task  → Update STATE.md
After 3 failures → State dump + fresh session
Before "Done"    → Empirical proof captured (browser_subagent for UI, run_command for tests)
```

---

## Workflow Integration

These rules integrate with Quantis workflows and Antigravity tools:

| Workflow   | Rules Enforced                             | Antigravity Tools                                            |
| ---------- | ------------------------------------------ | ------------------------------------------------------------ |
| `/map`     | Updates ARCHITECTURE.md, STACK.md          | `grep_search`, `list_dir`, `view_file`                       |
| `/plan`    | Enforces Planning Lock, creates ROADMAP    | `search_web`, `read_url_content`                             |
| `/execute` | Enforces State Persistence after each task | `run_command`, `write_to_file`, `replace_file_content`       |
| `/verify`  | Enforces Empirical Validation              | `browser_subagent` (screenshots + recordings), `run_command` |
| `/pause`   | Triggers Context Hygiene state dump        | `view_file` (STATE.md)                                       |
| `/resume`  | Loads state from STATE.md                  | `view_file` (STATE.md)                                       |

---

## Antigravity Integration

For full Antigravity-specific guidance, see [adapters/ANTIGRAVITY.md](../adapters/ANTIGRAVITY.md).

**Top 3 tips:**

1. **Use `browser_subagent` for `/verify`** — Captures screenshots AND WebP recordings automatically. Best evidence for UI verification.
2. **Search before you read** — `grep_search` first, `view_file` with line ranges second. Saves context budget.
3. **Persistent terminals for `/execute`** — Use `RunPersistent: true` for build sessions and stateful operations.

---

## Model Selection

For model-specific enhancements:

- [adapters/GEMINI.md](../adapters/GEMINI.md) — Gemini Flash vs Pro
- [adapters/CLAUDE.md](../adapters/CLAUDE.md) — Extended thinking, effort levels
- [adapters/ANTIGRAVITY.md](../adapters/ANTIGRAVITY.md) — Tool mapping and best practices

---

_Quantis Methodology for Google Antigravity_
_Canonical rules: [PROJECT_RULES.md](../PROJECT_RULES.md)_
_Source: https://github.com/gsd-build/get-shit-done_
