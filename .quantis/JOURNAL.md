# Journal

> Previous milestone journal archived in `.quantis/milestones/v3.2/JOURNAL.md`

---

## Session: 2026-06-01 00:00

### Objective
Discuss, spec, plan, and stress-test Phase 3.1 — fixing 4 intermittent workflow reliability bugs.

### Accomplished
- Resumed from v3.2 completion
- Discussed all 4 issues with user, confirmed root causes in workflow files
- Added Phase 3.1 to ROADMAP.md under v3.3 milestone
- Wrote and finalized SPEC.md for Phase 3.1
- Created 2 execution plans (Plan A: discuss-phase + verify, Plan B: execute + pause)
- Ran adversarial stress-test — found 5 findings (1 critical, 1 high, 2 medium, 1 low)
- Identified that 2 issues are partially baked into skills (brainstorming step 9, writing-plans execution menu)

### Verification
- [x] SPEC.md written and committed
- [x] Plans created and committed
- [x] Stress-test completed with findings documented
- [ ] Plans not yet updated with stress-test fixes
- [ ] Scope decision pending (workflows-only vs also touch writing-plans skill)

### Paused Because
Late night — user needs to think about the scope decision (whether to also fix writing-plans skill) with fresh eyes.

### Handoff Notes
The critical question: should we expand scope to touch `writing-plans/SKILL.md` to remove the execution method menu (lines 136-153)? Without this, the "Subagent vs Inline?" menu still appears after `/plan`. With it, we get clean separation of concerns (skill writes plans, workflow handles execution). Decision needed before applying stress-test fixes and executing.

---

## Session: 2026-05-24 16:50

### Objective
Audit the entire Quantis framework codebase, locate and repair regression bugs/deleted files from the promotion of `quantis-new/` (commit `d38bb5e`), eliminate stale Antigravity/Claude tool naming issues, align adapter definitions, and perform deep cleanup before pausing.

### Accomplished
- Fixed `/install`, `/update`, `/upgrade` workflows to include `scripts/` directory copy operations.
- Bumped framework version to `3.2.0` across `VERSION`, `MANIFEST.md`, and `ARCHITECTURE.md`.
- Expanded `README.md` to document the v3.2 dynamic ecosystem discovery and included all 30 workflow commands in a clean, categorized table.
- Replaced Claude-specific `Task()` references with Antigravity 2.0 `invoke_subagent` in 8 prompt templates and skills.
- Made skills completely platform-agnostic, renaming Anthropic/Claude-specific terms to generic terms, while preserving official upstream guides as reference material.
- Added detailed Antigravity 2.0 subagent API documentation (`invoke_subagent`, `define_subagent`, etc.) and restored the lost evidence pattern example in `adapters/ANTIGRAVITY.md`.
- Restored the 132-line historical changelog (v1.0→v2.0) that was wiped out during promotion and documented the v3.1 and v3.2 releases in `CHANGELOG.md`.
- Restored `scripts/` folder mapping in `PROJECT_RULES.md`.

### Verification
- [x] Audited the repository manifest line-by-line; zero missing or unregistered files.
- [x] Verified that all core workflows compile cleanly and references are correct.
- [x] Confirmed that GSD v2 legacy files remain completely deleted.
- [x] Verified git status is clean and all audit commits are safely saved.

### Paused Because
Milestone v3.2 is fully completed, verified, and archived. The codebase audit, repair, and cleanup are finished. A pause session was requested by the user.

### Handoff Notes
Ready to plan and initiate Milestone v3.3. Stale local/remote branch `dogfood/promote-quantis-new` can be safely deleted.

---

## Session: 2026-05-24 20:32

### Objective
Create a remote-bootstrap upgrade script (`upgrade.sh`) to migrate GSD v2.x repos to Quantis v3.0 remotely, and fix target-workspace file pollution bugs where framework internal guides and readmes were being copied to target project repos.

### Accomplished
- Created `scripts/upgrade.sh` allowing a simple curl-based remote upgrade.
- Cleaned up `install.sh` and `upgrade.sh` along with all three installation/update/upgrade workflows (`/install`, `/update`, `/upgrade`) to completely exclude framework developer-specific folders (`docs/windows`, `docs/README.opencode.md`, `README.md`, `CHANGELOG.md`, `MANIFEST.md`).
- Restored `adapters/` folder copying as requested by the user.
- Implemented selective copying of `docs/` and `scripts/` folders (copying only core playbooks and validation/search utilities) to mirror GSD's exact workspace layout while protecting project folders.
- Ran the master validator suite on all files, confirming 0 errors, and pushed the updates to the master branch.

### Verification
- [x] Verified `scripts/upgrade.sh` correctly executes and rebrands paths.
- [x] Verified `scripts/install.sh` and workflows do not copy metadata/development files.
- [x] Verified that validation tests pass with zero failures.

### Paused Because
Session completed successfully; upgrade path is live and fully tested.

### Handoff Notes
Ready to upgrade GSD v2.x client repositories using the newly published remote upgrade command.
