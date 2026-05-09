---
phase: 5
level: 2
researched_at: 2026-05-01
---

# Research: Dead Code Prevention in AI-Assisted Workflows

## The Problem

LLMs are **additive by nature** — they generate new code but rarely delete old code. This leads to:
- Dead functions nobody calls
- Duplicate helpers doing the same thing
- Old implementations sitting alongside replacements
- Unused imports accumulating
- Growing file sizes with declining quality

Industry recognizes this as "AI code bloat" — a new category of technical debt unique to AI-assisted development.

## Research Questions
1. What strategies exist to prevent dead code accumulation in AI workflows?
2. How can we integrate cleanup into GSD's plan/execute/verify cycle?
3. What tooling exists for automated dead code detection?

## Findings

### Strategy 1: Explicit Delete Instructions in Prompts

**Key insight:** LLMs follow the "path of least resistance" — adding code is easier than removing it. You must **explicitly instruct** deletion.

**What works:**
- Negative constraints: "Delete all original logic and replace it entirely"
- Scope definition: "The only requirement is input X → output Y. You may delete everything else."
- Line count targets: "Resulting code must be smaller than the original"

**GSD integration point:** `<task>` blocks in PLAN.md should include a `<remove>` tag when replacing functionality.

**Source:** kodus.io, martinfowler.com, byldd.com

---

### Strategy 2: Staged Refactoring (Inventory → Replace → Verify)

**Key insight:** Don't ask an LLM to refactor in one shot. Break it into:
1. **Inventory** — "Identify redundant, deprecated, or dead code"
2. **Replace** — "Write the new logic only"
3. **Integrate** — "Provide the full file, discarding the old version"

**GSD integration point:** This maps directly to tasks in a plan. The "inventory" step is a natural verifier check.

**Source:** kodus.io, thenewstack.io

---

### Strategy 3: Automated Dead Code Detection Tools

**Existing tools by ecosystem:**

| Tool | Language | What it detects |
|------|----------|-----------------|
| **Knip** | JS/TS | Unused exports, dead files, stale deps |
| **ts-prune** | TypeScript | Unused exports |
| **Vulture** | Python | Dead code, unused imports |
| **Periphery** | Swift | Unused declarations |
| **ESLint** | JS/TS | Unused vars, imports (with strict rules) |

**GSD integration point:** Run these in the `/verify` step. Add to verifier anti-pattern scan.

**Source:** sonarsource.com, mstone.ai

---

### Strategy 4: Architectural Boundaries

**Key insight:** AI models duplicate logic across files rather than refactoring for reuse. Enforcing module boundaries limits this.

**What works:**
- Define strict file/module boundaries
- Forbid cross-module imports that shouldn't exist
- Give AI access only to relevant files (context control)

**GSD integration point:** Already partially handled by GSD's "need-to-know" context principle and `<files>` tags in tasks. Could be strengthened.

**Source:** gitconnected.com, newline.co

---

### Strategy 5: "Before vs After" Size Tracking

**Key insight:** Track file sizes before and after each task. If a "refactor" task increases line count, that's a red flag.

**GSD integration point:** SUMMARY.md could include a line-count diff showing files that grew vs shrank.

---

## Proposed GSD Changes

### 1. New `<remove>` tag in PLAN.md tasks (in /plan)

```xml
<task type="auto">
  <name>Refactor auth to JWT</name>
  <files>src/auth.ts</files>
  <action>Replace session-based auth with JWT</action>
  <remove>
    - src/utils/sessionStore.ts (entire file — replaced by JWT)
    - generateSessionId() in src/auth.ts
    - express-session from package.json
  </remove>
  <verify>grep -r "sessionStore\|generateSessionId" src/ | wc -l → 0</verify>
  <done>Zero references to old session code remain</done>
</task>
```

### 2. New Executor Rule 5: "Auto-clean dead code" (in /execute)

> **RULE 5: Auto-clean Dead Code**
> 
> **Trigger:** You create new code that replaces existing functionality
> 
> **Process:**
> 1. Delete the old implementation
> 2. Remove unused imports from affected files
> 3. Check for orphan files (files nothing imports)
> 4. Track: `[Rule 5 - Cleanup] deleted {description}`
> 
> **No user permission needed.** Dead code is noise.

### 3. New Verifier Check: "Code Growth Audit" (in /verify)

Add to Step 7 (Anti-Patterns):

```bash
# Dead export check (JS/TS projects)
npx knip --no-exit-code 2>/dev/null

# Orphan file check (generic)
for f in src/**/*.ts; do
  basename=$(basename "$f" .ts)
  refs=$(grep -rl "$basename" src/ --include="*.ts" | grep -v "$f" | wc -l)
  if [ "$refs" -eq 0 ]; then
    echo "⚠️ Possible orphan: $f"
  fi
done

# Line count growth check
git diff --stat HEAD~1 | grep -E "\+.*\-" | awk '{if ($NF > 0) print "📈 GREW:", $1}'
```

## Decisions Made

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Where to add | /plan, /execute, /verify | Covers prevention, enforcement, and detection |
| Tooling | Language-agnostic checks + optional Knip | GSD is multi-ecosystem |
| Scope | 3 targeted changes, not a new workflow | Minimal overhead, maximum impact |

## Anti-Patterns to Avoid
- **Don't over-automate deletion** — False positives on "dead code" can break things. The executor rule should track deletions in SUMMARY, not silently remove.
- **Don't mandate specific tools** — Knip is JS-only. Keep checks generic with optional ecosystem-specific enhancements.

## Risks
- **False orphan detection** — Dynamic imports, reflection, and string-based lookups won't be caught by grep
- **Mitigation:** Frame as ⚠️ warnings, not blockers. Human verifies.

## Ready for Planning
- [x] Problem clearly defined
- [x] Three integration points identified (plan, execute, verify)
- [x] Specific code/markup changes proposed
- [x] Anti-patterns documented
