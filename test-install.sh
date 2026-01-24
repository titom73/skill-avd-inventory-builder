#!/usr/bin/env bash
# Local test script for installation scripts
# Run this before committing changes to verify everything works

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Testing Installation Scripts${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Test 1: Script syntax
echo -e "${BLUE}[1/5] Testing script syntax...${NC}"
bash -n "$SCRIPT_DIR/install.sh"
bash -n "$SCRIPT_DIR/install-remote.sh"
bash -n "$SCRIPT_DIR/uninstall.sh"
echo -e "${GREEN}✓ All scripts are syntactically correct${NC}"
echo ""

# Test 2: Local installation for GitHub Copilot
echo -e "${BLUE}[2/5] Testing local installation (GitHub Copilot)...${NC}"
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"
git init > /dev/null 2>&1
git config user.email "test@example.com"
git config user.name "Test User"
echo "# Test Project" > README.md
git add README.md > /dev/null 2>&1
git commit -m "Initial commit" > /dev/null 2>&1

INSTALL_MODE=copilot \
INSTALL_PYAVD=no \
CREATE_COPILOT_INSTRUCTIONS=yes \
bash "$SCRIPT_DIR/install.sh" > /dev/null 2>&1

# Verify installation
if [ ! -d "docs/skills/generate_avd_data" ]; then
    echo -e "${RED}✗ Installation directory not created${NC}"
    exit 1
fi

REQUIRED_FILES=(
    "docs/skills/generate_avd_data/claude_plugin.json"
    "docs/skills/generate_avd_data/README.md"
    "docs/skills/generate_avd_data/QUICK_INSTALL.md"
    "docs/skills/generate_avd_data/LICENSE"
    "docs/skills/generate_avd_data/docs/skills/generate_avd_data.md"
    "docs/skills/generate_avd_data/docs/skills/index.md"
    "docs/skills/generate_avd_data/docs/skills/metadata.json"
    "docs/skills/generate_avd_data/docs/examples/eos_designs_minimal_fabric.yml"
    "docs/skills/generate_avd_data/docs/examples/pyavd_hello_world.py"
    ".github/copilot-instructions.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}✗ Missing file: $file${NC}"
        exit 1
    fi
done

echo -e "${GREEN}✓ Local installation (GitHub Copilot) successful${NC}"
rm -rf "$TEST_DIR"
echo ""

# Test 3: Remote installation for GitHub Copilot
echo -e "${BLUE}[3/5] Testing remote installation (GitHub Copilot)...${NC}"
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"
git init > /dev/null 2>&1
git config user.email "test@example.com"
git config user.name "Test User"
echo "# Test Project" > README.md
git add README.md > /dev/null 2>&1
git commit -m "Initial commit" > /dev/null 2>&1

INSTALL_MODE=copilot \
INSTALL_PYAVD=no \
CREATE_COPILOT_INSTRUCTIONS=yes \
bash "$SCRIPT_DIR/install-remote.sh" > /dev/null 2>&1

# Verify installation
if [ ! -d "docs/skills/generate_avd_data" ]; then
    echo -e "${RED}✗ Remote installation directory not created${NC}"
    exit 1
fi

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}✗ Missing file: $file${NC}"
        exit 1
    fi
done

echo -e "${GREEN}✓ Remote installation (GitHub Copilot) successful${NC}"
rm -rf "$TEST_DIR"
echo ""

# Test 4: Claude installation
echo -e "${BLUE}[4/5] Testing local installation (Claude)...${NC}"
TEST_CLAUDE_DIR=$(mktemp -d)
export CLAUDE_PLUGINS_DIR="$TEST_CLAUDE_DIR"

cd "$SCRIPT_DIR"
INSTALL_MODE=claude \
INSTALL_PYAVD=no \
bash "$SCRIPT_DIR/install.sh" > /dev/null 2>&1

# Verify Claude installation
if [ ! -d "$CLAUDE_PLUGINS_DIR/generate_avd_data" ]; then
    echo -e "${RED}✗ Claude installation directory not created${NC}"
    exit 1
fi

CLAUDE_REQUIRED_FILES=(
    "$CLAUDE_PLUGINS_DIR/generate_avd_data/claude_plugin.json"
    "$CLAUDE_PLUGINS_DIR/generate_avd_data/README.md"
    "$CLAUDE_PLUGINS_DIR/generate_avd_data/docs/skills/generate_avd_data.md"
)

for file in "${CLAUDE_REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}✗ Missing file: $file${NC}"
        exit 1
    fi
done

echo -e "${GREEN}✓ Local installation (Claude) successful${NC}"
rm -rf "$TEST_CLAUDE_DIR"
unset CLAUDE_PLUGINS_DIR
echo ""

# Test 5: Uninstallation
echo -e "${BLUE}[5/5] Testing uninstallation...${NC}"
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"
git init > /dev/null 2>&1
git config user.email "test@example.com"
git config user.name "Test User"
echo "# Test Project" > README.md
git add README.md > /dev/null 2>&1
git commit -m "Initial commit" > /dev/null 2>&1

# Install first
INSTALL_MODE=copilot \
INSTALL_PYAVD=no \
CREATE_COPILOT_INSTRUCTIONS=no \
bash "$SCRIPT_DIR/install.sh" > /dev/null 2>&1

# Uninstall
bash "$SCRIPT_DIR/uninstall.sh" --copilot --yes > /dev/null 2>&1

# Verify uninstallation
if [ -d "docs/skills/generate_avd_data" ]; then
    echo -e "${RED}✗ Uninstallation failed - directory still exists${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Uninstallation successful${NC}"
rm -rf "$TEST_DIR"
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}All tests passed!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "The installation scripts are working correctly."
echo "You can safely commit your changes."
