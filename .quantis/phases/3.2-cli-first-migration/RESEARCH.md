# Phase 3.2 Research — CLI-First Migration

> Research gathered 2026-06-11. All findings verified by direct testing.

---

## 1. Platform Tool Inventory (Verified)

### Antigravity IDE
**Source**: Direct tool list inspection in active session

```
invoke_subagent:    ❌ NOT AVAILABLE
define_subagent:    ❌ NOT AVAILABLE
manage_subagents:   ❌ NOT AVAILABLE
send_message:       ❌ NOT AVAILABLE
browser_subagent:   ✅ AVAILABLE
```

### Antigravity CLI (`agy 1.0.7`, Claude Opus 4.6)
**Source**: User ran tool inventory prompt in live CLI session

```
invoke_subagent:    ✅ AVAILABLE
define_subagent:    ✅ AVAILABLE
manage_subagents:   ✅ AVAILABLE
send_message:       ✅ AVAILABLE
browser_subagent:   ❌ NOT AVAILABLE
```

Built-in subagent types:
- `research` — Read-only (file reading, web search, grep)
- `self` — Full clone (all tools, same system prompt)

### Antigravity 2.0 Standalone
**Source**: User ran tool inventory prompt in standalone app

22 native tools including ALL subagent tools + `/browser` platform command.
Full manifest provided by user — see below.

---

## 2. Workflow & Skill Discovery

| Platform | `.agent/workflows/*.md` → slash commands? | `.agents/skills/*/SKILL.md` → slash commands? |
|----------|:---:|:---:|
| IDE | ✅ Yes | ✅ Yes (auto-loaded by metadata) |
| CLI | ❌ No — "Unknown command" | ✅ Yes — registered as `/skill-name` |
| Standalone | ✅ Yes (26 found) | ✅ Yes (16 found) |

**Fix applied**: Created `_wf-*` symlink directories in `.agents/skills/` that point back to `.agent/workflows/*.md`.

---

## 3. CLI Built-in Slash Commands (Collision Risk)

Full list of CLI builtins that cannot be used as workflow names:

```
/help       /resume     /clear      /model
/context    /fork       /rewind     /config
/usage      /goal       /browser    /schedule
/agent      /settings   /undo
```

**Collisions fixed:**
| Original | Renamed To | Reason |
|----------|-----------|--------|
| `/resume` | `/resume-session` | CLI builtin: conversation picker |
| `/help` | `/quantis-help` | CLI builtin: show shortcuts |
| `/debug` | `/debug-issue` | CLI builtin: possible conflict |

---

## 4. Rules Loading

| Rules Location | IDE reads? | CLI reads? |
|---------------|:---:|:---:|
| `PROJECT_RULES.md` (root) | ✅ | ❌ |
| `GEMINI.md` (root) | ✅ | ✅ |
| `.antigravity.md` (root) | ? | ✅ (preferred) |
| `.agents/rules/` | ? | ✅ |
| `~/.gemini/GEMINI.md` (global) | ✅ | ✅ |

**Fix applied**: Symlink `.agents/rules/PROJECT_RULES.md` → `../../PROJECT_RULES.md`

---

## 5. SSH/Remote Support

| Platform | SSH Support | How |
|----------|:---:|-----|
| IDE | ✅ | Remote-SSH extension (VS Code native) |
| CLI | ✅ | Install `agy` directly on VM |
| Standalone | ❌ | Local filesystem only; workaround: `sshfs` mount |

---

## 6. Cross-Workflow References

Workflows reference other workflows in "next step" suggestions. On CLI these show `/execute` but user must type `/_wf-execute`. Affected lines:

```
plan.md:181         → "▶ Next: /execute {N}"
update-plan.md:80   → "▶ /execute {N}"
research-phase.md:98 → "▶ /plan {N}"
map.md:51           → "▶ /plan {N}"
plan-milestone-gaps.md:106 → "/execute {N} --gaps-only"
```

These are cosmetic (printed text, not executed commands). The actual workflow execution is unaffected.

---

## 7. What Was Already Done (This Session)

- [x] Renamed 3 colliding workflows + updated 10 cross-references
- [x] Created 30 `_wf-*` symlink skills (all using relative paths)
- [x] Created `.agents/rules/PROJECT_RULES.md` symlink
- [x] Verified `_wf-resume-session` works on CLI (user confirmed)
- [x] Committed all changes: `d67813d`
- [x] Added Phase 3.2 to ROADMAP.md with full deliverables

---

## 8. Remaining Work for Phase 3.2

1. **Platform detection in workflows** — "next step" suggestions should show correct prefix
2. **quantis-help.md update** — show CLI variants
3. **SDD platform detection** — use `invoke_subagent` when available, inline fallback when not
4. **browser_subagent fallback** — graceful degradation on CLI
5. **Verify symlinks on Linux VM** — git clone + test
6. **Update /install workflow** — auto-create `_wf-*` symlinks + rules symlink
7. **E2E test on CLI** — full discuss → plan → execute → verify cycle
8. **README documentation** — platform-specific usage guide

---

## 9. Standalone App Full Tool Manifest (from user)

22 native tools:
1. `ask_permission` 2. `ask_question` 3. `call_mcp_tool` 4. `define_subagent`
5. `generate_image` 6. `grep_search` 7. `invoke_subagent` 8. `list_dir`
9. `list_permissions` 10. `list_resources` 11. `manage_subagents` 12. `manage_task`
13. `multi_replace_file_content` 14. `read_resource` 15. `read_url_content`
16. `replace_file_content` 17. `run_command` 18. `schedule` 19. `search_web`
20. `send_message` 21. `view_file` 22. `write_to_file`

Platform slash commands: `/goal`, `/schedule`, `/browser`, `/grill-me`
