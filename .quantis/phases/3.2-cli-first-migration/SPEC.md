# Phase 3.2: CLI-First Migration — SPEC

> **Status**: FINALIZED
> **Created**: 2026-06-11
> **Scope**: Folder consolidation + 49 files across workflows, skills, docs, scripts
> **Independent from**: Phase 3.1 (reliability fixes are separate, not folded in)

---

## Problem Statement

Quantis was built for Antigravity IDE. The file structure assumes two discovery paths:

- `.agent/workflows/*.md` — IDE discovers these as slash commands
- `.agents/skills/*/SKILL.md` — All platforms discover these as slash commands

The CLI (`agy`) cannot read `.agent/workflows/` at all. A hack was introduced (30 `wf-*` symlink directories in `.agents/skills/`) to bridge this gap. This creates:

1. **Two sources of truth** — real files in `.agent/`, symlinks in `.agents/skills/`
2. **Fragile symlinks** — break on Windows, some git configs, shallow clones
3. **Confusing structure** — developers see both folders and don't know which is canonical
4. **IDE-first assumptions** — SDD skill assumes subagents may not exist; should assume they DO exist (CLI-first)

### Platform Matrix (verified)

| Feature | IDE | CLI (`agy`) | Standalone |
|---------|:---:|:-----------:|:----------:|
| `invoke_subagent` | ❌ | ✅ | ✅ |
| `define_subagent` | ❌ | ✅ | ✅ |
| `browser_subagent` | ✅ | ❌ | `/browser` |
| `.agent/workflows/` discovery | ✅ | ❌ | ✅ |
| `.agents/skills/` discovery | ✅ | ✅ | ✅ |

**Key insight**: `.agents/skills/` is the ONLY directory discovered by ALL three platforms. Everything should live there.

---

## Design Decisions

### D-001: CLI-First, Not CLI-Compatible

**Decision**: All workflows and skills are written assuming **CLI capabilities** (subagents exist). IDE gets graceful degradation.

**Rationale**: CLI has the stronger feature set (`invoke_subagent`). Superpowers (our upstream) assumes subagents exist natively. Writing for the weaker platform (IDE) and "upgrading" is backwards.

### D-002: Single Folder — `.agents/skills/` Only

**Decision**: Move all workflows from `.agent/workflows/` into `.agents/skills/wf-*/SKILL.md` as **real files** (not symlinks). Delete `.agent/` entirely.

**Rationale**: `.agents/skills/` is universal. One folder, one discovery mechanism, all platforms. The `wf-` prefix provides taxonomy (workflows vs skills) without needing separate directories.

### D-003: `wf-` Prefix as Taxonomy

**Decision**: Keep the `wf-` prefix on workflow skill directories to distinguish them from methodology skills.

**Rationale**: Users type `/wf-plan` and know it's a user-facing workflow (orchestration command). The agent reads `writing-plans` and knows it's a methodology skill (auto-triggered). The prefix makes the distinction visible in the filesystem.

### D-004: Capability-Based Detection

**Decision**: Workflows detect platform capabilities by checking tool availability at runtime — NOT by hardcoding platform names.

**Rationale**: Forward-compatible. If a future platform adds `invoke_subagent`, it automatically gets SDD. Detection pattern:
- `invoke_subagent` in tool list → use SDD with real subagents
- `browser_subagent` in tool list → use browser verification
- Neither → use inline execution with self-review, skip browser verification

### D-005: Unified Adapter

**Decision**: Update `adapters/ANTIGRAVITY.md` to cover all three platforms with a single platform matrix. No separate adapter per platform.

**Rationale**: One file, one source of truth. Platform-specific behavior is handled by capability detection in each workflow/skill, not by the adapter.

### D-006: Subagents Everywhere

**Decision**: When `invoke_subagent` is available, use subagents for ALL major Quantis workflow stages — not just execution. This means:

