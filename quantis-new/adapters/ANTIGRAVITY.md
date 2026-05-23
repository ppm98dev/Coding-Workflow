# Antigravity Adapter

> **Everything in this file is optional.**
> For canonical rules, see [PROJECT_RULES.md](../PROJECT_RULES.md).
> For tool mapping, see `.agents/skills/using-quantis/references/antigravity-tools.md`.

This adapter provides Antigravity-specific enhancements for running Quantis inside Google Antigravity IDE.

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

### Search-First Discipline
1. **Always** use `grep_search` before `view_file`
2. Search for specific patterns, functions, or variable names
3. Only `view_file` with targeted line ranges after search narrows the scope

### Progressive Skill Disclosure
Antigravity loads skills on-demand based on YAML frontmatter:
- Keep `description` fields in SKILL.md sharp and specific
- Agent reads only name + description initially
- Full content loads only when the skill is relevant

### Background Commands
Long-running processes (dev servers, watchers) should use:
- Low `WaitMsBeforeAsync` to send to background immediately
- `manage_task` to check output periodically

---

## Planning Mode Relationship

Quantis' methodology (SPEC → PLAN → EXECUTE → VERIFY) **replaces** Antigravity's built-in planning mode.

- **Do NOT** create Antigravity artifacts (`implementation_plan.md`, `task.md`, `walkthrough.md`)
- **Use only** Quantis files: `.quantis/` directory for all state
- **Workflows drive execution** — `/plan`, `/execute`, `/verify`

---

## Commit Workflow

When committing during `/execute`:

```bash
git add -A && git commit -m "feat(phase-N): task name"
```

- User approves each atomic commit
- This aligns with Quantis' one-task-one-commit atomicity rule

---

## Model Selection

Reference `model_capabilities.yaml` for detailed guidance:

| Quantis Phase | Recommended Profile | Reason |
|-----------|-------------------|--------|
| `/plan`, `/debug` | Reasoning (deep thinking) | Complex decisions need depth |
| `/execute` | Fast coder | Frequent iteration needs speed |
| `/verify`, `/map` | Standard (balanced) | Large context for full analysis |

---

## Anti-Patterns

❌ **Using Antigravity planning mode AND Quantis simultaneously** — Pick one system.

❌ **Ignoring browser_subagent for UI verification** — It captures screenshots AND recordings automatically.

❌ **Loading entire files when grep_search would suffice** — Search first, then read targeted ranges.

❌ **Using shell echo/cat for file creation** — Use `write_to_file`.

❌ **Skipping recordings during verification** — WebP recordings are free proof.

---

*See PROJECT_RULES.md for canonical requirements.*
*See adapters/GEMINI.md for Gemini model-specific tips.*
*Based on [obra/superpowers](https://github.com/obra/superpowers)*
