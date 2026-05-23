---
phase: 2
plan: 1
wave: 1
depends_on: []
---

# Plan 2.1: Create /update-plan Workflow

## Objective
Create the `/update-plan` workflow — the single deliverable of Phase 2. This workflow lets the user review generated plans, discuss concerns conversationally, and then apply revisions based on the discussion. It fills the gap between `/plan` (generates plans) and `/execute` (runs plans) where currently no revision path exists.

## Context
- .quantis/ROADMAP.md — Phase 2 definition
- .agent/workflows/plan.md — The `/plan` workflow that `/update-plan` extends
- .agents/skills/plan-checker/SKILL.md — Checker logic to re-validate after revisions
- .quantis/DECISIONS.md — Where Phase 2 decisions go

## Tasks

<task type="auto">
  <name>Create /update-plan workflow file</name>
  <files>.agent/workflows/update-plan.md</files>
  <action>
    Create `.agent/workflows/update-plan.md` following established workflow conventions:
    
    1. **Frontmatter**: `description: Review and revise plans based on discussion` and `argument-hint: "<phase-number>"`
    
    2. **Role block**: You are a Quantis plan reviser. You apply user-directed changes to existing PLAN.md files.
    
    3. **Objective block**: Apply conversational feedback to existing plans. This is NOT re-planning from scratch — it's surgical revision of existing plans based on user discussion.
    
    4. **Context block**: Phase number required. Existing plans must exist (run `/plan` first).
    
    5. **Process** (numbered steps):
       - Step 1: Validate phase exists and has plans (`ls .quantis/phases/$PHASE/*-PLAN.md`)
       - Step 2: Load all existing plans for the phase
       - Step 3: Display current plan summary (plan names, task counts, wave structure)
       - Step 4: Apply user's requested changes. This is conversational — read recent discussion context for what the user wants changed. Types of changes:
         - Reorder/restructure tasks
         - Split or merge plans
         - Change task scope or actions
         - Update verify/done criteria  
         - Add/remove tasks
         - Adjust wave assignments
       - Step 5: Re-run plan-checker validation (all 6 dimensions) on modified plans
       - Step 6: If checker fails, fix and re-validate (max 3 iterations)
       - Step 7: Show diff summary of what changed
       - Step 8: Commit updated plans
       - Step 9: Offer next steps (`/execute N` or continue discussion)
    
    6. **Mark as optional**: Add a note that this step is optional — users can go directly from `/plan` to `/execute` if satisfied.
    
    7. **Related section**: Link to `/plan`, `/execute`, `/discuss-phase`, and plan-checker skill.
    
    Keep the workflow lean (~120-150 lines). Follow the exact formatting conventions of existing workflows (XML-style blocks, bash code blocks, banner formatting).
  </action>
  <verify>
    - File exists: `test -f .agent/workflows/update-plan.md`
    - Has frontmatter: `head -3 .agent/workflows/update-plan.md | grep "description:"`
    - Has process steps: `grep -c "^## [0-9]" .agent/workflows/update-plan.md` returns at least 5
    - References plan-checker: `grep -c "plan-checker" .agent/workflows/update-plan.md` returns at least 1
    - Marked as optional: `grep -ci "optional" .agent/workflows/update-plan.md` returns at least 1
  </verify>
  <done>
    - `/update-plan` workflow file exists at `.agent/workflows/update-plan.md`
    - Workflow has complete process (validate → load → display → revise → re-check → commit)
    - Plan-checker re-validation is integrated
    - Workflow is marked as optional in the flow
    - Follows existing workflow conventions (frontmatter, role, objective, context, process, related)
  </done>
</task>

<task type="auto">
  <name>Document Phase 2 decisions</name>
  <files>.quantis/DECISIONS.md</files>
  <action>
    Append Phase 2 decisions to `.quantis/DECISIONS.md`:
    
    ```markdown
    ---
    
    ## Phase 2 Decisions (Plan Iteration)
    
    **Date:** 2026-05-10
    **Context:** Discussion before planning Phase 2. Evaluated scope of `/update-plan` and `/checklist` workflows.
    
    ### D-012: Drop /checklist — Redundant
    **Decision:** Remove `/checklist` from Phase 2 scope. The plan-checker already runs automatically inside `/plan` (step 7) and would also run inside `/update-plan`. A standalone `/checklist` command solves no real problem.
    **Rationale:** The plan-checker is already integrated at every point where validation matters. Exposing it as a separate command adds surface area with no benefit.
    
    ### D-013: /update-plan — Conversational Revision
    **Decision:** `/update-plan` is a conversational revision workflow: user discusses concerns naturally, then runs `/update-plan N` to apply the discussed changes and re-validate.
    **Rationale:** The natural flow is: `/plan` generates → user reads and has doubts → discuss → `/update-plan` applies changes. This is simpler and more natural than a formal review-with-diff interface.
    
    ### D-014: /update-plan — Optional Step
    **Decision:** `/update-plan` is explicitly optional. Users can go directly from `/plan` to `/execute` if satisfied with the generated plans.
    **Rationale:** Most plans don't need revision. Adding a mandatory review step would slow down the workflow for the common case.
    ```
    
    Do NOT modify existing decisions — only append.
  </action>
  <verify>
    - Decisions exist: `grep "D-012" .quantis/DECISIONS.md`
    - All three new decisions present: `grep -c "D-01[234]" .quantis/DECISIONS.md` returns 3
    - Phase 2 header present: `grep "Phase 2 Decisions" .quantis/DECISIONS.md`
  </verify>
  <done>
    - D-012 (Drop /checklist), D-013 (/update-plan conversational), D-014 (/update-plan optional) documented
    - Appended to existing DECISIONS.md without modifying Phase 1 decisions
  </done>
</task>

## Success Criteria
- [ ] `/update-plan` workflow file exists and follows conventions
- [ ] Plan-checker re-validation is wired into the workflow
- [ ] Phase 2 decisions (D-012, D-013, D-014) documented
- [ ] Workflow explicitly marked as optional