| Workflow | Subagent Role | Purpose |
|----------|--------------|----------|
| `/wf-discuss-phase` | `research` subagent | Explore codebase, gather context, propose approaches — then return findings to the orchestrator for user discussion |
| `/wf-plan` | `self` subagent | Read the SPEC, follow `writing-plans` skill, produce the PLAN.md — orchestrator reviews output |
| `/wf-stress-test` | `self` subagent | Read the SPEC/PLAN, follow adversarial critique methodology, produce findings — orchestrator presents to user |
| `/wf-execute` | SDD (multiple subagents) | Already planned — implementer + spec-reviewer + code-quality-reviewer per task |
| `/wf-verify` | `self` subagent | Read the SPEC must-haves, verify against codebase, produce VERIFICATION.md — orchestrator reviews |

**Rationale**: This mirrors how Superpowers uses Claude Code's `Task` tool throughout the entire lifecycle. Subagents provide:
- **Fresh context** per stage (no context pollution from previous stages)
- **Focused execution** (subagent only sees what it needs)
- **Orchestrator stays light** (preserves context budget for coordination)
- **Quality gates** (orchestrator reviews subagent output before proceeding)

**IDE fallback**: When `invoke_subagent` is NOT available, all workflows execute inline (current behavior). No degradation in methodology — just no context isolation.

---

## Architecture: Before & After

### Before

```
.agent/
└── workflows/                  # 30 .md files (IDE-only discovery)
    ├── plan.md
    ├── execute.md
    ├── verify.md
    └── ... (27 more)

.agents/
├── skills/                     # 18 real skill dirs + 30 symlink dirs
│   ├── brainstorming/          # Real skill
│   ├── writing-plans/          # Real skill
│   ├── wf-plan/SKILL.md       # SYMLINK → ../../.agent/workflows/plan.md
│   ├── wf-execute/SKILL.md    # SYMLINK → ../../.agent/workflows/execute.md
│   └── ... (46 more)
└── rules/
    └── PROJECT_RULES.md        # SYMLINK → ../../PROJECT_RULES.md
```

### After

```
.agents/
├── skills/                     # 18 real skill dirs + 30 real workflow dirs
│   ├── brainstorming/          # Real skill (unchanged)
│   ├── writing-plans/          # Real skill (unchanged)
│   ├── wf-plan/SKILL.md       # REAL FILE (was symlink, now contains plan.md content)
│   ├── wf-execute/SKILL.md    # REAL FILE (was symlink, now contains execute.md content)
│   └── ... (46 more)
└── rules/
    └── PROJECT_RULES.md        # SYMLINK → ../../PROJECT_RULES.md (kept)

.agent/                         # DELETED
```

---

## Deliverables — Exhaustive File-by-File Specification

### Deliverable 1: Folder Consolidation

**Objective**: Replace all 30 `wf-*` symlinks with real files containing the workflow content, then delete `.agent/workflows/` and the `.agent/` directory.

**Actions**:

1. For each of the 30 workflows in `.agent/workflows/*.md`:
   - Read the real file content
   - Write it to `.agents/skills/wf-{name}/SKILL.md` (overwriting the symlink)
   - The `{name}` matches the original filename without `.md` extension
2. Delete `.agent/workflows/` directory
3. Delete `.agent/` directory (should be empty after step 2)
4. Verify all 30 `wf-*/SKILL.md` files exist and are real files (not symlinks)

**Current 30 workflows** (becoming `wf-{name}/SKILL.md`):

```
add-phase, add-todo, audit-milestone, check-todos, complete-milestone,
debug-issue, discuss-phase, execute, insert-phase, install,
list-phase-assumptions, map, new-milestone, new-project, pause,
plan-milestone-gaps, plan, progress, quantis-help, remove-phase,
research-phase, resume-session, sprint, stress-test, update-plan,
update, upgrade, verify, web-search, whats-new
```

**Acceptance Criteria**:
- `.agent/` directory does not exist
- All 30 `wf-*/SKILL.md` files are real files (`test -L` returns false)
- `ls .agents/skills/ | grep wf- | wc -l` returns 30
- All skill metadata (YAML frontmatter) is preserved

---

### Deliverable 2: SDD Skill — CLI-First with Inline Fallback

**File**: `.agents/skills/subagent-driven-development/SKILL.md`

