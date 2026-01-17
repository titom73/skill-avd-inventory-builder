#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Plugin information
PLUGIN_NAME="generate_avd_data"
PLUGIN_VERSION="1.0.0"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Installing ${PLUGIN_NAME} v${PLUGIN_VERSION}${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Determine Claude plugin directory
if [[ -n "${CLAUDE_PLUGINS_DIR:-}" ]]; then
    PLUGINS_DIR="$CLAUDE_PLUGINS_DIR"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PLUGINS_DIR="$HOME/Library/Application Support/Claude/plugins"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLUGINS_DIR="$HOME/.config/claude/plugins"
else
    echo -e "${RED}Error: Unsupported operating system${NC}"
    exit 1
fi

INSTALL_DIR="$PLUGINS_DIR/$PLUGIN_NAME"

echo "Target directory: $INSTALL_DIR"
echo ""

# Create plugin directory
echo "Creating plugin directory..."
mkdir -p "$INSTALL_DIR/docs/skills"
mkdir -p "$INSTALL_DIR/docs/examples"

# Copy files
echo "Copying skill files..."
cp -f "claude_plugin.json" "$INSTALL_DIR/"
cp -f "README.md" "$INSTALL_DIR/"
cp -f "INSTALL.md" "$INSTALL_DIR/"
cp -f "LICENSE" "$INSTALL_DIR/"

echo "Copying skills..."
cp -f "docs/skills/generate_avd_data.md" "$INSTALL_DIR/docs/skills/"
cp -f "docs/skills/index.md" "$INSTALL_DIR/docs/skills/"
cp -f "docs/skills/metadata.json" "$INSTALL_DIR/docs/skills/"

echo "Copying examples..."
cp -f "docs/examples/eos_designs_minimal_fabric.yml" "$INSTALL_DIR/docs/examples/"
cp -f "docs/examples/pyavd_hello_world.py" "$INSTALL_DIR/docs/examples/"

# Check Python version
echo ""
echo "Checking Python version..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
    echo -e "${GREEN}✓ Python $PYTHON_VERSION found${NC}"
    
    # Check if pyavd is installed
    if python3 -c "import pyavd" 2>/dev/null; then
        PYAVD_VERSION=$(python3 -c "import pyavd; print(pyavd.__version__)" 2>/dev/null || echo "unknown")
        echo -e "${GREEN}✓ PyAVD $PYAVD_VERSION is already installed${NC}"
    else
        echo -e "${YELLOW}⚠ PyAVD is not installed${NC}"
        echo ""
        echo "To install PyAVD, run:"
        echo "  pip install pyavd"
        echo ""
    fi
else
    echo -e "${YELLOW}⚠ Python 3 not found${NC}"
    echo "Python 3.10+ is required for this plugin"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Installation completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Plugin installed to: $INSTALL_DIR"
echo ""
echo "Usage:"
echo "  In Claude, reference the skill in your prompts:"
echo "  'Using the generate_avd_data skill, create a fabric design...'"
echo ""
echo "Examples available at:"
echo "  $INSTALL_DIR/docs/examples/"
echo ""

exit 0
