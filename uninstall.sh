#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Plugin information
PLUGIN_NAME="generate_avd_data"

# Parse command line arguments
YES_FLAG=false
UNINSTALL_MODE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --yes|-y)
            YES_FLAG=true
            shift
            ;;
        --copilot)
            UNINSTALL_MODE="copilot"
            shift
            ;;
        --claude)
            UNINSTALL_MODE="claude"
            shift
            ;;
        --help|-h)
            cat << 'HELP'
Usage: uninstall.sh [OPTIONS]

Options:
  --copilot       Uninstall from GitHub Copilot project (non-interactive)
  --claude        Uninstall from Claude Plugin directory (non-interactive)
  --yes, -y       Skip confirmation prompt
  --help, -h      Show this help message

Examples:
  # Interactive mode
  ./uninstall.sh

  # Non-interactive Copilot uninstall
  ./uninstall.sh --copilot --yes

  # Non-interactive Claude uninstall  
  ./uninstall.sh --claude --yes
HELP
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}Uninstalling ${PLUGIN_NAME}${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

# Determine installation directory based on mode
if [[ "$UNINSTALL_MODE" == "copilot" ]]; then
    # GitHub Copilot mode
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo -e "${RED}Error: Not in a git repository${NC}"
        echo "For GitHub Copilot uninstallation, please run this script from within your project."
        exit 1
    fi
    
    GIT_ROOT=$(git rev-parse --show-toplevel)
    INSTALL_DIR="$GIT_ROOT/docs/skills/$PLUGIN_NAME"
    echo -e "${BLUE}Uninstalling from project: $GIT_ROOT${NC}"
    
elif [[ "$UNINSTALL_MODE" == "claude" ]]; then
    # Claude Plugin mode
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
    echo -e "${BLUE}Uninstalling from Claude plugins: $PLUGINS_DIR${NC}"
else
    # Interactive mode - try to detect automatically
    # First check if in git repo
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        GIT_ROOT=$(git rev-parse --show-toplevel)
        GIT_INSTALL_DIR="$GIT_ROOT/docs/skills/$PLUGIN_NAME"
    else
        GIT_INSTALL_DIR=""
    fi
    
    # Check Claude plugins directory
    if [[ -n "${CLAUDE_PLUGINS_DIR:-}" ]]; then
        PLUGINS_DIR="$CLAUDE_PLUGINS_DIR"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        PLUGINS_DIR="$HOME/Library/Application Support/Claude/plugins"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        PLUGINS_DIR="$HOME/.config/claude/plugins"
    fi
    CLAUDE_INSTALL_DIR="$PLUGINS_DIR/$PLUGIN_NAME"
    
    # Determine which installation exists
    if [[ -d "$GIT_INSTALL_DIR" ]] && [[ -d "$CLAUDE_INSTALL_DIR" ]]; then
        echo "Found installations in both locations:"
        echo "  1) GitHub Copilot: $GIT_INSTALL_DIR"
        echo "  2) Claude Plugin: $CLAUDE_INSTALL_DIR"
        echo ""
        read -p "Which installation to remove? (1 or 2): " -n 1 -r
        echo ""
        
        if [[ $REPLY == "1" ]]; then
            INSTALL_DIR="$GIT_INSTALL_DIR"
        elif [[ $REPLY == "2" ]]; then
            INSTALL_DIR="$CLAUDE_INSTALL_DIR"
        else
            echo "Invalid choice. Exiting."
            exit 1
        fi
    elif [[ -d "$GIT_INSTALL_DIR" ]]; then
        INSTALL_DIR="$GIT_INSTALL_DIR"
    elif [[ -d "$CLAUDE_INSTALL_DIR" ]]; then
        INSTALL_DIR="$CLAUDE_INSTALL_DIR"
    else
        echo -e "${YELLOW}Plugin is not installed${NC}"
        exit 0
    fi
fi

# Check if plugin is installed
if [[ ! -d "$INSTALL_DIR" ]]; then
    echo -e "${YELLOW}Plugin is not installed at: $INSTALL_DIR${NC}"
    exit 0
fi

echo "Plugin directory: $INSTALL_DIR"
echo ""

# Confirm uninstallation
if [[ "$YES_FLAG" == false ]]; then
    read -p "Are you sure you want to uninstall $PLUGIN_NAME? (y/N): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Uninstallation cancelled."
        exit 0
    fi
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