**Current state**: Assumes `invoke_subagent` exists unconditionally. Section "Session Setup (Antigravity 2.0)" directly calls `define_subagent` without checking availability.

**Changes**:

1. **Add "Platform Detection" section** after the opening description (after line ~14):
   ```
   ## Platform Detection

   Before starting SDD, check your environment:

   1. Check if `invoke_subagent` tool is available in your current toolset
   2. If available (CLI, Standalone): Proceed with full SDD — dispatch
      real subagents via `invoke_subagent`
   3. If NOT available (IDE): Use inline SDD mode — execute each task
      yourself in sequence, but preserve the two-stage review structure:
      - Execute the task (as the implementer)
      - Self-review against spec (as the spec reviewer)
      - Self-review for code quality (as the code quality reviewer)
      - This preserves SDD's quality gates without subagent dispatch

   Do not ask the user which mode to use. Check tool availability and
   proceed automatically.
   ```

2. **Make "Session Setup" section conditional**:
   ```
   ## Session Setup

   **If `invoke_subagent` is available**, define the named subagent types
   at session start:
   [existing define_subagent code block — unchanged]

   **If `invoke_subagent` is NOT available**, skip session setup — you
   will execute tasks inline with self-review gates.
   ```

3. **Keep all other sections unchanged** — the process flow, model selection, handling status, prompt templates, red flags, integration, and state integration sections all remain as-is. The inline mode follows the same logical flow, just without dispatching actual subagents.

**Acceptance Criteria**:
- `grep "Platform Detection" .agents/skills/subagent-driven-development/SKILL.md` matches
- `grep "invoke_subagent.*available" .agents/skills/subagent-driven-development/SKILL.md` matches
- `grep "inline SDD" .agents/skills/subagent-driven-development/SKILL.md` matches
- `grep "Do not ask" .agents/skills/subagent-driven-development/SKILL.md` matches

---

### Deliverable 3: `wf-execute` — Deterministic SDD Selection

**File**: `.agents/skills/wf-execute/SKILL.md`

**Current state** (line 72): `When subagents are available, prefer .agents/skills/subagent-driven-development/SKILL.md`

**Changes**:

1. **Replace lines 71-72** (execution methodology) with deterministic capability-based selection:
   ```
   2. **Select execution methodology (automatic — do NOT ask the user):**
      - Check if `invoke_subagent` tool is available in your current environment
      - **If available**: Read and follow `.agents/skills/subagent-driven-development/SKILL.md`.
        Announce: "I'm using Subagent-Driven Development to execute this plan."
      - **If NOT available**: Read and follow `.agents/skills/executing-plans/SKILL.md`.
      - This is NOT a choice. Do not present a menu. Do not ask.
   ```

2. **Add sequential clarification note** after the methodology selection:
   ```
   > **Note:** SDD executes tasks sequentially — one subagent per task, one at a
   > time. It is not about parallelism. It is about fresh context per task and
   > two-stage review gates (spec compliance → code quality).
   ```

3. **Update `<related>` section** (line 137): Remove "preferred when subagents available" — change to "default execution methodology (CLI-first)"

4. **Update header comment** (line 8): Change "or `subagent-driven-development` when subagents are available" to reflect the deterministic approach

**Acceptance Criteria**:
- `grep "prefer" .agents/skills/wf-execute/SKILL.md` returns NO matches related to SDD
- `grep "invoke_subagent" .agents/skills/wf-execute/SKILL.md` shows capability check
- `grep "Do not present a menu" .agents/skills/wf-execute/SKILL.md` matches
- `grep "sequentially" .agents/skills/wf-execute/SKILL.md` matches

---

### Deliverable 4: `wf-verify` — Browser Subagent Graceful Fallback

**File**: `.agents/skills/wf-verify/SKILL.md`

**Current state**: Lines 82-83, 108, 268 reference `browser_subagent` unconditionally.

**Changes**:

1. **Add capability check** before the browser verification section (around line 108):
   ```
   **Browser Verification (capability-dependent):**
   If `browser_subagent` tool is available in your current environment, use it
   for UI verification as described below. If NOT available, use CLI-based
   evidence instead (command output, curl responses, test results).
   ```

