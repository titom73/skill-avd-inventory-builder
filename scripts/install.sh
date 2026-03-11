#!/bin/bash
# Install script for AI Skills & Agents
# Usage: ./install.sh <platform> <type> <name> [target_path]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

usage() {
    echo "Usage: $0 <platform> <type> <name> [target_path]"
    echo ""
    echo "Arguments:"
    echo "  platform    : claude | copilot"
    echo "  type        : skill | agent"
    echo "  name        : Name of the skill/agent (e.g., eos-fabric-design)"
    echo "  target_path : (copilot only) Path to target repo"
    echo ""
    echo "Examples:"
    echo "  $0 claude skill eos-fabric-design"
    echo "  $0 copilot skill eos-fabric-design /path/to/my/repo"
    echo "  $0 copilot agent config-reviewer /path/to/my/repo"
    echo ""
    echo "Available skills:"
    ls -1 "$REPO_ROOT/skills" 2>/dev/null | grep -v "^_" | grep -v "README" || echo "  (none)"
    echo ""
    echo "Available agents:"
    ls -1 "$REPO_ROOT/agents" 2>/dev/null | grep -v "^_" | grep -v "README" || echo "  (none)"
    exit 1
}

# Check arguments
if [ $# -lt 3 ]; then
    usage
fi

PLATFORM="$1"
TYPE="$2"
NAME="$3"
TARGET_PATH="$4"

# Validate platform
if [[ "$PLATFORM" != "claude" && "$PLATFORM" != "copilot" ]]; then
    echo -e "${RED}Error: Invalid platform '$PLATFORM'. Use 'claude' or 'copilot'.${NC}"
    exit 1
fi

# Validate type
if [[ "$TYPE" != "skill" && "$TYPE" != "agent" ]]; then
    echo -e "${RED}Error: Invalid type '$TYPE'. Use 'skill' or 'agent'.${NC}"
    exit 1
fi

# Set source directory
if [ "$TYPE" == "skill" ]; then
    SOURCE_DIR="$REPO_ROOT/skills/$NAME"
else
    SOURCE_DIR="$REPO_ROOT/agents/$NAME"
fi

# Check if source exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}Error: $TYPE '$NAME' not found at $SOURCE_DIR${NC}"
    exit 1
fi

SOURCE_FILE="$SOURCE_DIR/$PLATFORM.md"

if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "${RED}Error: File '$SOURCE_FILE' not found${NC}"
    exit 1
fi

# Handle installation
if [ "$PLATFORM" == "claude" ]; then
    echo -e "${YELLOW}Installing for Claude Projects...${NC}"
    echo ""
    echo "Copy the following content to Claude Projects > Project Knowledge:"
    echo ""
    echo "========== START COPY =========="
    cat "$SOURCE_FILE"
    echo ""
    echo "=========== END COPY ==========="
    echo ""
    
    # Try to copy to clipboard
    if command -v pbcopy &> /dev/null; then
        cat "$SOURCE_FILE" | pbcopy
        echo -e "${GREEN}✓ Content copied to clipboard!${NC}"
    elif command -v xclip &> /dev/null; then
        cat "$SOURCE_FILE" | xclip -selection clipboard
        echo -e "${GREEN}✓ Content copied to clipboard!${NC}"
    else
        echo -e "${YELLOW}Note: Install pbcopy (macOS) or xclip (Linux) for automatic clipboard copy.${NC}"
    fi

elif [ "$PLATFORM" == "copilot" ]; then
    if [ -z "$TARGET_PATH" ]; then
        echo -e "${RED}Error: target_path is required for copilot installation${NC}"
        usage
    fi
    
    if [ ! -d "$TARGET_PATH" ]; then
        echo -e "${RED}Error: Target path '$TARGET_PATH' does not exist${NC}"
        exit 1
    fi
    
    # Create .github directory if needed
    GITHUB_DIR="$TARGET_PATH/.github"
    mkdir -p "$GITHUB_DIR"
    
    TARGET_FILE="$GITHUB_DIR/copilot-instructions.md"
    
    echo -e "${YELLOW}Installing for GitHub Copilot...${NC}"
    cp "$SOURCE_FILE" "$TARGET_FILE"
    echo -e "${GREEN}✓ Installed to $TARGET_FILE${NC}"
fi

echo ""
echo -e "${GREEN}Done!${NC}"

