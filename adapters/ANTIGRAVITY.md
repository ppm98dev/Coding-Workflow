# Antigravity Adapter

> **Everything in this file is optional.**
> For canonical rules, see [PROJECT_RULES.md](../.agents/rules/PROJECT_RULES.md).
> For tool mapping, see `.agents/skills/using-quantis/references/antigravity-tools.md`.

This adapter provides Antigravity-specific enhancements for running Quantis across all Antigravity platforms (IDE, CLI, Standalone).

---

## Platform Compatibility

Quantis works across all three Antigravity platforms:

| Feature | IDE | CLI (`agy`) | Standalone |
|---------|:---:|:-----------:|:----------:|
| `invoke_subagent` | ❌ | ✅ | ✅ |
| `define_subagent` | ❌ | ✅ | ✅ |
| `browser_subagent` | ✅ | ❌ | `/browser` |
| Skills as `/commands` | ✅ | ✅ | ✅ |
| Workflow commands | `/plan` | `/_wf-plan` | `/plan` |

### CLI Command Convention

On CLI (`agy`), workflow commands use the `/_wf-` prefix:
- IDE/Standalone: `/plan 1` → CLI: `/_wf-plan 1`
- Skill commands work the same on all platforms: `/brainstorming`

### Capability-Based Detection

Workflows detect platform capabilities at runtime — not by platform name:
- `invoke_subagent` available? → use SDD with real subagents
- `browser_subagent` available? → use browser verification
- This ensures forward compatibility with new platforms

---

## Subagent Support (CLI + Standalone)

Antigravity CLI and Standalone provide **full subagent dispatch** — the equivalent of Claude Code's `Task` tool. This is the foundation for subagent-driven development (SDD).

> **Note:** `invoke_subagent` and `define_subagent` are available on CLI and Standalone only. On IDE, SDD falls back to inline execution with self-review gates. See the `subagent-driven-development` skill for details.

### Core Subagent APIs

| Tool | Purpose |
|------|---------|
| `define_subagent` | Register named subagent types with role and system prompt |
| `invoke_subagent` | Dispatch a subagent with a filled prompt template |
| `manage_subagents` | List active subagents or kill a specific one |
| `send_message` | Send inter-agent messages |
| `browser_subagent` | Specialized subagent for browser automation (see below) |

### Session Setup for SDD

At the start of any session using subagent-driven development, define the three core types:

```
define_subagent("implementer", description="Implements code tasks with TDD", system_prompt=<implementer-prompt.md contents>)
define_subagent("spec-reviewer", description="Reviews implementation against spec", system_prompt=<spec-reviewer-prompt.md contents>)
define_subagent("code-quality-reviewer", description="Reviews code quality", system_prompt=<code-quality-reviewer-prompt.md contents>)
```

Then dispatch with `invoke_subagent` using the appropriate Role and filled prompt template.

> **Full tool mapping:** See `.agents/skills/using-quantis/references/antigravity-tools.md` for the complete Claude → Antigravity tool translation table.

### Browser Subagent (IDE only)

The `browser_subagent` is available on IDE only (Standalone uses the `/browser` platform command). Workflows that reference it gracefully skip browser verification when unavailable.

**When to Use:**
- **UI verification** — Navigate to pages, validate layout, check interactions
- **Visual regression** — Capture screenshots before/after changes
- **End-to-end flows** — Click through user journeys, verify state transitions
- **API testing via browser** — Hit endpoints, inspect responses in DevTools

```
browser_subagent:
  Task: "Navigate to localhost:3000, verify the dashboard loads"
  RecordingName: "dashboard_verification"
```

- All sessions auto-recorded as **WebP video artifacts**
- Screenshots captured as evidence for VERIFICATION.md
- Recording names should be descriptive: `login_flow_test`, `api_response_check`

### Evidence Pattern

After `browser_subagent` completes, reference the recording in your verification:

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


| Quantis Phase | Recommended Profile | Reason |
|-----------|-------------------|--------|
| `/plan`, `/debug` | Reasoning (deep thinking) | Complex decisions need depth |
| `/execute` | Fast coder | Frequent iteration needs speed |
| `/verify`, `/map` | Standard (balanced) | Large context for full analysis |

---

## Anti-Patterns

❌ **Using Antigravity planning mode AND Quantis simultaneously** — Pick one system.

❌ **Ignoring browser_subagent for UI verification on IDE** — It captures screenshots AND recordings automatically. (CLI users: use curl/test output instead.)

❌ **Loading entire files when grep_search would suffice** — Search first, then read targeted ranges.

❌ **Using shell echo/cat for file creation** — Use `write_to_file`.

❌ **Skipping recordings during verification** — WebP recordings are free proof.

---

*See .agents/rules/PROJECT_RULES.md for canonical requirements.*
*See adapters/GEMINI.md for Gemini model-specific tips.*
*Based on [obra/superpowers](https://github.com/obra/superpowers)*
