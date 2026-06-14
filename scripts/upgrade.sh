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
elif [ -d ".agent/workflows" ]; then
    echo -e "🔍 Detected old Quantis with .agent/workflows/ (pre-v3.3)..."
    INSTALL_TYPE="quantis-old"
elif find .agents/skills/ -maxdepth 1 -name '_wf-*' 2>/dev/null | grep -q .; then
    echo -e "🔍 Detected old Quantis with _wf-* symlinks (pre-v3.3)..."
    INSTALL_TYPE="quantis-old"
elif [ -d ".quantis" ]; then
    if [ -d ".agents/skills/wf-plan" ] && [ ! -d ".agent" ]; then
        echo -e "🔍 Detected current Quantis v3.3+."
        INSTALL_TYPE="current"
    elif [ -d ".agents/skills/brainstorming" ] || [ -d ".agents/skills/writing-plans" ]; then
        echo -e "🔍 Detected Quantis v3.x (needs migration)."
        INSTALL_TYPE="quantis-old"
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

if [ "$INSTALL_TYPE" = "current" ]; then
    echo -e "${GREEN}You are already running the latest Quantis!${NC}"
    echo -e "To update to the latest version, use:"
    echo -e "  ${BLUE}curl -fsSL https://raw.githubusercontent.com/ppm98dev/Coding-Workflow/main/scripts/install.sh | bash${NC}"
    echo -e "Or run the ${BLUE}/wf-update${NC} workflow inside your AI agent."
    exit 0
fi

