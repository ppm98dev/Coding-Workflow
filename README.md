<div align="center">

<img src="assets/banner.svg" alt="Quantis" width="100%"/>

<br/>
<br/>

![Version](https://img.shields.io/badge/version-4.0.0-2563eb?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-16a34a?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Cursor-0b1020?style=flat-square)

**The conductor for your coding skills.**

Your plugins do the work. Quantis remembers where you are and calls the right one next.

</div>

---

Skills and plugins (like [obra/superpowers](https://github.com/obra/superpowers)) are the real engine of AI-assisted development — brainstorming, planning, TDD, review. What they don't have is a project-level memory: what you're building, which phase you're in, what's verified, where a fresh session should pick up. Cursor doesn't either — resume replays old threads; it can't hand a *new* session a distilled "here's where we are."

Quantis is that missing layer, kept deliberately tiny: **two markdown files, six commands, one of which matters.**

## 🔄 The loop

```
/q-init  →  ROADMAP.md (vision, non-goals, success criteria, phases) + STATE.md

/q-next  →  reads the state, runs ONE stage, records the outcome:
            DEFINE   resolve open questions → intent FINALIZED
            PLAN     → your planning skill; link the plan in ROADMAP
            BUILD    → your dev workflow (TDD, subagents, review)
            VERIFY   evidence against the phase objective → ✅ or gaps
            MILESTONE  archive, define the next phases

…repeat /q-next until shipped. /q-pause and /q-resume carry you across sessions.
```

The methodology skills are invoked *by* the loop, not replaced by it: superpowers plans stay in `docs/superpowers/plans/`, Cursor Plan Mode plans in `.cursor/plans/` — ROADMAP.md just links to them. Plugins track their own tasks; Quantis tracks phases.

## ⌨️ Commands

| Command | Purpose |
|---------|---------|
| `/q-init` | Short questioning → ROADMAP.md + STATE.md |
| `/q-next` | Advance one stage (the conductor — this is the workflow) |
| `/q-status` | Where are we, and what `/q-next` will do |
| `/q-pause` | Dump state for a clean session handoff |
| `/q-resume` | Restore context in a fresh session |
| `/q-update` | Update the installed Quantis (never touches project state) |
| `/q-help` | Reference |

Roadmap edits (add/remove/reorder phases, rename milestone) need no command — just ask; the schema lives in the always-loaded rules.

## 💾 State (`.quantis/`)

| Path | Purpose |
|------|---------|
| `ROADMAP.md` | Durable truth: intent header (with the `FINALIZED` gate), phases with status + plan links, decisions |
| `STATE.md` | Session memory: position, context dump, next steps |
| `phases/{N}-{slug}/` | Verification evidence (`VERIFICATION.md`) — the only way a phase becomes ✅ |
| `archive/` | Completed milestones |
| `templates/` | The three file schemas |

## 🛡️ Rules (always loaded via `.cursor/rules/quantis.mdc`)

> 🔒 **Planning Lock** — no code while the roadmap intent is `DRAFT`
> 🔗 **Link, don't relocate** — plugin artifacts stay in the plugin's home
> ✅ **Evidence or it didn't happen** — no ✅ without verified proof
> 💾 **State stays current** — a fresh session can always pick up
> ☝️ **One tracking layer** — don't pair with Spec Kit / Taskmaster-style trackers

## 🚀 Install

One-liner, from the project root:

```bash
curl -sSL https://raw.githubusercontent.com/ppm98dev/Coding-Workflow/main/scripts/install.sh | bash
```

Additive and idempotent — installs/refreshes the Quantis files only, never touches project state; refuses on a v3 footprint (use the migration script below). Alternatively install as a Cursor plugin (the repo ships `.cursor-plugin/plugin.json` — Customize page, `/add-plugin`, or a team marketplace).

### Migrating a v3 (Antigravity) project

One script, run from the project root (requires a clean git tree):

```bash
curl -sSL https://raw.githubusercontent.com/ppm98dev/Coding-Workflow/main/scripts/migrate-v3-to-v4.sh | bash
```

It salvages the old state into the v4 shape — SPEC → the roadmap intent header (FINALIZED status carries over), phases keep their ✅/🔄/⬜ statuses, decisions carry across, a filled CONSTITUTION becomes `.cursor/rules/constitution.mdc` — archives every v3 original under `.quantis/archive/v3/` (nothing is deleted), removes the Antigravity footprint (`.agents/`, `.gemini/`, `adapters/`), and installs v4. Everything lands in **one commit**: `git revert HEAD` undoes the migration. Afterwards: `/q-status`.

> **History:** v1–v3 were a full spec-driven workflow system for Google Antigravity, including a fork of superpowers' skills. v4 keeps only what plugins and Cursor don't provide: the tracking loop. Everything else lives in git history (≤ `b96a40a`).

<div align="center">

<br/>

**Skills do the work. Quantis keeps the thread.**

`MIT License`

</div>
