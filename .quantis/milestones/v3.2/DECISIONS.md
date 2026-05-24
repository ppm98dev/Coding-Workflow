# Decisions

> Previous milestone decisions archived in `.quantis/milestones/v3.1/DECISIONS.md`

---

### D-026: Dynamic Custom Skill and MCP Context Injection
**Decision:** Implement Approach B by adding an automated discovery and context injection step inside the `/plan` workflow (`.agent/workflows/plan.md`). Before delegating to the `writing-plans` skill, the workflow will scan for custom skills (excluding core manifest skills) and active MCP servers, printing a summary to inject them directly into the agent's short-term context.
**Rationale:** Keeps the imported Superpowers skills clean and easily upgradable from upstream sources, while guaranteeing that the planning agent is aware of all custom skills (e.g. from skills.sh) and active MCP servers during plan generation.

