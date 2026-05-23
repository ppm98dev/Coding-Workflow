---
phase: 2
plan: gap-closure
wave: 1
gap_closure: true
---

# Gap Closure: Thicken 7 Workflow Aliases

## Problem
The 7 aliased workflows (plan, execute, discuss-phase, stress-test, research-phase, update-plan, map) were reduced from 120-377 lines to ~20 lines each. The aliases correctly point to skills for methodology, but they lost critical **Quantis-specific orchestration logic** that the skills don't cover.

## Gap Analysis

### /plan (old: 377 lines → new: 22 lines)
**Skill covers:** Task decomposition, bite-sized granularity, self-review, file structure
**Missing from alias:**
- ❌ Planning Lock validation (SPEC.md must be FINALIZED, CONSTITUTION.md must exist)
- ❌ Argument parsing (phase number, --research, --skip-research, --gaps flags)
- ❌ Research handling (discovery levels, RESEARCH.md creation/reuse)
- ❌ Constitutional compliance requirement in plans
- ❌ Plan checker logic (verify files exist, actions are specific, max 3 iterations)
- ❌ Quality degradation curve awareness (plans should complete within ~50% context)
- ❌ Task type definitions (auto, checkpoint:human-verify, checkpoint:decision)
- ❌ Test quality rules (anti-patterns: mock everything, tautological assert, etc.)
- ❌ Banners, commit workflow, next steps output
**Verdict: SIGNIFICANT — needs ~100 lines of Quantis orchestration**

### /execute (old: 298 lines → new: 23 lines)
**Skill covers:** Load plan, execute tasks, when to stop, finishing branch
**Missing from alias:**
- ❌ Environment validation (ROADMAP, STATE, CONSTITUTION existence checks)
- ❌ Phase validation (check phase exists in roadmap)
- ❌ Plan discovery (find incomplete plans, skip completed ones with SUMMARY.md)
- ❌ --gaps-only flag filtering
- ❌ Wave grouping and sequential execution
- ❌ Constitutional compliance checking during execution
- ❌ SUMMARY.md creation after each plan
- ❌ Phase goal verification after all waves
- ❌ Gap closure plan generation on FAIL
- ❌ Roadmap/State update on completion
- ❌ Context hygiene (3-strike rule)
- ❌ Banners, commit workflow, next steps (routes A/B/C)
**Verdict: CRITICAL — needs ~150 lines of Quantis orchestration**

### /map (old: 339 lines → new: 19 lines)
**Skill covers:** Full analysis (structure, deps, patterns, debt), output format, scanning process
**Missing from alias:**
- ❌ Project validation (is this a real project?)
- ❌ Banner formatting
- ❌ Commit workflow
- ❌ Next steps output
**Verdict: MINOR — skill has almost everything. Needs ~20 more lines**

### /discuss-phase (old: 123 lines → new: 23 lines)
**Skill covers:** Brainstorming methodology, ideation process
**Missing from alias:**
- ❌ Phase context loading (read phase from ROADMAP, extract objectives)
- ❌ Requirements analysis (identify concerns, dependencies, risks)
- ❌ Structured discussion points presentation
- ❌ Decision documentation to DECISIONS.md
- ❌ Banners, commit, next steps
**Verdict: MODERATE — needs ~60 lines**

### /stress-test (old: 225 lines → new: 23 lines)
**Skill covers:** Brainstorming in critique mode
**Missing from alias:**
- ❌ 7-dimension adversarial review framework (completeness, consistency, feasibility, edge cases, security, performance, maintainability)
- ❌ Structured report generation with severity ratings
- ❌ Auto-fix suggestions for each finding
- ❌ Unresolved questions update in SPEC.md
- ❌ Banners, commit, next steps
**Verdict: SIGNIFICANT — the 7-dimension framework is core value. Needs ~100 lines**

### /research-phase (old: 155 lines → new: 22 lines)
**Skill covers:** Brainstorming in research mode
**Missing from alias:**
- ❌ Discovery level framework (L0-L3)
- ❌ Structured RESEARCH.md template (Questions, Findings, Decisions, Patterns, Anti-Patterns, Risks)
- ❌ Phase context loading
- ❌ "Ready for Planning" output
- ❌ Banners, commit, next steps
**Verdict: MODERATE — needs ~60 lines**

### /update-plan (old: 170 lines → new: 23 lines)
**Skill covers:** Writing plans in revision mode
**Missing from alias:**
- ❌ Validate existing plans exist
- ❌ Display current plan structure
- ❌ Track and display changes summary (what changed, why)
- ❌ Re-validate plans after revision
- ❌ Banners, commit, next steps
**Verdict: MODERATE — needs ~60 lines**

## Tasks