2. **Update the verification evidence table** (around line 82-83, 268) to show both paths:
   ```
   | UI (with browser_subagent) | browser_subagent screenshot + recording |
   | UI (without browser_subagent) | CLI verification: curl, test output, or manual user confirmation |
   ```

3. **Do NOT remove** any existing `browser_subagent` instructions — just make them conditional

**Acceptance Criteria**:
- `grep "browser_subagent.*available" .agents/skills/wf-verify/SKILL.md` matches
- Both browser-based and CLI-based evidence paths are documented
- Existing browser verification instructions remain intact (just gated)

---

### Deliverable 5: `wf-quantis-help` — CLI Command Convention

**File**: `.agents/skills/wf-quantis-help/SKILL.md`

**Current state**: Shows `/command` format only. No mention of `wf-` prefix.

**Changes**:

1. **Add CLI section** after the main command listing (after "UTILITIES" section, before the closing banner):
   ```
   CLI USERS (agy)
   ────────────────
   On Antigravity CLI, ALL commands use the /wf- prefix:

     /wf-plan, /wf-execute, /wf-verify, /wf-pause, etc.

   Skills work as direct slash commands without prefix:
     /brainstorming, /writing-plans, /systematic-debugging, etc.

   The /wf- prefix distinguishes workflow commands (user-facing
   orchestration) from skill commands (agent methodology).
   ```

2. **Add footer note**:
   ```
   💡 CLI: prefix all workflow commands with /wf-
      Example: /wf-plan 1 instead of /plan 1
   ```

**Acceptance Criteria**:
- `grep "wf-" .agents/skills/wf-quantis-help/SKILL.md` matches
- `grep "CLI" .agents/skills/wf-quantis-help/SKILL.md` matches
- Standard format still shown for IDE/Standalone users

---

### Deliverable 6: `wf-install` — Updated File Paths

**File**: `.agents/skills/wf-install/SKILL.md`

**Current state**: Step 3 copies `.agent/` directory. Confirmation lists `.agent/` as installed.

**Changes**:

1. **Remove** from Step 3 copy commands:
   ```diff
   - cp -r .quantis-install-temp/.agent ./
   ```
   (Workflows are already inside `.agents/skills/wf-*/` — no separate `.agent/` folder exists)

2. **Update Step 6 confirmation** to remove `.agent/` line and note the `wf-` convention:
   ```diff
   - • .agent/        (30 workflows)
   + • .agents/skills/wf-*  (30 workflow commands)
   ```

3. **Add a note** explaining the unified structure:
   ```
   > All workflows live in `.agents/skills/wf-*/SKILL.md` alongside methodology
   > skills. This unified structure works on IDE, CLI, and Standalone without
   > platform-specific setup.
   ```

**Acceptance Criteria**:
- `grep ".agent/" .agents/skills/wf-install/SKILL.md` returns NO matches (except `.agents/` which is fine)
- `grep "wf-" .agents/skills/wf-install/SKILL.md` matches
- No reference to copying a `.agent/` folder

---

### Deliverable 7: `adapters/ANTIGRAVITY.md` — Unified Platform Documentation

**File**: `adapters/ANTIGRAVITY.md`

**Current state**: Line 7 says "inside Google Antigravity IDE". Only covers IDE features.

**Changes**:

1. **Update header** (line 7):
   ```diff
   - This adapter provides Antigravity-specific enhancements for running Quantis
   -   inside Google Antigravity IDE.
   + This adapter provides Antigravity-specific enhancements for running Quantis
   +   across all Antigravity platforms (IDE, CLI, Standalone).
   ```

2. **Add "Platform Compatibility" section** after the header, before "Subagent Support":
   ```
   ## Platform Compatibility

   Quantis works across all three Antigravity platforms:

   | Feature | IDE | CLI (`agy`) | Standalone |
   |---------|:---:|:-----------:|:----------:|
   | `invoke_subagent` | ❌ | ✅ | ✅ |
   | `browser_subagent` | ✅ | ❌ | `/browser` |
   | Skills as `/commands` | ✅ | ✅ | ✅ |
   | Workflow commands | `/plan` | `/wf-plan` | `/plan` |

   ### CLI Command Convention

   On CLI (`agy`), workflow commands use the `/wf-` prefix:
   - IDE/Standalone: `/plan 1` → CLI: `/wf-plan 1`
   - Skill commands work the same on all platforms: `/brainstorming`

   ### Capability-Based Detection

   Workflows detect platform capabilities at runtime — not by platform name:
   - `invoke_subagent` available? → use SDD with real subagents
   - `browser_subagent` available? → use browser verification
   - This ensures forward compatibility with new platforms
   ```

