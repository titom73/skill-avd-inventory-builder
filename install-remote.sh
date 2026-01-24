#!/usr/bin/env bash
set -euo pipefail

# Standalone installation script for generate_avd_data skill
# This script downloads and installs the skill without requiring git clone
#
# Usage:
#   Interactive mode:
#     curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
#
#   Non-interactive mode for GitHub Copilot:
#     curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash -s -- --copilot
#     or with environment variable:
#     INSTALL_MODE=copilot curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
#
#   Non-interactive mode for Claude Plugin:
#     curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash -s -- --claude
#     or with environment variable:
#     INSTALL_MODE=claude curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
#
#   Skip PyAVD installation prompt:
#     INSTALL_MODE=copilot INSTALL_PYAVD=no curl -fsSL ... | bash
#     INSTALL_MODE=copilot INSTALL_PYAVD=yes curl -fsSL ... | bash
#
#   Skip Copilot instructions prompt:
#     INSTALL_MODE=copilot CREATE_COPILOT_INSTRUCTIONS=no curl -fsSL ... | bash
#     INSTALL_MODE=copilot CREATE_COPILOT_INSTRUCTIONS=yes curl -fsSL ... | bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Plugin information
PLUGIN_NAME="generate_avd_data"
PLUGIN_VERSION="1.0.0"
REPO_URL="https://github.com/titom73/skill-avd-inventory-builder"
REPO_BRANCH="main"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --copilot)
            INSTALL_MODE="1"
            shift
            ;;
        --claude)
            INSTALL_MODE="2"
            shift
            ;;
        --help|-h)
            cat << 'HELP'
Usage: install-remote.sh [OPTIONS]

Options:
  --copilot       Install for GitHub Copilot (non-interactive)
  --claude        Install for Claude Plugin (non-interactive)
  --help, -h      Show this help message

Environment Variables:
  INSTALL_MODE                    Set to 'copilot' or 'claude' for non-interactive mode
  INSTALL_PYAVD                   Set to 'yes' or 'no' to skip PyAVD installation prompt
  CREATE_COPILOT_INSTRUCTIONS     Set to 'yes' or 'no' to skip Copilot instructions prompt

Examples:
  # Interactive mode
  curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash

  # Non-interactive for GitHub Copilot
  curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash -s -- --copilot

  # Non-interactive with environment variables
  INSTALL_MODE=copilot curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash

  # Fully automated Copilot installation
  INSTALL_MODE=copilot INSTALL_PYAVD=yes CREATE_COPILOT_INSTRUCTIONS=yes \
    curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash

  # Fully automated Claude installation
  INSTALL_MODE=claude INSTALL_PYAVD=no \
    curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
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

# Check environment variable for non-interactive mode
if [[ -z "${INSTALL_MODE:-}" ]]; then
    # Interactive mode - no environment variable set
    INTERACTIVE=true