<task type="auto">
  <name>Thicken /plan alias with Quantis orchestration</name>
  <files>
    quantis-new/.agent/workflows/plan.md (rewrite)
  </files>
  <action>
    Merge the old workflow's Quantis orchestration INTO the alias while keeping skill delegation.
    
    Structure (~100 lines):
    1. Keep YAML frontmatter + description
    2. Add <role> with "Quantis planner orchestrator" responsibilities
    3. Add <context> with $ARGUMENTS, flags (--research, --skip-research, --gaps)
    4. Add <philosophy> with quality degradation curve, aggressive atomicity, plans-are-prompts
    5. Add <process> steps:
       - Step 1: Planning Lock (validate SPEC.md FINALIZED + CONSTITUTION.md exists)
       - Step 2: Parse arguments (phase number, flags)
       - Step 3: Validate phase in ROADMAP.md
       - Step 4: Handle research (discovery levels, skip/reuse/create)
       - Step 5: **"Read and follow writing-plans/SKILL.md"** — delegate methodology
       - Step 6: Plan checker (verify files, actions, tests — max 3 iterations)
       - Step 7: Update STATE.md
       - Step 8: Commit + offer next steps
    6. Add <task_types> section
    7. Add <related> with updated skill references
    
    Key principle: The alias owns WHAT happens (Quantis process), the skill owns HOW (planning methodology).
  </action>
  <verify>
    wc -l quantis-new/.agent/workflows/plan.md  # Should be ~100-120 lines
    grep "FINALIZED" quantis-new/.agent/workflows/plan.md  # Planning lock
    grep "writing-plans/SKILL.md" quantis-new/.agent/workflows/plan.md  # Skill delegation
    grep "discovery_levels\|Research\|--research" quantis-new/.agent/workflows/plan.md  # Research handling
  </verify>
  <done>plan.md has Quantis orchestration (planning lock, research, checker) + skill delegation</done>
</task>

<task type="auto">
  <name>Thicken /execute alias with Quantis orchestration</name>
  <files>
    quantis-new/.agent/workflows/execute.md (rewrite)
  </files>
  <action>
    Merge old workflow's orchestration INTO the alias.
    
    Structure (~150 lines):
    1. Keep YAML frontmatter
    2. Add <role> + <objective> + <context> (with --gaps-only flag)
    3. Add <process> steps:
       - Step 1: Validate environment (ROADMAP, STATE, CONSTITUTION)
       - Step 2: Validate phase exists
       - Step 3: Discover plans (find *-PLAN.md, skip those with *-SUMMARY.md)
       - Step 4: --gaps-only filtering
       - Step 5: Group by wave (read frontmatter)
       - Step 6: Execute waves:
         - **"Read and follow executing-plans/SKILL.md (or subagent-driven-development/SKILL.md)"**
         - Constitutional compliance note
         - Commit per task
         - Create SUMMARY.md per plan
       - Step 7: Verify phase goal (check must-haves in codebase, not summaries)
       - Step 8: Route: PASS → update state / FAIL → gap closure plans
       - Step 9: Commit, offer next steps (routes A/B/C)
    4. Add <context_hygiene> (3-strike rule)
    5. Add <related> with updated skill references
    
    Key principle: Alias owns the ORCHESTRATION (waves, verification, state). Skill owns EXECUTION METHODOLOGY.
  </action>
  <verify>
    wc -l quantis-new/.agent/workflows/execute.md  # Should be ~140-160 lines
    grep "SUMMARY.md" quantis-new/.agent/workflows/execute.md  # Plan completion tracking
    grep "wave" quantis-new/.agent/workflows/execute.md  # Wave management
    grep "executing-plans/SKILL.md\|subagent-driven-development/SKILL.md" quantis-new/.agent/workflows/execute.md  # Skill delegation
    grep "gap_closure\|--gaps-only" quantis-new/.agent/workflows/execute.md  # Gap handling
  </verify>
  <done>execute.md has wave orchestration, plan discovery, verification, gap closure + skill delegation</done>
</task>

<task type="auto">
  <name>Thicken /stress-test alias with 7-dimension framework</name>
  <files>
    quantis-new/.agent/workflows/stress-test.md (rewrite)
  </files>
  <action>
    The 7-dimension adversarial review framework is the core value of /stress-test.
    The brainstorming skill provides general critique methodology but NOT this specific framework.
    
    Structure (~100 lines):
    1. Keep YAML frontmatter
    2. Add <role> + <objective>
    3. Add <context> (target: SPEC.md or specific file from $ARGUMENTS)
    4. Add <process> steps:
       - Step 1: Load context (SPEC.md, ROADMAP.md, DECISIONS.md)
       - Step 2: **"Read brainstorming/SKILL.md for critique methodology"** — skill sets the mindset
       - Step 3: Apply 7-dimension adversarial review:
         1. Completeness — Are all requirements addressed?
         2. Consistency — Do requirements contradict?
         3. Feasibility — Can this actually be built?
         4. Edge cases — What happens at boundaries?
         5. Security — What attack vectors exist?
         6. Performance — Will this scale?
         7. Maintainability — Can this be maintained long-term?
       - Step 4: Generate structured report with severity (Critical/High/Medium/Low)
       - Step 5: Offer auto-fix suggestions
       - Step 6: Update SPEC.md unresolved questions if needed
       - Step 7: Offer next steps
    5. Add <related>
  </action>
  <verify>
    wc -l quantis-new/.agent/workflows/stress-test.md  # Should be ~90-110 lines
    grep -c "Completeness\|Consistency\|Feasibility\|Edge cases\|Security\|Performance\|Maintainability" quantis-new/.agent/workflows/stress-test.md  # 7 dimensions
    grep "brainstorming/SKILL.md" quantis-new/.agent/workflows/stress-test.md  # Skill reference
  </verify>
  <done>stress-test.md has 7-dimension framework, severity ratings, auto-fix + skill delegation</done>