3. **Update "Browser Subagent" section** to note availability:
   ```diff
   - The `browser_subagent` is Antigravity's specialized verification tool.
   + The `browser_subagent` is available on IDE only (Standalone uses the
   + `/browser` platform command). Workflows that reference it gracefully
   + skip browser verification when unavailable.
   ```

4. **Update "Subagent Support" section** to note `invoke_subagent` is CLI/Standalone only:
   ```
   > **Note:** `invoke_subagent` and `define_subagent` are available on CLI and
   > Standalone only. On IDE, SDD falls back to inline execution with self-review
   > gates. See the `subagent-driven-development` skill for details.
   ```

**Acceptance Criteria**:
- `grep "Platform Compatibility" adapters/ANTIGRAVITY.md` matches
- `grep "wf-" adapters/ANTIGRAVITY.md` matches
- `grep "CLI" adapters/ANTIGRAVITY.md` matches
- `grep "capability" adapters/ANTIGRAVITY.md` matches (case-insensitive)

---

### Deliverable 8: `README.md` — Supported Platforms + CLI Quick Start

**File**: `README.md`

**Changes**:

1. **Update directory structure** (around line 144):
   ```diff
   - .agent/workflows/     30 slash command workflows
   + (no .agent/ folder — workflows live in .agents/skills/wf-*/)
   ```

2. **Add "Supported Platforms" section**:
   ```
   ## Supported Platforms

   | Platform | Command Prefix | Subagents | Browser |
   |----------|---------------|:---------:|:-------:|
   | **IDE** (Antigravity IDE) | `/command` | ❌ inline | ✅ `browser_subagent` |
   | **CLI** (`agy`) | `/wf-command` | ✅ `invoke_subagent` | ❌ |
   | **Standalone** (Antigravity 2.0) | `/command` | ✅ `invoke_subagent` | ✅ `/browser` |

   All workflows and skills live in `.agents/skills/`. No platform-specific
   setup needed after install.
   ```

3. **Add "CLI Quick Start"**:
   ```
   ### CLI Quick Start (agy)

   ```bash
   agy                           # Start Antigravity CLI
   /wf-new-project              # Initialize with deep questioning
   /wf-plan 1                   # Create Phase 1 plans
   /wf-execute 1                # Execute (uses real subagents!)
   /wf-verify 1                 # Verify implementation
   ```
   ```

**Acceptance Criteria**:
- `grep "Supported Platforms" README.md` matches
- `grep "wf-" README.md` matches
- `grep ".agent/workflows" README.md` returns NO matches
- `grep "CLI Quick Start" README.md` matches

---

### Deliverable 9: Root Documentation Updates

#### 9a: `PROJECT_RULES.md`

**Lines 163-164**: Update repository structure:
```diff
- .agent/
- └── workflows/            # Slash commands (/plan, /execute, etc.)
-
  .agents/
- └── skills/               # Agent specializations (Agent Skills standard)
+ └── skills/               # Workflows (wf-*) + methodology skills
+     ├── wf-plan/         # Workflow: /plan (or /wf-plan on CLI)
+     ├── wf-execute/      # Workflow: /execute
+     ├── brainstorming/    # Skill: auto-triggered methodology
+     └── writing-plans/    # Skill: auto-triggered methodology
```

#### 9b: `QUANTIS-STYLE.md`

**Line 19**: Update section header:
```diff
- ### Workflows (`.agent/workflows/*.md`)
+ ### Workflows (`.agents/skills/wf-*/SKILL.md`)
```

