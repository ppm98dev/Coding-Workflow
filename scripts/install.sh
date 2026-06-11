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
mkdir -p .agents/skills .gemini .quantis adapters docs scripts

# Copy structures
cp -r "$TEMP_DIR/.agents/" ./
cp -r "$TEMP_DIR/.gemini/" ./
cp -r "$TEMP_DIR/adapters/" ./

# Copy specific docs to prevent framework pollution
cp "$TEMP_DIR/docs/model-selection-playbook.md" docs/ 2>/dev/null || true
cp "$TEMP_DIR/docs/runbook.md" docs/ 2>/dev/null || true
cp "$TEMP_DIR/docs/token-optimization-guide.md" docs/ 2>/dev/null || true

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

# Copy root files
cp "$TEMP_DIR/CONSTITUTION.md" ./
cp "$TEMP_DIR/PROJECT_RULES.md" ./
cp "$TEMP_DIR/QUANTIS-STYLE.md" ./
cp "$TEMP_DIR/VERSION" ./
cp "$TEMP_DIR/model_capabilities.yaml" ./

# Cleanup
rm -rf "$TEMP_DIR"

echo -e "🧹 Installation clean up complete."
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}             Quantis ► INSTALLED SUCCESSFULLY ✓       ${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
echo -e "Next steps:"
echo -e "  1. Open your AI agent in this project."
echo -e "  2. Run ${BLUE}/new-project${NC} in the chat to initialize your project spec."
echo -e ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
