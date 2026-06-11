---
name: wf-map
description: The Architect — Analyze codebase and update ARCHITECTURE.md and STACK.md
---

# /map → codebase-mapper skill

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

## 3. Output
Write results to:
- `.quantis/ARCHITECTURE.md` — System design, components, data flow, conventions
- `.quantis/STACK.md` — Runtime, dependencies, infrastructure

## 4. Commit + Next Steps
```bash
git add .quantis/ARCHITECTURE.md .quantis/STACK.md
git commit -m "docs: map codebase architecture"
```
Update STATE.md.

</process>

<offer_next>
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► CODEBASE MAPPED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Components: {N}
Technical debt items: {M}

▶ /plan {N} — create execution plans with full context
```
</offer_next>

<related>
### Skills
| Skill | Purpose |
|-------|---------|
| `codebase-mapper` | Analysis methodology (delegated) |
</related>
