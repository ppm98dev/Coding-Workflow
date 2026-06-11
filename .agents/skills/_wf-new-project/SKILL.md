---
description: Initialize a new project with deep context gathering
---

# /new-project Workflow

<objective>
Initialize a new project through unified flow: constitution → questioning → research (optional) → requirements → roadmap.

This is the most leveraged moment in any project. Deep questioning here means better plans, better execution, better outcomes. One command takes you from idea to ready-for-planning.

**Creates:**
- `.agents/rules/CONSTITUTION.md` — project quality standards (first!)
- `.quantis/SPEC.md` — project specification
- `.quantis/ROADMAP.md` — phase structure
- `.quantis/STATE.md` — project memory
- `.quantis/ARCHITECTURE.md` — system design (if brownfield)
- All other .quantis/ documentation files

**After this command:** Run `/plan 1` to start execution.
</objective>

<process>

## Phase 1: Setup
**MANDATORY FIRST STEP — Execute these checks before ANY user interaction:**

1. **Abort if project exists:**

   
      ```bash
   if [ -f ".quantis/SPEC.md" ]; then
       echo "Error: Project already initialized. Use /progress" >&2
       exit 1
   fi
   ```

2. **Initialize git repo** (if not exists):

   
      ```bash
   if [ ! -d ".git" ]; then
       git init
       echo "Initialized new git repo"
   fi
   ```

3. **Detect existing code (brownfield detection):**

   
      ```bash
   code_files=$(find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.py" -o -name "*.go" -o -name "*.rs" \) \
       -not -path '*/node_modules/*' -not -path '*/.git/*' | head -20)
   
   has_package=$(test -f "package.json" -o -f "requirements.txt" -o -f "Cargo.toml" && echo true || echo false)
   has_architecture=$(test -f ".quantis/ARCHITECTURE.md" && echo true || echo false)
   ```

---

## Phase 2: Create Constitution
**Define HOW you want to build before defining WHAT to build.**

Display banner:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► CONSTITUTION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Before defining what to build, let's define your quality standards.
These rules will be enforced in every plan and execution.
```

Walk through each article with focused questions. Offer sensible defaults — the user can accept with Enter or customize:

1. **Code Quality**: "Max function length? (default: ~20 lines)" / "Naming convention? (default: snake_case for Python, camelCase for JS)"
2. **Error Handling**: "Strategy? (A) Fail-fast (B) Graceful degradation (C) Hybrid — default: A"
3. **Logging**: "Format? (A) Structured JSON (B) Plaintext — default: A for APIs, B for scripts" / "Min level in prod? (default: INFO)"
4. **Input Validation**: "Validation library? (default: framework-appropriate — Pydantic/Zod/etc.)"
5. **Testing**: "Test-first mandatory? (A) Yes — TDD (B) Tests alongside code (C) Tests after — default: B" / "Coverage target? (default: 80%)"
6. **Security**: "Auth method? (A) JWT (B) Session (C) OAuth (D) None — default: depends on project type"
7. **Documentation**: "Docstrings required on? (A) All public functions (B) All functions (C) Critical only — default: A"
8. **Performance**: "Latency targets? (Enter for 'best effort')" / "Any specific perf constraints?"
9. **Dependencies**: "Dependency policy? (A) Any allowed (B) Review before adding (C) Minimal — default: B"
10. **Architecture**: "Layering? (A) Standard (UI/Logic/Data) (B) Clean Architecture (C) Flat — default: A"

**After all questions:**
- Fill the constitution template (`.quantis/templates/constitution.md`) with answers
- Create `.agents/rules/CONSTITUTION.md`
- Display summary

```
Constitution created with 10 articles.

Review?
A) Looks good — proceed
B) Edit further — let me adjust
```

If "Edit further" — ask what to change, update, and re-display.

---

## Phase 3: Brownfield Offer
**If existing code detected and ARCHITECTURE.md doesn't exist:**

```
⚠️ EXISTING CODE DETECTED

Found {N} source files in this directory.

