# Antigravity 2.0 Tool Mapping

Skills use Claude Code tool names as their reference. When you encounter these in a skill, use the Antigravity equivalent:

| Skill references | Antigravity 2.0 equivalent |
|-----------------|---------------------------|
| `Read` (file reading) | `view_file` |
| `Write` (file creation) | `write_to_file` |
| `Edit` (file editing) | `replace_file_content` or `multi_replace_file_content` |
| `Bash` (run commands) | `run_command` |
| `Grep` (search file content) | `grep_search` |
| `Glob` (search files by name) | `list_dir` |
| `TodoWrite` (task tracking) | Update `.quantis/STATE.md` directly |
| `Skill` tool (invoke a skill) | `view_file` on the skill's SKILL.md (progressive disclosure) |
| `WebSearch` | `search_web` |
| `WebFetch` | `read_url_content` |
| `Task` tool (dispatch subagent) | `invoke_subagent` (see [Subagent support](#subagent-support)) |

## Subagent Support

Antigravity supports subagents via `invoke_subagent` on CLI (`agy`) and Standalone only — the IDE does not have this tool. If `invoke_subagent` is not in your tool list, that is normal, not an error: skills fall back to inline execution automatically, and you must never ask the user whether subagents are available. When `invoke_subagent` IS available, use `define_subagent` to register named subagent types at session start.

### Defining Subagent Types

At the start of a session that will use subagent-driven development, define the three core subagent types:

```
define_subagent("implementer", description="Implements code tasks with TDD", system_prompt=<contents of implementer-prompt.md>)
define_subagent("spec-reviewer", description="Reviews implementation against spec", system_prompt=<contents of spec-reviewer-prompt.md>)
define_subagent("code-quality-reviewer", description="Reviews code quality", system_prompt=<contents of code-quality-reviewer-prompt.md>)
```

### Dispatching Subagents

When a skill says to dispatch a named agent type, use `invoke_subagent` with the appropriate role:

| Skill instruction | Antigravity equivalent |
|-------------------|----------------------|
| `Task tool (implementer)` | `invoke_subagent` with Role="implementer" and the filled prompt template |
| `Task tool (spec-reviewer)` | `invoke_subagent` with Role="spec-reviewer" and the filled prompt template |
| `Task tool (code-quality-reviewer)` | `invoke_subagent` with Role="code-quality-reviewer" and the filled prompt template |
| `Task tool (general-purpose)` with inline prompt | `invoke_subagent` with your inline prompt |

### Built-in Subagent Types

Antigravity provides these pre-built subagent types:

| Type | Purpose |
|------|---------|
| `research` | Codebase navigation and exploration (read-only) |
| `browser` | Sandboxed web browser operations |
| `self` | Clone of calling agent with same capabilities |

### Subagent Management

| Tool | Purpose |
|------|---------|
| `manage_subagents` (Action: "list") | List all active subagents |
| `manage_subagents` (Action: "kill") | Terminate a specific subagent |
| `send_message` | Send inter-agent messages |

### Prompt Filling

Skills provide prompt templates with placeholders like `{WHAT_WAS_IMPLEMENTED}` or `[FULL TEXT of task]`. Fill all placeholders and pass the complete prompt to `invoke_subagent`. The prompt template contains the agent's role, review criteria, and expected output format.

### Parallel Dispatch

Antigravity supports parallel subagent dispatch. When a skill asks you to dispatch multiple independent subagent tasks in parallel, invoke them together — **but at most 3 concurrently; send more in waves of ≤3** (`invoke_subagent` has no built-in rate-limit backoff, so a larger burst causes `429` "exhausted capacity" errors — see the Concurrency Cap in `dispatching-parallel-agents`). Keep dependent tasks sequential, but do not serialize independent subagent tasks.

## Antigravity-Exclusive Tools

These tools are available in Antigravity but have no Claude Code equivalent:

| Tool | Purpose |
|------|---------| 
| `browser_subagent` | Launch sandboxed browser for visual testing/validation |
| `generate_image` | Generate images for brainstorming, mockups, assets |
| `schedule` | Set timers or recurring cron jobs for background operations |
| `call_mcp_tool` | Invoke tools from connected MCP servers |
| `manage_task` | Manage background tasks (list, kill, status, send_input) |

## File Location Override

Quantis uses `.quantis/phases/{N}.{M}-{slug}/` for specs and plans instead of Superpowers' default locations.

When skills reference these Superpowers defaults, use the Quantis convention instead:

| Superpowers default | Quantis convention |
|--------------------|--------------------|
| `.quantis/phases/{N}/SPEC.md` | `.quantis/phases/{N}.{M}-{slug}/SPEC.md` |
| `.quantis/phases/{N}/YYYY-MM-DD-<feature>-plan.md` | `.quantis/phases/{N}.{M}-{slug}/{N}.{M}-PLAN.md` |
| `docs/reviews/` (Superpowers legacy) | `.quantis/phases/{N}.{M}-{slug}/REVIEW.md` |

## State Management

Antigravity + Quantis tracks state across sessions. After completing tasks:

1. **STATE.md** — Update current position and progress
2. **JOURNAL.md** — Add entry with session summary
3. **ROADMAP.md** — Check off deliverables when complete
4. **DECISIONS.md** — Record significant decisions with rationale
