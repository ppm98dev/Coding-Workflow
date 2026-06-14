# Phase 3.5: Install/Update Footprint — source-only docs + namespaced version — SPEC

> **Status**: FINALIZED
> **Created**: 2026-06-13
> **Scope**: MANIFEST + dispatch/install/update skills + scripts + version-file relocation. No product code.

## Problem Statement

Running `/wf-update` in a work project (ARES_APP) **clobbered the project's own root files** —
`README.md`, `MANIFEST.md`, `CHANGELOG.md` were overwritten with Quantis's. Root cause: a
**three-way contradiction**:
- `wf-update/SKILL.md` Step 5 **prose**: *"Read MANIFEST.md… Only replace files and directories
  listed in the **Core** sections."*
- `MANIFEST.md` listed `README.md` / `MANIFEST.md` / `CHANGELOG.md` under a **"Root Files"** (Core)
  heading → so the agent dutifully copied them into the project.
- The wf-update **bash** only copied `VERSION` — so prose and bash disagreed, and the agent followed
  the prose.

Separately, Quantis installed a bare **`VERSION`** at the project root, which **collides with / is
mistaken for the project's own** version file.

## Fixes
- **Fix 1 — README/MANIFEST/CHANGELOG are Quantis SOURCE-ONLY, never installed.** Restructure
  `MANIFEST.md`: move them out of "Core Root Files" into a **"Quantis source-only — NEVER copied into
  a target project"** section. Add an explicit guard to `wf-update/SKILL.md` Step 5 prose.
- **Fix 2 — Relocate the version marker:** root `VERSION` → **`.quantis/VERSION`** (namespaced; no root
  collision). Update **all 11 references**: `install.sh`, `upgrade.sh`, `wf-install`, `wf-quantis-help`,
  `wf-update` (×3), `wf-upgrade` (×2), `MANIFEST.md`, README layout.
- **Version bump:** 3.4.1 → **3.4.2** (the marker now lives at `.quantis/VERSION`).

## Acceptance
- No script or skill **bash** copies `README.md` / `MANIFEST.md` / `CHANGELOG.md` into a target.
- `wf-update` prose explicitly forbids copying those three; MANIFEST marks them source-only.
- Every version read/write uses `.quantis/VERSION` (grep: zero bare-root `VERSION` refs remain).
- `.quantis/VERSION` exists (= 3.4.2); root `VERSION` removed.
- `validate-all.sh` green.

## Decisions
- **D-013** — README/MANIFEST/CHANGELOG are Quantis source-only (never installed); version marker
  relocated to `.quantis/VERSION` (no bare-root file in a project).

## Out of Scope
- Auto-migrating an existing **root `VERSION`** in already-installed projects — a root `VERSION` there
  might be the *project's own*, so Quantis must not move/delete it. New installs/updates simply use
  `.quantis/VERSION` going forward; any stale Quantis root `VERSION` is harmless and user-removable.
- Recovering the already-clobbered ARES_APP root files — that's a `git checkout`/restore in that repo
  (separate from this source fix).

---

*Last updated: 2026-06-13*
