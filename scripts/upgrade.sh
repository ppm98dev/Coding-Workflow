#!/usr/bin/env bash
set -euo pipefail

# Style definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}             Quantis ► UPGRADER                      ${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check for git
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is required to upgrade to Quantis.${NC}"
    exit 1
fi

# Detect Current Installation
INSTALL_TYPE="none"
if [ -d ".gsd" ]; then
    echo -e "🔍 Detected GSD v2.x directory (.gsd/)..."
    INSTALL_TYPE="gsd-v2"
elif [ -d ".agents/skills/planner" ] || [ -d ".agents/skills/executor" ] || [ -d ".agents/skills/verifier" ]; then
    echo -e "🔍 Detected GSD v2.x skills in .agents/skills/..."
    INSTALL_TYPE="gsd-v2"
elif [ -d ".quantis" ]; then
    if [ -d ".agents/skills/brainstorming" ] || [ -d ".agents/skills/writing-plans" ]; then
        echo -e "🔍 Detected Quantis v3.x already installed."
        INSTALL_TYPE="quantis-v3"
    else
        echo -e "🔍 Detected unrecognized .quantis folder. Treating as fresh or partial GSD."
        INSTALL_TYPE="gsd-v2"
    fi
fi

if [ "$INSTALL_TYPE" = "none" ]; then
    echo -e "${YELLOW}Warning: No existing GSD or Quantis installation detected in this folder.${NC}"
    echo -e "To install Quantis from scratch, please use the installer instead:"
    echo -e "  ${BLUE}curl -fsSL https://raw.githubusercontent.com/ppm98dev/Coding-Workflow/main/scripts/install.sh | bash${NC}"
    exit 1
fi

if [ "$INSTALL_TYPE" = "quantis-v3" ]; then
    echo -e "${GREEN}You are already running Quantis v3.x!${NC}"
    echo -e "To update to the latest version, run the following command in your repository:"
    echo -e "  ${BLUE}curl -fsSL https://raw.githubusercontent.com/ppm98dev/Coding-Workflow/main/scripts/install.sh | bash${NC}"
    echo -e "Or run the ${BLUE}/update${NC} workflow inside your AI agent."
    exit 0
fi

echo -e "🚀 Starting upgrade from GSD v2.x to Quantis..."

# Temp directory
TEMP_DIR=".quantis-upgrade-temp-$(date +%s)"

echo -e "📥 Cloning latest Quantis from GitHub..."
if ! git clone --depth 1 https://github.com/ppm98dev/Coding-Workflow.git "$TEMP_DIR" &>/dev/null; then
    echo -e "${RED}Error: Failed to clone Quantis repository.${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Step 1: Migrate folder structure GSD -> Quantis
