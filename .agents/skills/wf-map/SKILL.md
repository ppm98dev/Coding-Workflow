---
name: wf-map
description: The Architect — Analyze codebase and update ARCHITECTURE.md and STACK.md
---

# /wf-map → codebase-mapper skill

> **Skill-powered workflow.** Analysis methodology is powered by `codebase-mapper`. This workflow adds Quantis output routing and project validation.

<process>

## 1. Validate Project
```bash
# Check this is a real project with source files
code_files=$(find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.py" -o -name "*.go" -o -name "*.rs" \) \
  -not -path '*/node_modules/*' -not -path '*/.git/*' | head -5)
```
If no source files found, warn but proceed (could be documentation-only).

## 2. Analyze Codebase
**Read and follow `.agents/skills/codebase-mapper/SKILL.md` exactly.**

The skill handles all 5 analysis domains:
1. Structure analysis
2. Dependency analysis
3. Pattern analysis
4. Integration analysis
5. Technical debt analysis

**If `invoke_subagent` is available** (CLI `agy`, Standalone): **you MUST run the 5 domains as parallel `research` subagents — do not analyze inline.** Read `.agents/skills/dispatching-parallel-agents/SKILL.md`, then dispatch one `research` subagent per domain — **but ≤3 concurrent** (per the Concurrency Cap in that skill; 5 domains = two waves). Each subagent prompt MUST contain, **given as PATHS to read** (the subagent reads each into its own clean context window — do NOT paste file contents; pasting is what overloads a subagent):
1. That domain's instructions copied from `.agents/skills/codebase-mapper/SKILL.md`.
2. The relevant slice of the Step 3 output structure (ARCHITECTURE.md or STACK.md) as the required return format.

**Required return format:** that domain's findings in the Step 3 ARCHITECTURE.md / STACK.md structure.

When the subagents return, **continue at Step 3** — merge their findings into ARCHITECTURE.md and STACK.md.

**If `invoke_subagent` is NOT available** (IDE): analyze all 5 domains inline yourself.

**If a dispatch fails or returns unusable findings:** re-dispatch that domain once with feedback; on a second failure, analyze it inline and note the fallback.

> Detection is automatic. Never ask the user which mode to use.

**Subagent types** (`.agents/skills/using-quantis/references/antigravity-tools.md`): `research` = read-only codebase navigation/exploration.

## 3. Output
Write results to:
- `.quantis/ARCHITECTURE.md` — System design, components, data flow, conventions
- `.quantis/STACK.md` — Runtime, dependencies, infrastructure

## 4. Commit + Next Steps
```bash
git add .quantis/ARCHITECTURE.md .quantis/STACK.md
git commit -m "docs: map codebase architecture"
```
Edit `.quantis/STATE.md` IN PLACE (canonical schema in `.quantis/templates/state.md`) — set:
```markdown
## Current Position
- **Task**: Architecture mapped — ARCHITECTURE.md / STACK.md updated
  (Leave **Status** unchanged — `/wf-map` is an analysis pass, not a phase transition; the enum is planning|executing|verifying|blocked|paused.)
```

</process>

<offer_next>
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► CODEBASE MAPPED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Components: {N}
Technical debt items: {M}

▶ /wf-plan {N} — create execution plans with full context
```
</offer_next>

<related>
### Skills
| Skill | Purpose |
|-------|---------|
| `codebase-mapper` | Analysis methodology (delegated) |
| `dispatching-parallel-agents` | Per-domain parallel fan-out when `invoke_subagent` is available |
</related>