echo -e "🚀 Starting upgrade..."

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
        cp -r .gsd/* .quantis/ 2>/dev/null || true
        rm -rf .gsd
    else
        mv .gsd .quantis
    fi
fi

# Create target folders
mkdir -p .agents/skills .agents/rules .gemini .quantis/templates adapters scripts

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

# Step 3: Remove Legacy Directories
echo -e "🧹 Cleaning up legacy structure..."
if [ -d ".agent" ]; then
    rm -rf .agent
    echo -e "  ${RED}✗${NC} Removed .agent/ directory"
fi

# Remove _wf-* symlinks/dirs
find .agents/skills/ -maxdepth 1 -name '_wf-*' 2>/dev/null | while read -r link; do
    rm -rf "$link"
    echo -e "  ${RED}✗${NC} Removed $(basename "$link")"
done

# Remove dead files
rm -f model_capabilities.yaml
rm -f adapters/CLAUDE.md adapters/GEMINI.md adapters/GPT_OSS.md
rm -f GSD-STYLE.md

# Step 4: Migrate Root Rules to .agents/rules/ (ADDITIVE — never delete existing rules)
echo -e "📦 Adding Quantis rules to .agents/rules/..."
for f in PROJECT_RULES.md QUANTIS-STYLE.md; do
    if [ -f "$f" ] && [ ! -f ".agents/rules/$f" ]; then
        mv "$f" ".agents/rules/"
        echo -e "  ${GREEN}→${NC} $f → .agents/rules/"
    elif [ -f "$f" ]; then
        rm "$f"
        echo -e "  ${GREEN}→${NC} Removed root $f (already in .agents/rules/)"
    fi
done
if [ -f "CONSTITUTION.md" ] && [ ! -f ".agents/rules/CONSTITUTION.md" ]; then
    mv "CONSTITUTION.md" ".agents/rules/"
    echo -e "  ${GREEN}→${NC} CONSTITUTION.md → .agents/rules/ (preserved)"
elif [ -f "CONSTITUTION.md" ]; then
    rm "CONSTITUTION.md"
fi
# Remove stale symlinks in .agents/rules/ but keep real files
find .agents/rules/ -type l -delete 2>/dev/null || true
echo -e "  ℹ️  Existing rules in .agents/rules/ are preserved"

# Step 5: Install All Skills + Workflows
echo -e "⚙️ Installing Quantis skills and workflows..."
for skill_dir in $(ls "$TEMP_DIR/.agents/skills/"); do
    rm -rf ".agents/skills/$skill_dir"
    cp -r "$TEMP_DIR/.agents/skills/$skill_dir" ".agents/skills/"
    echo -e "  ${GREEN}+${NC} Installed: $skill_dir"
done

# Step 6: Update Templates
echo -e "⚙️ Updating .quantis templates..."
rm -rf .quantis/templates
cp -r "$TEMP_DIR/.quantis/templates" .quantis/

# Step 7: Update Bootstrap and Adapter
echo -e "⚙️ Updating bootstrap and adapter..."
cp "$TEMP_DIR/.gemini/GEMINI.md" .gemini/GEMINI.md 2>/dev/null || true
cp "$TEMP_DIR/adapters/ANTIGRAVITY.md" adapters/ 2>/dev/null || true

# Step 8: Update Core Docs and Scripts
echo -e "⚙️ Updating core docs and scripts..."
cp "$TEMP_DIR/scripts/search_repo.sh" scripts/ 2>/dev/null || true
cp "$TEMP_DIR/scripts/setup_search.sh" scripts/ 2>/dev/null || true
cp "$TEMP_DIR/scripts/validate-all.sh" scripts/ 2>/dev/null || true
cp "$TEMP_DIR/scripts/validate-skills.sh" scripts/ 2>/dev/null || true
cp "$TEMP_DIR/scripts/validate-workflows.sh" scripts/ 2>/dev/null || true
cp "$TEMP_DIR/scripts/validate-templates.sh" scripts/ 2>/dev/null || true
cp "$TEMP_DIR/scripts/validate-dispatch.sh" scripts/ 2>/dev/null || true

# Step 9: Update Root Files (rules, not CONSTITUTION)
echo -e "⚙️ Copying core configuration files..."
cp "$TEMP_DIR/.agents/rules/PROJECT_RULES.md" .agents/rules/
cp "$TEMP_DIR/.agents/rules/QUANTIS-STYLE.md" .agents/rules/
cp "$TEMP_DIR/.quantis/VERSION" .quantis/

# Step 10: Replace GSD references in preserved state files
echo -e "🔄 Replacing GSD references with Quantis..."
find .quantis -type f -name "*.md" | while read -r file; do
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's/\.gsd\//\.quantis\//g' "$file" 2>/dev/null || true
        sed -i '' 's/GSD/Quantis/g' "$file" 2>/dev/null || true
    else
        sed -i 's/\.gsd\//\.quantis\//g' "$file" 2>/dev/null || true
        sed -i 's/GSD/Quantis/g' "$file" 2>/dev/null || true
    fi
done

if [ -f ".agents/rules/CONSTITUTION.md" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's/GSD/Quantis/g' .agents/rules/CONSTITUTION.md 2>/dev/null || true
        sed -i '' 's/Get Shit Done/Quantis/g' .agents/rules/CONSTITUTION.md 2>/dev/null || true
    else
        sed -i 's/GSD/Quantis/g' .agents/rules/CONSTITUTION.md 2>/dev/null || true
        sed -i 's/Get Shit Done/Quantis/g' .agents/rules/CONSTITUTION.md 2>/dev/null || true
    fi
fi

# Step 11: Cleanup
rm -rf "$TEMP_DIR"

echo -e "🧹 Upgrade clean up complete."
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}             Quantis ► UPGRADED SUCCESSFULLY ✓        ${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
echo -e "Summary:"
echo -e "  • Old GSD core skills removed: $removed_count"
echo -e "  • Skills installed: $(ls .agents/skills/ | wc -w | xargs)"
echo -e "  • Workflows installed: $(ls -d .agents/skills/wf-* 2>/dev/null | wc -l | xargs)"
echo -e "  • Rules: $(ls .agents/rules/ | wc -l | xargs) files in .agents/rules/ (auto-discovered)"
echo -e "  • Templates updated: $(ls .quantis/templates/ | wc -w | xargs)"
echo -e "  • User state preserved: .quantis/*"
echo -e ""
echo -e "Next steps:"
echo -e "  1. Open your AI agent in this project."
echo -e "  2. Run ${BLUE}/wf-progress${NC} to see your current position."
echo -e "  3. Run ${BLUE}/wf-whats-new${NC} to see what's new!"
echo -e ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
