# Phase 2.1: Dynamic Skill and MCP Context Injection - SPEC.md

> **Status**: `FINALIZED`

## Goal
Implement dynamic custom skill and MCP discovery and context injection inside the Quantis planning workflows to leverage third-party ecosystem tools (e.g. from skills.sh and active MCP servers) without breaking core skill upgradability.

## Deliverables
1. **Dynamic Custom Skill Discovery:**
   - In `.agent/workflows/plan.md`, add Bash code to scan the `.agents/skills/` directory.
   - Cross-reference with `MANIFEST.md` to identify only *custom* skills installed by the user (e.g. from skills.sh or custom written), excluding the 18 core manifest skills.
   - Generate a clean list of these custom skills with their names and descriptions.

2. **Active MCP Server Detection:**
   - In `.agent/workflows/plan.md`, add Bash code or environment inspections to detect available MCP servers and tools registered in the current Antigravity environment.
   - Generate a clean summary list of these MCP servers/tools.

3. **Planning Context Injection Block:**
   - Format a beautiful printout inside the terminal right before delegating to `writing-plans`.
   - The printout will list all discovered custom skills and MCP servers, injecting them directly into the agent's short-term context.
   - For example:
     ```
     💡 DISCOVERED ECOSYSTEM ASSETS:
     Skills:
       - langfuse-tracing: Use whenever implementing external LLM calls or agent loops
     MCP Servers:
       - StitchMCP: Eager tools for screen management and creations
       - notion-mcp-server: Lazily loaded Notion API tools
       - sequential-thinking: Advanced structured reasoning
     ```
   - Direct the planning agent to review and utilize these assets in the plan rather than writing redundant custom code.

## Success Criteria
- [ ] Running `/plan 2.1` dynamically scans, parses, and prints out the discovered custom skills and active MCP servers.
- [ ] Discovered items are successfully injected into the agent's short-term memory prior to plan generation.
- [ ] Custom skills and MCP tools are appropriately suggested in the generated execution plan (`2.1-PLAN.md`) without modifications to core skills.
