#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Plugin information
PLUGIN_NAME="generate_avd_data"

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}Uninstalling ${PLUGIN_NAME}${NC}"
echo -e "${YELLOW}========================================${NC}"
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

# Check if plugin is installed
if [[ ! -d "$INSTALL_DIR" ]]; then
    echo -e "${YELLOW}Plugin is not installed at: $INSTALL_DIR${NC}"
    exit 0
fi

echo "Plugin directory: $INSTALL_DIR"
echo ""

# Confirm uninstallation
read -p "Are you sure you want to uninstall $PLUGIN_NAME? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

# Remove plugin directory
echo "Removing plugin files..."
rm -rf "$INSTALL_DIR"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Uninstallation completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Plugin removed from: $INSTALL_DIR"
echo ""

exit 0
