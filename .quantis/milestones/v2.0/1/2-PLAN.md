---
phase: 1
plan: 2
wave: 1
---

# Plan 1.2: Update Model Capabilities

## Objective
Update `model_capabilities.yaml` with real model names as examples while keeping the category-based structure (per ADR-003). This makes the file immediately actionable instead of requiring users to guess which models fit which profile.

## Context
- .quantis/SPEC.md
- .quantis/RESEARCH.md (Model Support section — current models as of April 2026)
- .quantis/DECISIONS.md (ADR-003: category + examples pattern)
- model_capabilities.yaml (current file)

## Tasks

<task type="auto">
  <name>Update model_capabilities.yaml with real model examples</name>
  <files>model_capabilities.yaml</files>
  <action>
    Update the `examples` field under each profile to include real model names alongside the generic descriptions. Keep the category structure intact.

    Changes:
    1. `fast_coder.examples`:
       - Replace "Flash/Turbo variants" → "Gemini 2.5 Flash, Claude Haiku, GPT-4.1 Mini"
       - Replace "Smaller parameter models" → "Any fast-response model optimized for throughput"

    2. `standard.examples`:
       - Replace "Pro/Standard variants" → "Gemini 2.5 Pro, Claude Sonnet 4.6, GPT-4.1"
       - Replace "Mid-tier models" → "Balanced speed/quality models with large context"

    3. `reasoning.examples`:
       - Replace "Thinking/Reasoning variants" → "Gemini 2.5 Pro (thinking mode), Claude Opus 4, o3"
       - Replace "Advanced reasoning models" → "Models with extended reasoning / chain-of-thought"

    4. Add a comment at the top of the examples section:
       ```yaml
       # Model examples current as of April 2026.
       # Update periodically — these are illustrative, not exhaustive.
       ```

    5. Keep ALL other fields unchanged (capabilities, phase_recommendations, etc.)

    Do NOT add or remove any profiles. Do NOT change the structure. Only update the `examples` arrays and add the date comment.
  </action>
  <verify>grep -A2 "examples:" model_capabilities.yaml | head -20</verify>
  <done>All three profiles show real model names. Date comment present. Structure unchanged. File still valid YAML.</done>
</task>

## Success Criteria
- [ ] model_capabilities.yaml has real model names in all 3 profiles
- [ ] Date comment added for freshness tracking
- [ ] File structure and all non-example fields unchanged
- [ ] Valid YAML (no syntax errors)
