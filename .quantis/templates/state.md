# STATE.md

<!-- Session memory. Edit fields in place — never regenerate the file.
     /q-pause writes it fully; /q-resume reads it; every session keeps Position current. -->

## Position
- **Phase**: {N: name}
- **Task**: {current task, or "between tasks"}
- **Status**: {Active | Paused at {timestamp}}

## Session Summary
{What the last session accomplished; what was verified}

## In-Progress
- Files modified: {list, or none}
- Tests: {passing / failing / not run}

## Blockers
{or "None"}

## Context Dump
- **Approaches tried**: {approach → outcome}
- **Current hypothesis**: {best guess}
- **Files of interest**: {path → why}

## Next Steps
1. {Specific first action — executable by /q-next or a fresh reader}
2. {…}