if [ -d ".gsd" ]; then
    echo -e "📂 Renaming .gsd/ directory to .quantis/..."
    if [ -d ".quantis" ]; then
        # Merge contents just in case
        cp -r .gsd/* .quantis/ 2>/dev/null || true
        rm -rf .gsd
    else
        mv .gsd .quantis
    fi
fi

# Create target folders if they don't exist
mkdir -p .agent/workflows .agents/skills .gemini .quantis/templates adapters scripts

# Step 2: Remove Old GSD Core Skills
echo -e "🧹 Removing old GSD core skills..."
OLD_SKILLS="planner executor verifier debugger context-fetch empirical-validation plan-checker"
removed_count=0
for skill in $OLD_SKILLS; do
    if [ -d ".agents/skills/$skill" ]; then
        rm -rf ".agents/skills/$skill"
        echo -e "  ${RED}✗${NC} Removed old skill: $skill"
        ((removed_count++))
    fi
done

# Step 3: Install Quantis v3.0 Core Skills
echo -e "⚙️ Installing new Quantis skills..."
for skill_dir in $(ls "$TEMP_DIR/.agents/skills/"); do
    rm -rf ".agents/skills/$skill_dir"
    cp -r "$TEMP_DIR/.agents/skills/$skill_dir" ".agents/skills/"
    echo -e "  ${GREEN}+${NC} Installed: $skill_dir"
done

# Step 4: Replace Workflows
echo -e "⚙️ Replacing workflows with Quantis workflows..."
rm -rf .agent/workflows
cp -r "$TEMP_DIR/.agent/workflows" .agent/

# Step 5: Update Templates
echo -e "⚙️ Updating .quantis templates..."
rm -rf .quantis/templates
cp -r "$TEMP_DIR/.quantis/templates" .quantis/

# Step 6: Update Bootstrap and Adapters
echo -e "⚙️ Updating bootstrap and adapters..."
cp "$TEMP_DIR/.gemini/GEMINI.md" .gemini/GEMINI.md 2>/dev/null || true
cp -r "$TEMP_DIR/adapters" ./ 2>/dev/null || true

# Step 7: Update Root Files
echo -e "⚙️ Copying core configuration files..."
cp "$TEMP_DIR/PROJECT_RULES.md" ./
cp "$TEMP_DIR/QUANTIS-STYLE.md" ./
cp "$TEMP_DIR/CHANGELOG.md" ./
cp "$TEMP_DIR/VERSION" ./
cp "$TEMP_DIR/MANIFEST.md" ./
cp "$TEMP_DIR/README.md" ./
cp "$TEMP_DIR/model_capabilities.yaml" ./

# Copy scripts
cp -r "$TEMP_DIR/scripts" ./ 2>/dev/null || true

# Clean up obsolete GSD style file if exists
if [ -f "GSD-STYLE.md" ]; then
    rm "GSD-STYLE.md"
    echo -e "  ${RED}✗${NC} Removed obsolete GSD-STYLE.md"
fi

# Step 8: Replace GSD references in preserved state files
echo -e "🔄 Replacing GSD references with Quantis..."
# Find all markdown files in .quantis/ and run sed in-place
find .quantis -type f -name "*.md" | while read -r file; do
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's/\.gsd\//\.quantis\//g' "$file" 2>/dev/null || true
        sed -i '' 's/GSD/Quantis/g' "$file" 2>/dev/null || true
    else
        sed -i 's/\.gsd\//\.quantis\//g' "$file" 2>/dev/null || true
        sed -i 's/GSD/Quantis/g' "$file" 2>/dev/null || true
    fi
done

# Perform same replacement on CONSTITUTION.md if it exists
if [ -f "CONSTITUTION.md" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's/GSD/Quantis/g' CONSTITUTION.md 2>/dev/null || true
        sed -i '' 's/Get Shit Done/Quantis/g' CONSTITUTION.md 2>/dev/null || true
    else
        sed -i 's/GSD/Quantis/g' CONSTITUTION.md 2>/dev/null || true
        sed -i 's/Get Shit Done/Quantis/g' CONSTITUTION.md 2>/dev/null || true
    fi
fi

# Step 9: Cleanup
rm -rf "$TEMP_DIR"

echo -e "🧹 Upgrade clean up complete."
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}             Quantis ► UPGRADED SUCCESSFULLY ✓        ${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
echo -e "Summary:"
echo -e "  • Old GSD core skills removed: $removed_count"
echo -e "  • New Quantis skills installed: $(ls .agents/skills/ | wc -w | xargs)"
echo -e "  • Workflows updated: $(ls .agent/workflows/ | wc -w | xargs)"
echo -e "  • Templates updated: $(ls .quantis/templates/ | wc -w | xargs)"
echo -e "  • User state preserved: .quantis/*"
echo -e ""
echo -e "Next steps:"
echo -e "  1. Open your AI agent in this project."
echo -e "  2. Run ${BLUE}/progress${NC} to see your current position."
echo -e "  3. Run ${BLUE}/whats-new${NC} to see what's new in Quantis!"
echo -e ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