Options:
A) Map codebase first — Run /map to understand existing architecture (Recommended)
B) Skip mapping — Proceed with project initialization

Which do you prefer?
```

**If "Map codebase first":**
```
Run `/map` first, then return to `/new-project`
```
Exit command.

**If "Skip mapping":** Continue to Phase 4.
**If no existing code detected OR codebase already mapped:** Continue to Phase 4.

---

## Phase 4: Deep Questioning

> **Skill enhancement:** For structured ideation, read `.agents/skills/brainstorming/SKILL.md` and follow its methodology during this phase.

Display banner:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► QUESTIONING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Open the conversation:**

Ask: "What do you want to build?"

Wait for response. This gives context for intelligent follow-ups.

**Follow the thread:**

Based on their answer, ask follow-up questions that dig deeper:
- What excited them about this idea
- What problem sparked this
- What they mean by vague terms
- What it would actually look like
- What's already decided

**Questioning techniques:**
- Challenge vagueness: "When you say 'fast', what does that mean specifically?"
- Make abstract concrete: "Give me an example of how a user would..."
- Surface assumptions: "You're assuming users will... Is that validated?"
- Find edges: "What's explicitly NOT in scope?"
- Reveal motivation: "Why does this matter now?"

**Context checklist (gather mentally, not as interrogation):**
- [ ] Vision — What does success look like?
- [ ] Users — Who is this for?
- [ ] Problem — What pain does it solve?
- [ ] Scope — What's in, what's out?
- [ ] Constraints — Technical, timeline, budget?
- [ ] Prior art — What exists already?

**Decision gate:**

When you could write a clear SPEC.md:
```
Ready to create SPEC.md?

A) Create SPEC.md — Let's move forward
B) Keep exploring — I want to share more
```

If "Keep exploring" — ask what they want to add, or identify gaps and probe naturally.

Loop until "Create SPEC.md" selected.

---

## Phase 5: Write SPEC.md

Create `.quantis/SPEC.md` using the template from `.quantis/templates/spec.md`:

```markdown
# SPEC.md — Project Specification

> **Status**: `FINALIZED`
>
> ⚠️ **Clarification Rule**: Mark ALL ambiguities with `[NEEDS CLARIFICATION: question]`.
> 📐 **Separation Rule**: WHAT to build + WHY, not HOW. Tech choices go in PLAN.md.

## Vision
{Distilled from questioning — one paragraph max}

## Goals
1. {Primary goal}
2. {Secondary goal}
3. {Tertiary goal}

## Non-Goals (Out of Scope)
- {Explicitly excluded}
- {Not in this version}

## Users
{Who will use this and how}

## Constraints
- {Technical constraints}
- {Timeline constraints}
- {Other limitations}

## Quality Requirements
<!-- Reference .agents/rules/CONSTITUTION.md articles when filling these -->
- **Error Handling**: {from constitution or [NEEDS CLARIFICATION]}
- **Logging**: {from constitution or [NEEDS CLARIFICATION]}
- **Performance**: {targets or [NEEDS CLARIFICATION]}
- **Security**: {requirements or [NEEDS CLARIFICATION]}

## Success Criteria
- [ ] {Measurable outcome 1}
- [ ] {Measurable outcome 2}

## Edge Cases
- What happens when {boundary condition}?
- How does the system handle {error scenario}?

## Unresolved Questions
<!-- Must be EMPTY before FINALIZED -->
```

```
💡 Mark anything you're unsure about with [NEEDS CLARIFICATION: question].
   These must be resolved before planning can begin.
   
   Tip: Run /stress-test to have the spec adversarially reviewed.
```

---

## Phase 5b: Stress-Test Suggestion

After SPEC.md is created, suggest:

```
💡 SPEC REVIEW AVAILABLE

Your spec is written. Before we plan, consider stress-testing it:

/stress-test — Adversarial review to find gaps and ambiguity

This is optional but recommended for complex projects.
Planning will catch unresolved [NEEDS CLARIFICATION] markers either way.