Update description to explain the `wf-` naming convention:
```
Slash commands the user invokes. Each workflow:
- Lives in `.agents/skills/wf-{name}/SKILL.md`
- Has YAML frontmatter with `description`
- Contains XML-structured process blocks
- Ends with "Next Steps" routing
- The `wf-` prefix distinguishes workflows from methodology skills
```

#### 9c: `MANIFEST.md`

**Line 8**: Update section:
```diff
- ### Workflows (`.agent/workflows/` — 30 files)
- - add-phase.md
- - add-todo.md
+ ### Workflows (`.agents/skills/wf-*/` — 30 directories)
+ - wf-add-phase
+ - wf-add-todo
  ...
```

All 30 entries updated from `{name}.md` to `wf-{name}`.

#### 9d: `CHANGELOG.md`

Add new entry at top:
```markdown
## v3.3 — CLI-First Migration

- **BREAKING**: `.agent/workflows/` directory removed — all workflows now live
  in `.agents/skills/wf-*/SKILL.md`
- CLI (`agy`) is now the primary platform — SDD is the default execution path
- Capability-based platform detection (no hardcoded platform names)
- `browser_subagent` graceful fallback when unavailable
- Unified `adapters/ANTIGRAVITY.md` covers IDE, CLI, and Standalone
- `wf-` prefix as taxonomy: workflows vs methodology skills
```

**Acceptance Criteria**:
- `grep ".agent/" PROJECT_RULES.md` returns NO matches (only `.agents/`)
- `grep "wf-" QUANTIS-STYLE.md` matches
- `grep "wf-" MANIFEST.md` shows 30 entries
- CHANGELOG.md has v3.3 entry

---

### Deliverable 10: Script Updates

#### 10a: `scripts/validate-workflows.sh`

**Line 14**: Update glob pattern:
```diff
- for file in .agent/workflows/*.md; do
+ for file in .agents/skills/wf-*/SKILL.md; do
```

**Line 16**: Update filename extraction:
```diff
- filename=$(basename "$file")
+ dirname=$(basename "$(dirname "$file")")
+ filename="${dirname#wf-}"
```

#### 10b: `scripts/install.sh`

**Line 33**: Remove `.agent/workflows` from mkdir:
```diff
- mkdir -p .agent/workflows .agents/skills .gemini .quantis adapters docs scripts
+ mkdir -p .agents/skills .gemini .quantis adapters docs scripts
```

**Line 36**: Remove `.agent/` copy:
```diff
- cp -r "$TEMP_DIR/.agent/" ./
```

(Workflows are already inside `.agents/skills/wf-*/` in the source repo)

#### 10c: `scripts/upgrade.sh`

**Line 80**: Remove `.agent/workflows` from mkdir:
```diff
- mkdir -p .agent/workflows .agents/skills .gemini .quantis/templates adapters docs scripts
+ mkdir -p .agents/skills .gemini .quantis/templates adapters docs scripts
```

**Lines 104-105**: Remove `.agent/workflows` copy:
```diff
- rm -rf .agent/workflows
- cp -r "$TEMP_DIR/.agent/workflows" .agent/
```

**Line 178**: Update summary:
```diff
- echo -e "  • Workflows updated: $(ls .agent/workflows/ | wc -w | xargs)"
+ echo -e "  • Workflows updated: $(ls -d .agents/skills/wf-* 2>/dev/null | wc -l | xargs)"
```

**Acceptance Criteria**:
- `grep ".agent/" scripts/validate-workflows.sh` returns NO matches
- `grep ".agent/" scripts/install.sh` returns NO matches (only `.agents/`)
- `grep ".agent/workflows" scripts/upgrade.sh` returns NO matches
- `bash scripts/validate-workflows.sh` passes on new structure

---

### Deliverable 11: `using-quantis` Skill — CLI Note

**File**: `.agents/skills/using-quantis/SKILL.md`

**Changes**:

1. **Update "How to Access Skills" section** (line 26):
   ```diff
   - **In Antigravity 2.0:** Skills are auto-discovered from `.agents/skills/*/SKILL.md`.
   + **All Antigravity platforms:** Skills and workflows are auto-discovered from
   + `.agents/skills/*/SKILL.md`. On CLI (`agy`), workflow commands use the `/wf-`
   + prefix (e.g., `/wf-plan 1`). Methodology skills work the same everywhere.
   ```

