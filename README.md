<div align="center">

<br/>

[![Version](https://img.shields.io/badge/version-2.1.0-00C853?style=flat-square)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-MIT-2196F3?style=flat-square)](LICENSE)
[![Evolved from GSD](https://img.shields.io/badge/evolved%20from-GSD-7B2D8E?style=flat-square)](https://github.com/gsd-build/get-shit-done)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-FF6D00?style=flat-square)](#-platform-support)
[![Model Agnostic](https://img.shields.io/badge/models-any%20LLM-E91E63?style=flat-square)](#-multi-model-support)

<br/>

# ⚛️ Quantis

**Spec-Driven Development for AI Coding**

*Define quality standards → Specify what to build → Stress-test for gaps → Plan with rigor → Execute atomically → Verify with proof.*

<br/>

[Getting Started](#-getting-started) · [How It Works](#-how-it-works) · [Quality Governance](#-quality-governance) · [Commands](#-commands-28-total) · [Documentation](#-documentation)

</div>

---

## 🧠 The Problem

> Vibecoding has a bad reputation — and it deserves it.

You describe what you want, AI generates code, and you get **inconsistent, untested, "it works" code** that falls apart at scale. No error handling. No logging. No tests. No structure.

Quantis fixes that. It's the **spec-driven context engineering layer** that makes AI coding reliable and production-grade.

<table>
<tr>
<td width="50%">

### ❌ Without Quantis
```
"Add a feature"
    → Vague spec
    → Guessed requirements
    → "It works" code
    → No tests, no logging
    → Debug loop
    → Frustration
```

</td>
<td width="50%">

### ✅ With Quantis
```
"Add a feature"
    → Constitution (quality standards)
    → SPEC (forced clarity)
    → Stress-test (find gaps)
    → Atomic execution
    → Empirical verification
    → ✅ Production-grade
```

</td>
</tr>
</table>

> **No enterprise roleplay.** No sprint ceremonies, story points, stakeholder syncs, or Jira workflows.
> Just an incredibly effective system for building high-quality software consistently.

---

## 👤 Who This Is For

| | |
|---|---|
| 🧑‍💻 **Solo developers** | Using AI coding assistants and need consistency |
| 👥 **Small teams** | Who want structure without enterprise overhead |
| 😤 **Anyone** | Tired of AI generating untested, unstructured code |

---

## ⚡ Getting Started

```bash
# Open your project
cd your-project

# Clone the Quantis template
git clone https://github.com/ppm98dev/Coding-Workflow.git quantis-template

# Copy to your project
cp -r quantis-template/.agent ./
cp -r quantis-template/.agents ./
cp -r quantis-template/.gemini ./
cp -r quantis-template/.quantis ./
cp -r quantis-template/adapters ./
cp -r quantis-template/docs ./
cp -r quantis-template/scripts ./
cp quantis-template/PROJECT_RULES.md ./
cp quantis-template/QUANTIS-STYLE.md ./
cp quantis-template/model_capabilities.yaml ./

# Clean up
rm -rf quantis-template
```

Then run `/new-project` and follow the prompts.

> [!TIP]
> You can also use `/install` from a clean project to automate the installation above.

---

## 🔄 How It Works

```mermaid
graph LR
    A["📜 Constitution"] --> B["🆕 /new-project"]
    B --> C["📋 SPEC.md"]
    C --> D["🔥 /stress-test"]
    D --> E["📐 /plan"]
    E --> F["⚙️ /execute"]
    F --> G["✅ /verify"]
    G --> H{"More\nphases?"}
    H -- Yes --> I["💬 /discuss-phase"]
    I --> E
    H -- No --> J["🏁 /complete-milestone"]

    style A fill:#FF6D00,color:#fff,stroke:none
    style B fill:#7B2D8E,color:#fff,stroke:none
    style C fill:#00C853,color:#fff,stroke:none
    style D fill:#E91E63,color:#fff,stroke:none
    style E fill:#FF6D00,color:#fff,stroke:none
    style F fill:#2196F3,color:#fff,stroke:none
    style G fill:#00C853,color:#fff,stroke:none
    style H fill:#FFC107,color:#000,stroke:none
    style I fill:#2196F3,color:#fff,stroke:none
    style J fill:#7B2D8E,color:#fff,stroke:none
```

| Step | Command | Output |
|:----:|---------|--------|
| **0** | `/new-project` | Constitution Q&A → `CONSTITUTION.md` (quality standards) |
| **1** | `/new-project` | Deep questioning → `SPEC.md` (finalized) |
| **2** | `/stress-test` | Adversarial review → Find gaps, add `[NEEDS CLARIFICATION]` markers |
| **3** | `/plan N` | Technical discovery → `PLAN.md` with XML tasks |
| **4** | `/execute N` | Wave-based execution → Atomic commits |
| **5** | `/verify N` | Must-haves check → Evidence captured |
| **6** | Repeat | Next phase or `/complete-milestone` |

---

## 🛡️ Quality Governance

Quantis goes beyond task management — it enforces **production-grade code quality** through constitutional governance.

### 📜 CONSTITUTION.md — Project Quality Standards

Every project gets a constitution with **10 articles** defining how code must be written:

| Article | Governs |
|---------|---------|
| 1. Code Quality | Naming, function length, single responsibility |
| 2. Error Handling | Fail-fast vs graceful, no empty catches |
| 3. Logging | Structured vs plaintext, required events |
| 4. Input Validation | Boundary validation, schema-based |
| 5. Testing | Test-first, coverage targets, anti-patterns |
| 6. Security | No hardcoded secrets, parameterized queries |
| 7. Documentation | Docstrings, API docs, WHY not WHAT |
| 8. Performance | N+1 queries, unbounded loops, memory |
| 9. Dependencies | Approval process, version pinning |
| 10. Architecture | Separation of concerns, dependency direction |

> The constitution is **always loaded** in `/plan` and `/execute`. It's the DNA of your project.

### 🔒 Forced Clarity — `[NEEDS CLARIFICATION]`

Ambiguity kills projects. Quantis forces you to confront it:

```markdown
## Goals
1. Real-time notifications [NEEDS CLARIFICATION: push vs polling? frequency?]
2. User auth via OAuth

## Performance
- Must be fast [NEEDS CLARIFICATION: what latency? p50? p95? p99?]
```

- **Plan-checker rejects** specs with unresolved markers
- **`/stress-test`** adversarially reviews your spec on 7 dimensions

### 📐 Separation Rule

```
SPEC.md = WHAT to build + WHY  (user intent, no tech details)
PLAN.md = HOW to build it      (tech stack, architecture, implementation)
```

---

## 🧩 Why It Works

### 📦 Context Engineering

AI is powerful **if** you give it proper context. Most people don't. Quantis handles it:

| File | Role | Icon |
|------|------|:----:|
| `CONSTITUTION.md` | Quality standards, always loaded | 📜 |
| `SPEC.md` | Project vision, always loaded | 🎯 |
| `ARCHITECTURE.md` | System understanding | 🏗️ |
| `ROADMAP.md` | Where you're going, what's done | 🗺️ |
| `STATE.md` | Decisions, blockers, memory across sessions | 💾 |
| `PLAN.md` | Atomic tasks with XML structure | 📐 |

### 🏷️ XML Prompt Formatting

Every plan is structured XML optimized for AI execution:

```xml
<task type="auto">
  <name>Create login endpoint</name>
  <files>src/app/api/auth/login/route.ts</files>
  <action>
    Use jose for JWT (not jsonwebtoken - CommonJS issues).
    Validate credentials against users table.
    Return httpOnly cookie on success.
  </action>
  <verify>curl -X POST localhost:3000/api/auth/login returns 200 + Set-Cookie</verify>
  <done>Valid credentials return cookie, invalid return 401</done>
</task>
```

### 🌊 Wave-Based Execution

Plans are grouped into dependency waves. Each executor gets **fresh context**.

### 🔗 Atomic Git Commits

Each task → its own commit. `git bisect` finds exact failing task.

### 🔬 Empirical Verification

No "trust me, it works." Every verification produces proof:

| Change Type | Evidence Required |
|:---:|:---:|
| 🌐 API endpoint | `curl` output |
| 🖥️ UI change | Screenshot |
| 🏗️ Build | Command output |
| 🧪 Tests | Test results |

---

## 🎮 Commands (28 Total)

> [!NOTE]
> Slash commands are typed directly as chat messages (e.g. send `/plan 1`). They are **not** IDE autocomplete features.

### 🔵 Core Workflow

| Command | Purpose |
|---------|---------|
| `/map` | 🏗️ Analyze codebase → `ARCHITECTURE.md` |
| `/plan [N]` | 📐 Create `PLAN.md` for phase N |
| `/execute [N]` | ⚙️ Wave-based execution with atomic commits |
| `/verify [N]` | ✅ Must-haves validation with proof |
| `/stress-test` | 🔥 Adversarial spec review — find gaps before planning |
| `/debug [desc]` | 🐛 Systematic debugging (3-strike rule) |

### 🟢 Project Setup

| Command | Purpose |
|---------|---------|
| `/install` | 📦 Install Quantis from GitHub |
| `/new-project` | 🆕 Constitution → Deep questioning → `SPEC.md` |
| `/new-milestone` | 🏁 Create milestone with phases |
| `/complete-milestone` | 🎉 Archive completed milestone |
| `/audit-milestone` | 🔍 Review milestone quality |

### 🟠 Phase Management

| Command | Purpose |
|---------|---------|
| `/add-phase` | ➕ Add phase to end of roadmap |
| `/insert-phase` | 📌 Insert phase (renumbers) |
| `/remove-phase` | ➖ Remove phase (safety checks) |
| `/discuss-phase` | 💬 Clarify scope before planning |
| `/research-phase` | 🔬 Deep technical research |
| `/list-phase-assumptions` | 📋 Surface planning assumptions |
| `/plan-milestone-gaps` | 🔧 Create gap closure plans |

### 🟡 Sprint

| Command | Purpose |
|---------|---------|
| `/sprint new` | ⚡ Create a time-boxed sprint |
| `/sprint status` | 📊 Show sprint progress |
| `/sprint close` | ✅ Close sprint with retrospective |

### 🟣 Navigation & State

| Command | Purpose |
|---------|---------|
| `/progress` | 📊 Show current position |
| `/pause` | ⏸️ Save state for session handoff |
| `/resume` | ▶️ Restore from last session |
| `/add-todo` | 📝 Quick capture idea |
| `/check-todos` | 📋 List pending items |

### 🔴 Utilities

| Command | Purpose |
|---------|---------|
| `/help` | ❓ Show all available commands |
| `/web-search` | 🌐 Search the web for decisions |
| `/whats-new` | 📢 Show recent Quantis changes |
| `/update` | ⬆️ Update Quantis to latest version |

---

## 💡 Typical Session

```bash
/resume              # ← Load context from last session
/progress            # ← See where you left off
/discuss-phase 2     # ← Clarify requirements (optional)
/plan 2              # ← Plan next phase
/execute 2           # ← Implement with atomic commits
/verify 2            # ← Prove it works (screenshots, tests)
/pause               # ← Save state for later
```

> [!IMPORTANT]
> Quantis enforces **planning before coding**. The AI can't write code until `SPEC.md` says `FINALIZED` and `CONSTITUTION.md` exists. No shortcuts.

---

## 🔒 Core Rules

| | Rule | Why It Matters |
|:---:|------|----------------|
| 📜 | **Constitutional Compliance** | Every plan and execution respects project quality standards |
| 🔒 | **Planning Lock** | No code until `SPEC.md` is `FINALIZED` — prevents building wrong thing |
| ⚠️ | **Forced Clarity** | `[NEEDS CLARIFICATION]` markers block planning until resolved |
| 💾 | **State Persistence** | Update `STATE.md` after every task — memory across sessions |
| 🧹 | **Context Hygiene** | 3 failures → state dump → fresh session — prevents circular debugging |
| ✅ | **Empirical Validation** | Proof required — no "it should work" |

---

## 📁 File Structure

```
📄 PROJECT_RULES.md          # ← Canonical rules (model-agnostic)
📄 QUANTIS-STYLE.md          # Complete style guide

📂 .agent/
└── 📂 workflows/            # 28 slash commands

📂 .agents/
└── 📂 skills/               # 11 agent specializations

📂 .gemini/
└── 📄 GEMINI.md             # Gemini integration

📂 .quantis/
├── 📄 CONSTITUTION.md       # ← QUALITY STANDARDS (always loaded)
├── 📄 SPEC.md               # ← START HERE (finalize first)
├── 📄 ROADMAP.md            # Phases and progress
├── 📄 STATE.md              # Session memory
├── 📄 ARCHITECTURE.md       # System design (/map output)
├── 📄 STACK.md              # Tech inventory
├── 📄 DECISIONS.md          # Architecture Decision Records
├── 📄 JOURNAL.md            # Session log
├── 📄 TODO.md               # Quick capture
├── 📂 templates/            # Document templates (including constitution)
└── 📂 examples/             # Usage walkthroughs

📂 adapters/                 # Optional model-specific enhancements
📂 docs/                     # Operational documentation
📂 scripts/                  # Utility scripts
📄 model_capabilities.yaml   # Optional capability registry
```

---

## 🧪 Testing

Run validation scripts to verify Quantis structure:

```bash
./scripts/validate-all.sh         # Run all validators
./scripts/validate-workflows.sh   # Workflows only
./scripts/validate-skills.sh      # Skills only
```

---

## 📚 Documentation

| Resource | Description |
|----------|-------------|
| [PROJECT_RULES.md](PROJECT_RULES.md) | Canonical model-agnostic rules |
| [QUANTIS-STYLE.md](QUANTIS-STYLE.md) | Complete style and conventions guide |
| [Model Selection Playbook](docs/model-selection-playbook.md) | Model selection guidance |
| [Runbook](docs/runbook.md) | Operational procedures |
| [Token Optimization Guide](docs/token-optimization-guide.md) | Token efficiency strategies |
| [Examples](.quantis/examples/) | Usage walkthroughs and quick reference |
| [Templates](.quantis/templates/) | Document templates for plans, verification |

---

## 🧠 Philosophy

<table>
<tr>
<td>📜</td><td><b>Constitution-first</b> — Define quality standards before writing a single line</td>
</tr>
<tr>
<td>🎯</td><td><b>Spec-driven</b> — Specifications generate implementation, not the other way around</td>
</tr>
<tr>
<td>⚠️</td><td><b>Forced clarity</b> — Mark what you don't know instead of guessing</td>
</tr>
<tr>
<td>🧹</td><td><b>Fresh context > polluted context</b> — State dumps prevent hallucinations</td>
</tr>
<tr>
<td>🔬</td><td><b>Proof over trust</b> — Screenshots and command outputs, not "looks right"</td>
</tr>
<tr>
<td>⚛️</td><td><b>Aggressive atomicity</b> — 2–3 tasks per plan, atomic commits</td>
</tr>
<tr>
<td>🔍</td><td><b>Search before reading</b> — Don't load files blindly</td>
</tr>
<tr>
<td>🤖</td><td><b>Model-agnostic</b> — Works with any capable LLM</td>
</tr>
<tr>
<td>🚫</td><td><b>No enterprise theater</b> — Solo dev + AI workflow, no ceremonies</td>
</tr>
</table>

---

<div align="center">

<sub>Evolved from <a href="https://github.com/gsd-build/get-shit-done">gsd-build/get-shit-done</a> — rebuilt with spec-driven governance for production-grade AI coding</sub>

<br/>

[![GitHub](https://img.shields.io/badge/GitHub-ppm98dev-181717?style=flat-square&logo=github)](https://github.com/ppm98dev/Coding-Workflow)

</div>