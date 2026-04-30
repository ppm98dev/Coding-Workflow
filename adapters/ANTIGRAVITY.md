# Antigravity Adapter

> **Everything in this file is optional.**
> For canonical rules, see [PROJECT_RULES.md](../PROJECT_RULES.md).

This adapter provides Antigravity-specific enhancements for running GSD inside Google Antigravity IDE.

---

## Antigravity Tool Mapping

GSD workflows map to Antigravity tools as follows:

| GSD Workflow | Antigravity Tools | Usage |
|-------------|-------------------|-------|
| `/map` | `grep_search`, `list_dir`, `view_file` | Scan structure, analyze dependencies, read key files |
| `/plan` | `search_web`, `read_url_content`, `generate_image` | Research options, read docs, create architecture diagrams |
| `/execute` | `run_command`, `write_to_file`, `replace_file_content`, `multi_replace_file_content` | Build features, run scripts, create/edit files |
| `/execute` (interactive) | `send_command_input`, `command_status` | REPLs, long-running processes, background tasks |
| `/verify` | `browser_subagent`, `run_command` | Visual proof via screenshots/recordings, test output |
| `/web-search` | `search_web`, `read_url_content` | Research, API docs, error diagnosis |
| `/debug` | `grep_search`, `run_command`, `view_file` | Search for patterns, run diagnostics, inspect state |

---

## Browser Subagent for Verification

The `browser_subagent` is Antigravity's most powerful verification tool. Use it during `/verify` for any must-have involving visual output.

### When to Use
- **UI verification** — Navigate to pages, validate layout, check interactions
- **Visual regression** — Capture screenshots before/after changes
- **End-to-end flows** — Click through user journeys, verify state transitions
- **API testing via browser** — Hit endpoints, inspect responses in DevTools

### How It Works
```
browser_subagent:
  Task: "Navigate to localhost:3000, verify the dashboard loads"
  RecordingName: "dashboard_verification"
```

- All sessions auto-recorded as **WebP video artifacts**
- Screenshots captured as evidence for VERIFICATION.md
- Recording names should be descriptive: `login_flow_test`, `api_response_check`

### Evidence Pattern
After browser_subagent completes, reference the recording in your verification:
```markdown
### ✅ Dashboard renders correctly
**Status:** PASS
**Evidence:** Browser recording `dashboard_verification.webp`
```

---

## File Operations

Use Antigravity's native file tools instead of shell commands:

| Instead of... | Use... | Why |
|---------------|--------|-----|
| `echo "content" > file.py` | `write_to_file` | Handles encoding, creates parent dirs |
| `sed -i 's/old/new/'` | `replace_file_content` | Precise line targeting, error on mismatch |
| Multiple `sed` commands | `multi_replace_file_content` | Atomic multi-edit, no intermediate states |
| `cat file.py` | `view_file` | Line-range support, binary file handling |
| `find . -name "*.py"` | `grep_search` + `list_dir` | Faster, structured output |

---

## Context Optimization

Antigravity-specific strategies for keeping context lean:

### Search-First Discipline
1. **Always** use `grep_search` before `view_file`
2. Search for specific patterns, functions, or variable names
3. Only `view_file` with targeted line ranges after search narrows the scope
4. This aligns with GSD's context-fetch skill — search first, read second

### Progressive Skill Disclosure
Antigravity loads skills on-demand based on YAML frontmatter:
- Keep `description` fields in SKILL.md sharp and specific
- Agent reads only name + description initially
- Full content loads only when the skill is relevant
- This keeps context budgets healthy during long sessions

### Persistent Terminals
Use `RunPersistent: true` in `run_command` for stateful operations:
- Environment variables persist across calls
- Useful for build sessions, test runners, database connections
- Share terminal state with `RequestedTerminalID`

### Background Commands
Long-running processes (dev servers, watchers) should use:
- Low `WaitMsBeforeAsync` to send to background immediately
- `command_status` to check output periodically
- `send_command_input` for interactive input

---

## Planning Mode Relationship

GSD's methodology (SPEC → PLAN → EXECUTE → VERIFY) **replaces** Antigravity's built-in planning mode.

### What This Means
- **Do NOT** create Antigravity artifacts (`implementation_plan.md`, `task.md`, `walkthrough.md`)
- **Use only** GSD's `.gsd/` files: SPEC.md, PLAN.md, SUMMARY.md, VERIFICATION.md
- **Workflows drive execution** — `/plan`, `/execute`, `/verify` instead of Antigravity's plan→approve→execute flow

### Why
GSD provides a more structured methodology with wave-based execution, atomic commits, and empirical verification. Using both systems creates confusion about which artifacts are authoritative.

---

## Model Selection

Reference `model_capabilities.yaml` for detailed guidance. Quick recommendations:

| GSD Phase | Recommended Profile | Reason |
|-----------|-------------------|--------|
| `/plan`, `/debug` | Reasoning (deep thinking) | Complex decisions need depth |
| `/execute` | Fast coder | Frequent iteration needs speed |
| `/verify`, `/map` | Standard (balanced) | Large context for full analysis |

---

## Commit Workflow

When committing during `/execute`:

```
run_command:
  CommandLine: 'git add -A && git commit -m "feat(phase-N): task name"'
  SafeToAutoRun: false    # User approves each atomic commit
```

- Set `SafeToAutoRun: false` for commits — ensures user reviews each one
- Set `SafeToAutoRun: true` for read-only operations (grep, ls, test runs)
- This aligns with GSD's one-task-one-commit atomicity rule

---

## Anti-Patterns

❌ **Using Antigravity planning mode AND GSD simultaneously** — Pick one system. GSD replaces planning mode.

❌ **Ignoring browser_subagent for UI verification** — It captures screenshots AND recordings automatically. Use it.

❌ **Loading entire files when grep_search would suffice** — Search first, then read targeted ranges. Saves context.

❌ **Using shell echo/cat for file creation** — Use `write_to_file`. It handles encoding, creates parent dirs, and won't silently truncate.

❌ **Running git commands with SafeToAutoRun: true** — Commits should always require user approval.

❌ **Skipping recordings during verification** — WebP recordings are free proof. Name them descriptively.

---

*See PROJECT_RULES.md for canonical requirements.*
*See adapters/GEMINI.md for Gemini model-specific tips.*
