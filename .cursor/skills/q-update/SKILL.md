---
name: q-update
description: Update the installed Quantis (skills, rules, templates) to the latest version — never touches project state
disable-model-invocation: true
---

# /q-update — refresh Quantis in this project

## 1. Guard

- `.quantis/VERSION` must exist and be ≥ 4. A v3 footprint (`.agents/skills/wf-*`, `.quantis/SPEC.md`) → STOP: that needs the migration script instead:
  `curl -sSL https://raw.githubusercontent.com/ppm98dev/Coding-Workflow/main/scripts/migrate-v3-to-v4.sh | bash`
- If Quantis is installed as a marketplace plugin (skills not present in this project's `.cursor/skills/`), updates come through Cursor's plugin system — report that and STOP.

## 2. Fetch latest

```bash
tmp=$(mktemp -d) && git clone --depth 1 https://github.com/ppm98dev/Coding-Workflow.git "$tmp"
```

## 3. Update — Quantis files only

Overwrite from the clone:
- `.cursor/skills/q-*/` (remove local `q-*` dirs that no longer exist upstream)
- `.cursor/rules/quantis.mdc`
- `.quantis/templates/`
- `.quantis/VERSION`

**NEVER touch** (project-owned): `.quantis/ROADMAP.md`, `STATE.md`, `phases/`, `archive/`, `.cursor/rules/constitution.mdc`, any other `.cursor/` content, and the project's own `README.md`/`CHANGELOG.md`.

## 4. Report & commit

Summarize what changed (old → new version, which skills were added/updated/removed — from the clone's CHANGELOG.md if helpful), clean up `$tmp`, then:

```bash
git add .cursor/skills .cursor/rules/quantis.mdc .quantis/templates .quantis/VERSION
git commit -m "chore: update Quantis to {version}"
```
