#!/usr/bin/env bash
set -euo pipefail

# Style definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}             Quantis ► INSTALLER                     ${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check for git
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is required to install Quantis.${NC}"
    exit 1
fi

# Temp directory
TEMP_DIR=".quantis-install-temp-$(date +%s)"

echo -e "📥 Cloning Quantis from GitHub..."
if ! git clone --depth 1 https://github.com/ppm98dev/Coding-Workflow.git "$TEMP_DIR" &>/dev/null; then
    echo -e "${RED}Error: Failed to clone Quantis repository.${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo -e "⚙️ Copying core files..."
# Create target folders if they don't exist
mkdir -p .agents/skills .agents/rules .gemini .quantis adapters docs scripts

# Copy structures
cp -r "$TEMP_DIR/.agents/" ./
cp -r "$TEMP_DIR/.gemini/" ./
cp "$TEMP_DIR/adapters/ANTIGRAVITY.md" adapters/

# Copy specific docs to prevent framework pollution

# Copy specific scripts to prevent framework pollution
cp "$TEMP_DIR/scripts/search_repo.sh" scripts/ 2>/dev/null || true
cp "$TEMP_DIR/scripts/setup_search.sh" scripts/ 2>/dev/null || true
cp "$TEMP_DIR/scripts/validate-all.sh" scripts/ 2>/dev/null || true
cp "$TEMP_DIR/scripts/validate-skills.sh" scripts/ 2>/dev/null || true
cp "$TEMP_DIR/scripts/validate-workflows.sh" scripts/ 2>/dev/null || true
cp "$TEMP_DIR/scripts/validate-templates.sh" scripts/ 2>/dev/null || true

# Copy only .quantis templates (NOT the source repo's own dev state)
mkdir -p .quantis/templates
cp -r "$TEMP_DIR/.quantis/templates/" .quantis/

# Root files
cp "$TEMP_DIR/VERSION" ./

# Clean up any legacy directories from older installs
if [ -d ".agent" ]; then
    rm -rf .agent
    echo -e "  🧹 Removed legacy .agent/ directory"
fi

# Clean up legacy root rules files — move to .agents/rules/ if not already there
# NOTE: Existing rules in .agents/rules/ are NEVER deleted
for f in PROJECT_RULES.md QUANTIS-STYLE.md; do
    [ -f "$f" ] && rm "$f" && echo -e "  🧹 Removed legacy root $f (now in .agents/rules/)"
done
# Migrate CONSTITUTION.md if at root and not yet in .agents/rules/
if [ -f "CONSTITUTION.md" ] && [ ! -f ".agents/rules/CONSTITUTION.md" ]; then
    mv "CONSTITUTION.md" ".agents/rules/"
    echo -e "  📦 Migrated CONSTITUTION.md → .agents/rules/"
elif [ -f "CONSTITUTION.md" ]; then
    rm "CONSTITUTION.md"
    echo -e "  🧹 Removed legacy root CONSTITUTION.md"
fi

# Clean up dead files from older versions
rm -f model_capabilities.yaml
rm -f adapters/CLAUDE.md adapters/GEMINI.md adapters/GPT_OSS.md
rm -f GSD-STYLE.md

# Remove old _wf-* symlinks (replaced by wf-* real dirs)
find .agents/skills/ -maxdepth 1 -name '_wf-*' 2>/dev/null | while read -r link; do
    rm -rf "$link"
done

# Cleanup
rm -rf "$TEMP_DIR"

echo -e "🧹 Installation clean up complete."
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}             Quantis ► INSTALLED SUCCESSFULLY ✓       ${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
echo -e "Installed:"
echo -e "  • .agents/skills/   $(ls -d .agents/skills/wf-* 2>/dev/null | wc -l | xargs) workflows + $(ls -d .agents/skills/[^w]* .agents/skills/w[^f]* 2>/dev/null | wc -l | xargs) skills"
echo -e "  • .agents/rules/    $(ls .agents/rules/ | wc -l | xargs) auto-discovered rules"
echo -e "  • .quantis/         templates + state"
echo -e ""
echo -e "Next steps:"
echo -e "  1. Open your AI agent in this project."
echo -e "  2. Run ${BLUE}/wf-new-project${NC} in the chat to initialize your project spec."
echo -e ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