A) Run /stress-test now
B) Skip — proceed to roadmap
```

If user selects A: run /stress-test, then return to /new-project flow.
If user selects B: continue to roadmap creation.

---

## Phase 6: Research Decision

If project involves unfamiliar technology or architectural decisions:

```
📚 RESEARCH CHECK

This project involves {area where research might help}.

Would you like to:
A) Do research first — Investigate options before committing
B) Skip research — I know what I want, let's plan

```

**If research selected:**
- Create `.quantis/RESEARCH.md` with findings
- Document technology choices and rationale
- Return to continue

---

## Phase 7: Define Requirements

Generate requirements from SPEC.md:

```markdown
# REQUIREMENTS.md

## Format
| ID | Requirement | Source | Status |
|----|-------------|--------|--------|
| REQ-01 | {requirement} | SPEC goal 1 | Pending |
| REQ-02 | {requirement} | SPEC goal 2 | Pending |
```

**Rules:**
- Each requirement is testable
- Each maps to a SPEC goal
- Status starts as "Pending"

**If simple project:** Skip formal requirements, SPEC.md is sufficient.

---

## Phase 8: Create Roadmap

Create `.quantis/ROADMAP.md`:

```markdown
# ROADMAP.md

> **Current Phase**: Not started
> **Milestone**: v1.0

## Must-Haves (from SPEC)
- [ ] {must-have 1}
- [ ] {must-have 2}

## Phases

### Phase 1: {Foundation}
**Status**: ⬜ Not Started
**Objective**: {what this delivers}
**Requirements**: REQ-01, REQ-02

### Phase 2: {Core Feature}
**Status**: ⬜ Not Started
**Objective**: {what this delivers}
**Requirements**: REQ-03

### Phase 3: {Integration}
**Status**: ⬜ Not Started
**Objective**: {what this delivers}

### Phase 4: {Polish/Launch}
**Status**: ⬜ Not Started
**Objective**: {final touches}
```

**Phase creation rules:**
- 3-5 phases per milestone
- Each phase has clear deliverable
- Dependencies flow forward

---

## Phase 9: Initialize Remaining Files

Create with templates:
- `.quantis/STATE.md` — Empty state
- `.quantis/DECISIONS.md` — Empty ADR log
- `.quantis/JOURNAL.md` — Empty journal
- `.quantis/TODO.md` — Empty todo list

Create directories:
- `.quantis/phases/`
- `.quantis/templates/`

---

## Phase 10: Initial Commit

```bash
git add .quantis/
git commit -m "chore: initialize Quantis project

- SPEC.md with vision and goals
- ROADMAP.md with {N} phases
- Project documentation structure"
```

---

## Phase 11: Done

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► PROJECT INITIALIZED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Project: {name}
Phases: {N}

Files created:
• .agents/rules/CONSTITUTION.md (10 articles)
• .quantis/SPEC.md (FINALIZED)
• .quantis/ROADMAP.md ({N} phases)
• .quantis/STATE.md
• .quantis/DECISIONS.md
• .quantis/JOURNAL.md

───────────────────────────────────────────────────────

▶ NEXT

/discuss-phase 1 — Clarify scope (optional but recommended)
/plan 1 — Create Phase 1 execution plans

───────────────────────────────────────────────────────

💡 The questioning phase is the highest-leverage moment.
   Time invested here pays dividends throughout execution.

───────────────────────────────────────────────────────
```

</process>

<questioning_philosophy>
## Why Deep Questioning Matters

The Quantis methodology emphasizes that `/new-project` is the most leveraged moment. 
Every minute spent understanding what to build saves hours of building the wrong thing.

**Signs questioning is done:**
- You could explain the project to a stranger
- You know what's NOT being built (scope edges)
- Success criteria are measurable
- You're excited to start planning

**Signs more questioning needed:**
- Vague terms remain unexplained
- You don't know who the user is
- Success is defined as "it works"
- Scope keeps expanding during discussion
</questioning_philosophy>
