---
name: wf-whats-new
description: Show recent Quantis changes and new features
---

# /wf-whats-new Workflow

<objective>
Display recent changes, new features, and improvements to Quantis.
</objective>

<process>

## 1. Read CHANGELOG.md

```bash
# Read the latest version section from CHANGELOG.md
head -50 CHANGELOG.md
```

## 2. Display Recent Changes

Display the latest version(s) from CHANGELOG.md:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► WHAT'S NEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{Display latest entries from CHANGELOG.md}

───────────────────────────────────────────────────────

📚 Full changelog: CHANGELOG.md

───────────────────────────────────────────────────────
```

</process>

<related>
## Related

### Workflows
| Command | Relationship |
|---------|--------------|
| `/wf-update` | Update Quantis to latest version |
| `/wf-quantis-help` | List all commands |

</related>
