# Decisions

> Previous milestone decisions archived in `.quantis/milestones/v3.0/DECISIONS.md`

---

### D-025: Hierarchical Subphase Folders
**Decision:** Adopt a hierarchical subphase folder naming convention `.quantis/phases/{N}.{M}-{slug}/` (e.g., `.quantis/phases/4.1-user-authentication/`) for all future milestones. Each subphase/plan gets its own root folder in `phases/` containing its plan, research, and verification documents.
**Rationale:** Provides clean isolation, eliminates path ambiguity, and makes the project file tree instantly self-documenting.

