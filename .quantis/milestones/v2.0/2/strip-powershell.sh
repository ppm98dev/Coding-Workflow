#!/bin/bash
# strip-powershell.sh — Remove PowerShell blocks from markdown files
# Handles both labeled (**PowerShell:**) and unlabeled (```powershell) blocks

FILE="$1"
if [ ! -f "$FILE" ]; then
    echo "Error: $FILE not found"
    exit 1
fi

# Use perl for multi-line regex
perl -0777 -i -pe '
    # Remove **PowerShell:** + ```powershell ... ``` blocks (labeled)
    s/\n?\*\*PowerShell:\*\*\s*\n```powershell\n.*?```\n?//gs;
    
    # Remove unlabeled ```powershell ... ``` blocks
    s/\n?```powershell\n.*?```\n?//gs;
    
    # Remove standalone **Bash:** labels
    s/\*\*Bash:\*\*\s*\n//g;
    
    # Remove "# ... (PowerShell)" comment lines
    s/^#.*\(PowerShell\).*\n//gm;
    
    # Clean up triple+ blank lines to max double
    s/\n{3,}/\n\n/g;
' "$FILE"

echo "Stripped: $FILE"
