# STATE.md — Session Memory

## Current Position
- **Milestone**: v2.0 — Antigravity-Native GSD ✅ COMPLETE
- **Next Milestone**: v2.1 — Spec Quality & Scaling (not started)
- **Status**: Paused at 2026-05-09T00:54:00Z

## Strategic Decision: GSD vs Spec-Kit

**Decision:** Keep GSD, steal Spec-Kit's best ideas. Don't switch.

**Rationale:**
- Spec-Kit (github/spec-kit, 93.6k ⭐) is stronger on spec creation, constitution, test-first, clarification markers
- BUT Spec-Kit has no: session management, debugging protocol, verification loop, Antigravity support
- Switching means: losing /pause /resume /debug /verify, installing Python, writing Antigravity integration from scratch
- Improving GSD is less work and gives a better result than either tool alone

**What to steal (4 targeted patches):**
1. **Constitution** → Add `CONSTITUTION.md` step to `/new-project`, load in `/plan` + `/execute`
2. **`[NEEDS CLARIFICATION]` markers** → Force in spec template, reject in plan-checker
3. **Test-first ordering** → Mandate contracts → tests → source in `/plan` task ordering
4. **File creation order** → Add to planner skill constraints

**What NOT to do:**
- Don't use both GSD and Spec-Kit (cognitive overhead, two systems)
- Don't switch to Spec-Kit (no Antigravity support, lose execution engine)
- Don't build extension/preset system (over-engineering for solo use)

## Last Session Summary (2026-05-09)
- Discussed v2.1 options, analyzed github/spec-kit in depth
- Read their full methodology (spec-driven.md)
- Identified 6 areas where Spec-Kit beats GSD (documented in TODO.md)
- Found VoltAgent/awesome-agent-skills (1000+ community skills, 20.9k ⭐)
- Identified 6 community skills directly relevant to GSD improvements
- Key finding: GSD skills are primitive (no scripts/references/assets vs community standard)
- Strategic decision: keep GSD, steal Spec-Kit's front-end ideas

## Next Steps (Tomorrow)
1. `/new-milestone` → v2.1 "Spec Quality & Scaling"
2. Phase 1: Add constitution + clarification markers to `/new-project`
3. Phase 2: Add test-first enforcement to `/plan` + `/execute`
4. Phase 3: Upgrade skill structure (add scripts/, references/, assets/)
5. Phase 4: Study + adopt Trail of Bits' `ask-questions-if-underspecified` skill
6. Optionally: dead code prevention (already researched in `.gsd/phases/5/RESEARCH.md`)
