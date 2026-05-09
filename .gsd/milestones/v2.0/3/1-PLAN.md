---
phase: 3
plan: 1
wave: 1
---

# Plan 3.1: Fix README + Attribution + Stale Claims

## Objective
Fix all factual errors and stale references across README.md, CHANGELOG.md, and .gsd/ARCHITECTURE.md. All changes are mechanical find-and-replace.

## Context
- .gsd/ROADMAP.md (Phase 3 scope)
- .gsd/phases/VERIFICATION.md (known issues list)

## Tasks

<task type="auto">
  <name>Fix README accuracy</name>
  <files>README.md</files>
  <action>
    1. Change "Commands (29 Total)" to "Commands (27 Total)" (line ~274)
    2. Change "29" to "27" in the nav line (~line 23)
    3. Remove line 370: "All workflow files include **dual syntax** — both PowerShell and Bash commands."
       Replace with: "All workflow files use **Bash** commands (macOS/Linux)."
    4. Update attribution links: replace ALL instances of
       `glittercowboy/get-shit-done` with `gsd-build/get-shit-done`
    5. Do NOT touch mermaid diagrams or other content
  </action>
  <verify>
    grep -c "29 Total\|29 total\|dual syntax\|glittercowboy" README.md | grep -q "0" && echo "PASS" || echo "FAIL"
  </verify>
  <done>Zero instances of "29", "dual syntax", or "glittercowboy" in README.md</done>
</task>

<task type="auto">
  <name>Fix attribution in CHANGELOG + ARCHITECTURE + Phase 4 roadmap</name>
  <files>CHANGELOG.md, .gsd/ARCHITECTURE.md, .gsd/ROADMAP.md</files>
  <action>
    1. CHANGELOG.md: Replace `glittercowboy/get-shit-done` with `gsd-build/get-shit-done`
    2. .gsd/ARCHITECTURE.md: Replace `glittercowboy/get-shit-done` with `gsd-build/get-shit-done`
    3. .gsd/ROADMAP.md Phase 4: Remove `scripts/install.ps1` line (we're Bash-only now)
  </action>
  <verify>
    grep -rc "glittercowboy" README.md CHANGELOG.md .gsd/ARCHITECTURE.md | grep -v ":0$" | wc -l | grep -q "0" && echo "PASS" || echo "FAIL"
  </verify>
  <done>Zero "glittercowboy" references outside .gsd/phases/ and .gsd/AUDIT.md (historical records)</done>
</task>

## Success Criteria
- [ ] README says "27 Total" not "29 Total"
- [ ] No "dual syntax" claim in README
- [ ] Zero glittercowboy references in active files
- [ ] Phase 4 roadmap no longer lists install.ps1