else
    # Non-interactive mode - environment variable set
    INTERACTIVE=false
    case "${INSTALL_MODE,,}" in
        copilot|1)
            INSTALL_MODE="1"
            ;;
        claude|2)
            INSTALL_MODE="2"
            ;;
        *)
            echo -e "${RED}Error: Invalid INSTALL_MODE value. Use 'copilot' or 'claude'${NC}"
            exit 1
            ;;
    esac
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Installing ${PLUGIN_NAME} v${PLUGIN_VERSION}${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if we're in a git repo
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    IN_GIT_REPO=true
    echo -e "${BLUE}ℹ Git repository detected${NC}"
else
    IN_GIT_REPO=false
fi

# Determine installation type
if [[ "$INTERACTIVE" == true ]]; then
    echo "Select installation mode:"
    echo "  1) GitHub Copilot (install to current project)"
    echo "  2) Claude Plugin (install to Claude plugins directory)"
    echo ""
    read -p "Enter your choice (1 or 2): " -n 1 -r INSTALL_MODE
    echo ""
    echo ""

    if [[ ! $INSTALL_MODE =~ ^[12]$ ]]; then
        echo -e "${RED}Error: Invalid choice. Please select 1 or 2${NC}"
        exit 1
    fi
else
    if [[ "$INSTALL_MODE" == "1" ]]; then
        echo -e "${BLUE}Running in non-interactive mode: GitHub Copilot${NC}"
    else
        echo -e "${BLUE}Running in non-interactive mode: Claude Plugin${NC}"
    fi
    echo ""
fi

# Determine installation directory based on mode
if [[ "$INSTALL_MODE" == "1" ]]; then
    # GitHub Copilot mode
    if [[ "$IN_GIT_REPO" == false ]]; then
        echo -e "${RED}Error: Not in a git repository${NC}"
        echo "For GitHub Copilot installation, please run this script from within your project."
        exit 1
    fi
    
    GIT_ROOT=$(git rev-parse --show-toplevel)
    INSTALL_DIR="$GIT_ROOT/docs/skills/$PLUGIN_NAME"
    echo -e "${BLUE}Installing to project: $GIT_ROOT${NC}"
    
elif [[ "$INSTALL_MODE" == "2" ]]; then
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
    echo -e "${BLUE}Installing to Claude plugins: $PLUGINS_DIR${NC}"
fi

echo "Target directory: $INSTALL_DIR"
echo ""

# Create temporary directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo "Downloading skill files from GitHub..."

# Function to download file from GitHub
download_file() {
    local file_path="$1"
    local output_path="$2"
    local url="https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/${REPO_BRANCH}/${file_path}"
    
    if command -v curl &> /dev/null; then
        curl -fsSL "$url" -o "$output_path"
    elif command -v wget &> /dev/null; then
        wget -q "$url" -O "$output_path"
    else
        echo -e "${RED}Error: Neither curl nor wget found. Please install one of them.${NC}"
        exit 1
    fi
}

# Create temporary structure
mkdir -p "$TEMP_DIR/docs/skills"
mkdir -p "$TEMP_DIR/docs/examples"

# Download files
echo "  - Downloading manifest..."
download_file "claude_plugin.json" "$TEMP_DIR/claude_plugin.json"

echo "  - Downloading skill documentation..."
download_file "docs/skills/generate_avd_data.md" "$TEMP_DIR/docs/skills/generate_avd_data.md"
download_file "docs/skills/index.md" "$TEMP_DIR/docs/skills/index.md"
download_file "docs/skills/metadata.json" "$TEMP_DIR/docs/skills/metadata.json"

echo "  - Downloading examples..."
download_file "docs/examples/eos_designs_minimal_fabric.yml" "$TEMP_DIR/docs/examples/eos_designs_minimal_fabric.yml"
download_file "docs/examples/pyavd_hello_world.py" "$TEMP_DIR/docs/examples/pyavd_hello_world.py"

echo "  - Downloading documentation..."
download_file "README.md" "$TEMP_DIR/README.md"
download_file "QUICK_INSTALL.md" "$TEMP_DIR/QUICK_INSTALL.md"
download_file "LICENSE" "$TEMP_DIR/LICENSE"

echo -e "${GREEN}✓ Download completed${NC}"
echo ""

# Create installation directory
echo "Creating installation directory..."
mkdir -p "$INSTALL_DIR/docs/skills"
mkdir -p "$INSTALL_DIR/docs/examples"

# Copy files
echo "Installing skill files..."
cp -f "$TEMP_DIR/claude_plugin.json" "$INSTALL_DIR/"
cp -f "$TEMP_DIR/README.md" "$INSTALL_DIR/"
cp -f "$TEMP_DIR/QUICK_INSTALL.md" "$INSTALL_DIR/"
cp -f "$TEMP_DIR/LICENSE" "$INSTALL_DIR/"

cp -f "$TEMP_DIR/docs/skills/generate_avd_data.md" "$INSTALL_DIR/docs/skills/"
cp -f "$TEMP_DIR/docs/skills/index.md" "$INSTALL_DIR/docs/skills/"
cp -f "$TEMP_DIR/docs/skills/metadata.json" "$INSTALL_DIR/docs/skills/"

cp -f "$TEMP_DIR/docs/examples/eos_designs_minimal_fabric.yml" "$INSTALL_DIR/docs/examples/"
cp -f "$TEMP_DIR/docs/examples/pyavd_hello_world.py" "$INSTALL_DIR/docs/examples/"

# Mode-specific post-installation
if [[ "$INSTALL_MODE" == "1" ]]; then
    # GitHub Copilot mode - create .copilot-instructions if needed
    COPILOT_INSTRUCTIONS="$GIT_ROOT/.github/copilot-instructions.md"
    
    if [[ ! -f "$COPILOT_INSTRUCTIONS" ]]; then
        CREATE_INSTRUCTIONS=false
        
        # Check environment variable first
        if [[ -n "${CREATE_COPILOT_INSTRUCTIONS:-}" ]]; then
            case "${CREATE_COPILOT_INSTRUCTIONS,,}" in
                yes|y|true|1)
                    CREATE_INSTRUCTIONS=true
                    ;;
                no|n|false|0)
                    CREATE_INSTRUCTIONS=false
                    ;;
                *)
                    echo -e "${YELLOW}Warning: Invalid CREATE_COPILOT_INSTRUCTIONS value, asking user${NC}"
                    ;;
            esac
        fi
        
        # Interactive prompt if not set by environment variable
        if [[ "$INTERACTIVE" == true ]] && [[ -z "${CREATE_COPILOT_INSTRUCTIONS:-}" ]]; then
            echo ""
            read -p "Create .github/copilot-instructions.md to help Copilot use this skill? (Y/n): " -n 1 -r
            echo ""
            
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                CREATE_INSTRUCTIONS=true
            fi
        fi
        
        if [[ "$CREATE_INSTRUCTIONS" == true ]]; then
            mkdir -p "$GIT_ROOT/.github"
            cat > "$COPILOT_INSTRUCTIONS" << 'EOF'