2. **Update "Workflow Commands" table** (lines 104-119) — add a note below the table:
   ```
   > **CLI users:** Prefix workflow commands with `/wf-`. Example: `/wf-plan 1`
   > instead of `/plan 1`. Skill commands (like `/brainstorming`) work without prefix.
   ```

**Acceptance Criteria**:
- `grep "wf-" .agents/skills/using-quantis/SKILL.md` matches
- `grep "CLI" .agents/skills/using-quantis/SKILL.md` matches

---

### Deliverable 12: `wf-update` and `wf-upgrade` — Path Updates

#### 12a: `wf-update/SKILL.md`

Update all references from `.agent/workflows/` to `.agents/skills/wf-*/`:
- MANIFEST-aware workflow replacement logic (around line 95)
- Summary output counting workflows

#### 12b: `wf-upgrade/SKILL.md`

Update all references:
- Line 80: `mkdir -p .agent/workflows` → remove
- Lines 104-105: `.agent/workflows` copy → remove
- Line 178: workflow count → `wf-*` pattern

#### 12c: `wf-plan/SKILL.md`

- Lines 91-92: MANIFEST cross-reference for custom skill detection — update path if it references `.agent/workflows/`

**Acceptance Criteria**:
- `grep ".agent/" .agents/skills/wf-update/SKILL.md` returns NO matches (only `.agents/`)
- `grep ".agent/" .agents/skills/wf-upgrade/SKILL.md` returns NO matches (only `.agents/`)

---

### Deliverable 13: Subagent-Powered Workflows

All five major workflows get subagent dispatch when `invoke_subagent` is available.

#### 13a: `wf-discuss-phase/SKILL.md`

**Current state**: Runs brainstorming inline.

**Changes**:

1. **Add capability check** at the start of the process, before Step 1:
   ```
   ## 0. Platform Check
   If `invoke_subagent` is available, dispatch a `research` subagent to:
   - Explore the codebase (file structure, recent commits, relevant code)
   - Read the phase definition from ROADMAP.md
   - Gather context about dependencies and constraints
   - Return a structured context brief

   Then use the returned brief to inform the brainstorming discussion
   with the user. If `invoke_subagent` is NOT available, gather this
   context yourself inline.
   ```

2. The brainstorming conversation with the user stays inline (it's interactive — can't be delegated to a subagent). The subagent only handles the research/context-gathering step.

**Acceptance Criteria**:
- `grep "invoke_subagent" .agents/skills/wf-discuss-phase/SKILL.md` matches
- `grep "research" .agents/skills/wf-discuss-phase/SKILL.md` shows subagent type
- Interactive brainstorming with user remains inline

#### 13b: `wf-plan/SKILL.md`

**Current state**: Runs `writing-plans` skill inline.

**Changes**:

1. **Add subagent dispatch** after loading context, before invoking writing-plans:
   ```
   ## Subagent Planning (when available)
   If `invoke_subagent` is available, dispatch a `self` subagent with:
   - The SPEC.md content
   - The writing-plans skill instructions
   - The phase directory path
   - Any custom skills / MCP context discovered

   The subagent produces the PLAN.md file. The orchestrator then:
   1. Reviews the plan output
   2. Checks for quality (task specificity, verification commands, wave structure)
   3. Presents key decisions to the user for approval

   If `invoke_subagent` is NOT available, follow the writing-plans skill
   inline (current behavior).
   ```

**Acceptance Criteria**:
- `grep "invoke_subagent" .agents/skills/wf-plan/SKILL.md` matches
- `grep "self" .agents/skills/wf-plan/SKILL.md` shows subagent type
- Orchestrator reviews subagent output before presenting to user

#### 13c: `wf-stress-test/SKILL.md`

**Current state**: Runs adversarial critique inline.

**Changes**:

1. **Add subagent dispatch**:
   ```
   ## Subagent Stress Test (when available)
   If `invoke_subagent` is available, dispatch a `self` subagent with:
   - The SPEC.md and/or PLAN.md content
   - The brainstorming skill in adversarial critique mode
   - Instructions to attack across all 7 dimensions

   The subagent produces a findings report. The orchestrator then:
   1. Reviews the findings
   2. Filters for severity (critical vs nice-to-have)
   3. Presents findings to the user with recommended actions

   If `invoke_subagent` is NOT available, run the adversarial critique
   inline (current behavior).
   ```

**Acceptance Criteria**:
- `grep "invoke_subagent" .agents/skills/wf-stress-test/SKILL.md` matches
- Orchestrator filters and presents findings (doesn't just pass through)

#### 13d: `wf-verify/SKILL.md` (extends Deliverable 4)

**Current state**: Runs verification inline.

**Changes** (in addition to browser_subagent fallback from Deliverable 4):

1. **Add subagent dispatch**:
   ```
   ## Subagent Verification (when available)
   If `invoke_subagent` is available, dispatch a `self` subagent with:
   - The SPEC.md must-haves list
   - The verification-before-completion skill instructions
   - The phase directory and codebase access

   The subagent verifies each must-have and produces VERIFICATION.md.
   The orchestrator then:
   1. Reviews the verification results
   2. Checks that evidence is empirical (not claims)
   3. Presents results to the user with PASS/FAIL summary

   If `invoke_subagent` is NOT available, run verification inline
   (current behavior).
   ```

**Acceptance Criteria**:
- `grep "invoke_subagent" .agents/skills/wf-verify/SKILL.md` matches
- Orchestrator validates evidence quality before presenting results

#### 13e: `wf-execute/SKILL.md` (already covered by Deliverable 3)

SDD already handles subagent dispatch for execution. No additional changes needed — Deliverable 3 covers this.

**Key principle for all subagent-powered workflows**:
- The **orchestrator** (main agent) handles user interaction, coordination, and quality gates
- The **subagent** handles focused work with fresh context
- The orchestrator ALWAYS reviews subagent output before presenting to the user or proceeding
- When `invoke_subagent` is NOT available, everything runs inline — same methodology, just no context isolation

---

## Scope Boundaries

### In Scope

- Folder consolidation (`.agent/` → `.agents/skills/wf-*/`)
- SDD skill platform detection + inline fallback
- `wf-execute` deterministic SDD
- `wf-verify` browser_subagent fallback + subagent verification
- `wf-discuss-phase` subagent research dispatch
- `wf-plan` subagent planning dispatch
- `wf-stress-test` subagent adversarial dispatch
- `wf-quantis-help` CLI command section
- `wf-install` path updates
- `wf-update` and `wf-upgrade` path updates
- `adapters/ANTIGRAVITY.md` unified platform docs
- `README.md` platforms + CLI quick start
- `PROJECT_RULES.md` repository structure update
- `QUANTIS-STYLE.md` path update
- `MANIFEST.md` path update
- `CHANGELOG.md` v3.3 entry
- `using-quantis` CLI note
- 3 scripts path updates

### Out of Scope

- Phase 3.1 reliability fixes (separate phase, not folded in)
- Creating new workflows or skills
- Linux VM testing (deferred — needs actual VM)
- `.agents/rules/PROJECT_RULES.md` symlink (already done, no change needed)
- Content changes to workflows not listed in deliverables (they get migrated as-is)

---

## Verification Plan

After all deliverables complete:

1. **Structure**: `test ! -d .agent` — `.agent/` folder deleted
2. **No symlinks**: `find .agents/skills/wf-* -type l | wc -l` returns 0
3. **30 workflows**: `ls -d .agents/skills/wf-* | wc -l` returns 30
4. **18 skills**: `ls -d .agents/skills/[^_]* | wc -l` returns 18
5. **No stale refs**: `grep -r ".agent/" . --include="*.md" --include="*.sh" | grep -v ".agents/" | grep -v ".git/" | grep -v CHANGELOG` returns empty
6. **Scripts pass**: `bash scripts/validate-workflows.sh` exits 0
7. **MANIFEST correct**: All 30 `wf-*` entries listed
8. **Git clean**: `git status` shows expected changes, nothing missing
