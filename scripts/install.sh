#!/bin/bash
# install.sh — Install GSD for Antigravity into the current project
# Usage: bash install.sh [--force]

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO="https://github.com/ppm98dev/Coding-Workflow.git"
TEMP_DIR=".gsd-install-tmp"
FORCE=false

# Parse args
for arg in "$@"; do
  case $arg in
    --force) FORCE=true ;;
    --help|-h)
      echo "Usage: bash install.sh [--force]"
      echo ""
      echo "Install GSD for Antigravity into the current project."
      echo ""
      echo "Options:"
      echo "  --force    Overwrite existing GSD files"
      echo "  --help     Show this help"
      exit 0
      ;;
  esac
done

# Check for existing installation
if [ -d ".gsd" ] && [ "$FORCE" = false ]; then
  echo -e "${YELLOW}⚠  GSD already installed in this project.${NC}"
  echo "   Use --force to overwrite."
  exit 1
fi

echo -e "${GREEN}📦 Installing GSD for Antigravity...${NC}"

# Clone to temp
git clone --depth 1 --quiet "$REPO" "$TEMP_DIR" 2>/dev/null || {
  echo -e "${RED}❌ Failed to clone repository${NC}"
  exit 1
}

# Copy framework files
DIRS=(".agent" ".agents" ".gemini" ".gsd" "adapters" "docs" "scripts")
FILES=("PROJECT_RULES.md" "GSD-STYLE.md" "model_capabilities.yaml")

for dir in "${DIRS[@]}"; do
  cp -r "$TEMP_DIR/$dir" ./ 2>/dev/null && echo "  ✓ $dir/"
done

for file in "${FILES[@]}"; do
  cp "$TEMP_DIR/$file" ./ 2>/dev/null && echo "  ✓ $file"
done

# Clean up
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}✅ GSD installed successfully!${NC}"
echo ""
echo "Next steps:"
echo "  1. Run /new-project to create your SPEC.md"
echo "  2. Run /plan 1 to plan your first phase"
echo ""