# GitHub Copilot Instructions

## Available Skills

### generate_avd_data - PyAVD Network Configuration Builder

Location: `docs/skills/generate_avd_data/`

This skill provides comprehensive knowledge for generating Arista AVD network configurations using PyAVD.

**When to use:**
- Generating YAML configuration for EOS Designs
- Creating Python scripts using PyAVD
- Building network fabric designs
- Working with Arista AVD data models

**How to use:**
Reference the skill documentation in `docs/skills/generate_avd_data/docs/skills/generate_avd_data.md` when generating configurations or scripts for Arista AVD.

**Examples available:**
- `docs/skills/generate_avd_data/docs/examples/eos_designs_minimal_fabric.yml`
- `docs/skills/generate_avd_data/docs/examples/pyavd_hello_world.py`
EOF
            echo -e "${GREEN}✓ Created .github/copilot-instructions.md${NC}"
        fi
    fi
fi

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
        
        SHOULD_INSTALL_PYAVD=false
        
        # Check environment variable first
        if [[ -n "${INSTALL_PYAVD:-}" ]]; then
            case "${INSTALL_PYAVD,,}" in
                yes|y|true|1)
                    SHOULD_INSTALL_PYAVD=true
                    ;;
                no|n|false|0)
                    SHOULD_INSTALL_PYAVD=false
                    ;;
                *)
                    echo -e "${YELLOW}Warning: Invalid INSTALL_PYAVD value, asking user${NC}"
                    ;;
            esac
        fi
        
        # Interactive prompt if not set by environment variable
        if [[ "$INTERACTIVE" == true ]] && [[ -z "${INSTALL_PYAVD:-}" ]]; then
            echo ""
            read -p "Install PyAVD now? (Y/n): " -n 1 -r
            echo ""
            
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                SHOULD_INSTALL_PYAVD=true
            fi
        fi
        
        if [[ "$SHOULD_INSTALL_PYAVD" == true ]]; then
            echo "Installing PyAVD..."
            pip3 install pyavd
            echo -e "${GREEN}✓ PyAVD installed${NC}"
        else
            echo ""
            echo "To install PyAVD later, run:"
            echo "  pip3 install pyavd"
            echo ""
        fi
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

if [[ "$INSTALL_MODE" == "1" ]]; then
    echo "GitHub Copilot Usage:"
    echo "  In Copilot Chat, reference the skill:"
    echo "  'Using the generate_avd_data skill in docs/skills/generate_avd_data/,"
    echo "   create a 2-spine / 4-leaf fabric design.'"
    echo ""
    echo "  The skill documentation is available at:"
    echo "  $INSTALL_DIR/docs/skills/generate_avd_data.md"
else
    echo "Claude Plugin Usage:"
    echo "  In Claude, reference the skill in your prompts:"
    echo "  'Using the generate_avd_data skill, create a fabric design...'"
    echo ""
    echo "  Examples available at:"
    echo "  $INSTALL_DIR/docs/examples/"
fi

echo ""
echo "For more information:"
echo "  Repository: $REPO_URL"
echo "  Documentation: $INSTALL_DIR/README.md"
echo ""

exit 0
