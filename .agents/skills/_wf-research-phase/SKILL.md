---
description: Deep technical research for a phase
argument-hint: "<phase-number>"
---

# /research-phase → brainstorming skill (research mode)

> **Skill-powered workflow.** Research methodology is powered by `brainstorming`. This workflow adds the Quantis discovery level framework and structured RESEARCH.md output.

<context>
**Phase:** $ARGUMENTS (optional — defaults to next unplanned phase)

**Required files:**
- `.quantis/ROADMAP.md` — Phase objectives to focus research
- `.quantis/DECISIONS.md` — Existing decisions to build on
</context>

<process>

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
    PHASE_TITLE=$(grep -i "Phase $PHASE" .quantis/ROADMAP.md | head -n 1 | sed -E 's/.*Phase [0-9.]+:? (.*)/\1/' | tr -d '')
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

▶ /plan {N} — create execution plans
```
</offer_next>

<related>
### Skills
| Skill | Purpose |
|-------|---------|
| `brainstorming` | Research methodology (delegated) |
</related>
