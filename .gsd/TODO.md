# TODO.md — Quick Capture

## Pending

### v2.1 — Dead Code Prevention (researched)
- [ ] Add `<remove>` tag to PLAN.md task XML (see `.gsd/phases/5/RESEARCH.md`)
- [ ] Add Executor Rule 5: "Auto-clean dead code" to `/execute`
- [ ] Add code growth audit check to `/verify`

### Ideas from github/spec-kit (93.6k ⭐)
> Source: https://github.com/github/spec-kit — study their repo for patterns to adopt

- [ ] **Constitution concept** — A `CONSTITUTION.md` with project-level principles that persist across ALL phases. GSD's `SPEC.md` covers requirements but not governance/values. Spec-Kit creates `.specify/memory/constitution.md` that the agent always references. Could improve `/new-project` with a constitution step.
- [ ] **Extension/plugin system** — Spec-Kit has `specify extension add <name>` with a community catalog. GSD skills are close but not installable/removable. Could add `scripts/add-skill.sh <url>` to fetch community skills from GitHub.
- [ ] **Preset system** — Overrides templates/commands without changing core. Stack multiple presets with priority. GSD has no customization layer — you either use the defaults or edit files directly. Could add a `.gsd/presets/` override directory.
- [ ] **`/speckit.clarify` (quiz mode)** — Asks the user targeted questions to expose gaps in the spec. GSD's `/new-project` does deep questioning but there's no post-spec "stress test" command. Could add `/stress-test-spec`.
- [ ] **`/speckit.checklist`** — Pre-implementation validation checklist. Similar to GSD's plan-checker skill but exposed as a user-facing command.
- [ ] **Multi-agent integration at install time** — `specify init . --integration gemini` generates agent-specific config. GSD has adapters but install.sh doesn't auto-configure per agent.

### Other
- [ ] Check if upstream `gsd-build/get-shit-done` has newer features to backport
- [ ] Consider adding a `/self-test` workflow that validates GSD works on itself
- [ ] Investigate token measurement APIs in Antigravity for context-health-monitor
- [ ] Explore MCP integration for enhanced tool calling

## Done
- [x] Clone repo and commit baseline
- [x] Run /map and create ARCHITECTURE.md + STACK.md
- [x] Run /new-project and create SPEC, ROADMAP, STATE
