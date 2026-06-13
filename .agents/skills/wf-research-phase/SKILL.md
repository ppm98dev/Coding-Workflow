---
name: wf-research-phase
description: Deep technical research for a phase
argument-hint: "<phase-number>"
---

# /wf-research-phase → brainstorming skill (research mode)

> **Skill-powered workflow.** Research methodology is powered by `brainstorming`. This workflow adds the Quantis discovery level framework and structured RESEARCH.md output.

<context>
**Phase:** $ARGUMENTS (optional — defaults to next unplanned phase)

**Required files:**
- `.quantis/ROADMAP.md` — Phase objectives to focus research
- `.quantis/DECISIONS.md` — Existing decisions to build on
</context>

<process>

## 0. Platform Check

**If `invoke_subagent` is available** (CLI `agy`, Standalone): **you MUST dispatch research subagents for L1.5+ discovery — do not research inline.** First assess the discovery level (Step 1), then:
- **L0/L1:** no subagent needed; handle inline.
- **L1.5/L2/L3:** list the open research questions, read `.agents/skills/dispatching-parallel-agents/SKILL.md`, then dispatch **one `research` subagent per independent question, all invoked together**. Each subagent prompt MUST contain, **given as PATHS to read** (the subagent reads each into its own clean context window — do NOT paste file contents; pasting is what overloads a subagent):
  1. **REQUIRED SUB-SKILL:** Read and follow `.agents/skills/brainstorming/SKILL.md` in research/explore mode — this is the research methodology the subagent applies. A dispatched subagent inherits none of your loaded skills; hand it the path, not the text.
  2. The phase objective copied from `.quantis/ROADMAP.md` and any relevant `.quantis/DECISIONS.md` entries.
  3. That subagent's single question, and the instruction to use web search and documentation reading.
  4. The RESEARCH.md section structure (Step 3) as the required return format: Findings (with sources), Decisions, Patterns, Anti-Patterns, Dependencies, Risks.

**Required return format:** the per-question findings in the Step 3 RESEARCH.md structure, with sources.

When the subagents return, **continue at Step 3** — merge their findings into a single RESEARCH.md.

**If `invoke_subagent` is NOT available** (IDE): research all questions inline (proceed to Step 1).

**If a dispatch fails or returns unusable findings:** re-dispatch that question once with feedback; on a second failure, research it inline and note the fallback.

> Detection is automatic. Never ask the user which mode to use.

**Subagent types** (`.agents/skills/using-quantis/references/antigravity-tools.md`): `research` = read-only codebase navigation/exploration (web/doc reading included).

## 1. Assess Discovery Level

Determine how deep to go:

| Level | When | Output | Time |
|-------|------|--------|------|
| **L0 — Skip** | Pure internal work, established patterns | Nothing | 0 |
| **L1 — Quick** | Single known library, confirming syntax | Notes in plan | 2-5 min |
| **L1.5 — Discovery** | Quick A-vs-B comparison | DISCOVERY.md | 5-15 min |
| **L2 — Standard** | 2-3 options, new integration | RESEARCH.md | 15-30 min |
| **L3 — Deep Dive** | Architectural decision, novel problem | Full RESEARCH.md | 1+ hour |

## 2. Research
**Read and follow `.agents/skills/brainstorming/SKILL.md`** in research/explore mode.

Use web search, documentation reading, and analysis to investigate.

## 3. Create RESEARCH.md

```bash
# Dynamically find the phase directory by prefix
PHASE_DIR=$(find .quantis/phases -maxdepth 1 -name "${PHASE}-*" | head -n 1)
if [ -z "$PHASE_DIR" ]; then
    PHASE_TITLE=$(grep -i "Phase $PHASE" .quantis/ROADMAP.md | head -n 1 | sed -E 's/.*Phase [0-9.]+:? (.*)/\1/' | tr -d '
')
    PHASE_SLUG=$(echo "$PHASE_TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-+|-+$//g')
    PHASE_DIR=".quantis/phases/${PHASE}-${PHASE_SLUG}"
    mkdir -p "$PHASE_DIR"
fi
```

Output to `"$PHASE_DIR/RESEARCH.md"`:

```markdown
# Phase {N} Research

## Questions Investigated
1. {question 1}
2. {question 2}

## Findings
### {Topic 1}
{what was learned, with sources}

## Decisions Made
- {decision and rationale}

## Patterns to Follow
- {pattern from research}

## Anti-Patterns to Avoid
- {what NOT to do and why}

## Dependencies Identified
- {external dep with version}

## Risks
- {risk and mitigation}

## Ready for Planning
{summary of what's known, what's decided}
```

## 4. Commit + Next Steps
```bash
git add "$PHASE_DIR/RESEARCH.md"
git commit -m "docs(phase-$PHASE): research complete"
```

</process>

<offer_next>
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► RESEARCH COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Discovery level: L{N}
{X} questions investigated, {Y} decisions made

▶ /wf-plan {N} — create execution plans
```
</offer_next>

<related>
### Skills
| Skill | Purpose |
|-------|---------|
| `brainstorming` | Research methodology (delegated) |
| `dispatching-parallel-agents` | Per-question parallel fan-out when `invoke_subagent` is available |
</related>