</task>

<task type="auto">
  <name>Thicken /discuss-phase, /research-phase, /update-plan aliases</name>
  <files>
    quantis-new/.agent/workflows/discuss-phase.md (rewrite ~60 lines)
    quantis-new/.agent/workflows/research-phase.md (rewrite ~60 lines)
    quantis-new/.agent/workflows/update-plan.md (rewrite ~60 lines)
  </files>
  <action>
    These three need moderate thickening.
    
    **discuss-phase.md (~60 lines):**
    - Add phase context loading from ROADMAP.md
    - Add structured discussion points (objectives, concerns, dependencies, risks)
    - Add decision documentation flow → DECISIONS.md
    - Keep brainstorming/SKILL.md delegation for ideation methodology
    - Add banners, next steps
    
    **research-phase.md (~60 lines):**
    - Add discovery level framework (L0-L3) from old workflow
    - Add structured RESEARCH.md template (Questions, Findings, Decisions, Patterns, Anti-Patterns, Dependencies, Risks)
    - Keep brainstorming/SKILL.md delegation for exploration methodology
    - Add "Ready for Planning" output
    - Add banners, commit, next steps
    
    **update-plan.md (~60 lines):**
    - Add validation (existing plans must exist)
    - Add current plan structure display
    - Add change tracking (what changed, why)
    - Add re-validation after revision
    - Keep writing-plans/SKILL.md delegation for plan methodology
    - Add banners, commit, next steps
  </action>
  <verify>
    for f in discuss-phase.md research-phase.md update-plan.md; do
      echo "$f: $(wc -l < quantis-new/.agent/workflows/$f) lines"
    done
    # Each should be ~50-70 lines
    grep "DECISIONS.md" quantis-new/.agent/workflows/discuss-phase.md  # Decision documentation
    grep "discovery\|L0\|Level 0\|RESEARCH.md" quantis-new/.agent/workflows/research-phase.md  # Discovery levels
    grep "re-validate\|Re-Validate\|changes" quantis-new/.agent/workflows/update-plan.md  # Change tracking
  </verify>
  <done>All 3 have Quantis orchestration at ~60 lines each + skill delegation</done>
</task>

<task type="auto">
  <name>Thicken /map alias (minor)</name>
  <files>
    quantis-new/.agent/workflows/map.md (rewrite ~40 lines)
  </files>
  <action>
    Minor thickening — the codebase-mapper skill already covers 90% of the old workflow.
    
    **map.md (~40 lines):**
    - Add project validation (is this a real project with source files?)
    - Add brownfield detection note
    - Keep codebase-mapper/SKILL.md delegation for analysis methodology
    - Add output location (.quantis/ARCHITECTURE.md, .quantis/STACK.md)
    - Add banners, commit, next steps (/plan suggested after)
  </action>
  <verify>
    wc -l quantis-new/.agent/workflows/map.md  # Should be ~35-45 lines
    grep "codebase-mapper/SKILL.md" quantis-new/.agent/workflows/map.md  # Skill reference
    grep "ARCHITECTURE.md\|STACK.md" quantis-new/.agent/workflows/map.md  # Output files
  </verify>
  <done>map.md has project validation, output paths + skill delegation</done>
</task>

## Success Criteria
- [ ] /plan.md: ~100-120 lines with planning lock, research, checker + writing-plans skill
- [ ] /execute.md: ~140-160 lines with wave orchestration, verification, gap closure + executing-plans skill
- [ ] /stress-test.md: ~90-110 lines with 7-dimension framework + brainstorming skill
- [ ] /discuss-phase.md: ~50-70 lines with phase context, decisions + brainstorming skill
- [ ] /research-phase.md: ~50-70 lines with discovery levels, RESEARCH.md + brainstorming skill
- [ ] /update-plan.md: ~50-70 lines with validation, change tracking + writing-plans skill
- [ ] /map.md: ~35-45 lines with project validation + codebase-mapper skill
- [ ] All 7 aliases reference their corresponding skill SKILL.md
- [ ] No old skill names remain (planner, executor, verifier, etc.)
