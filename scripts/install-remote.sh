#!/bin/bash
# Remote install script for AI Skills & Agents
# Downloads and installs skills/agents directly from GitHub without cloning
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/titom73/ai-skills-agent-arista/main/scripts/install-remote.sh | bash -s -- <platform> <type> <name> [target_path]
#   # Or download and run locally:
#   ./install-remote.sh <platform> <type> <name> [target_path]

set -e

# Configuration
REPO_OWNER="titom73"
REPO_NAME="ai-skills-agent-arista"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

usage() {
    echo -e "${BLUE}AI Skills & Agents - Remote Installer${NC}"
    echo ""
    echo "Usage: $0 <platform> <type> <name> [target_path]"
    echo ""
    echo "Arguments:"
    echo "  platform    : claude | copilot"
    echo "  type        : skill | agent"
    echo "  name        : Name of the skill/agent"
    echo "  target_path : (copilot only) Path to target repo"
    echo ""
    echo "Available skills:"
    echo "  - eos-fabric-design  : Arista EOS datacenter fabric design"
    echo "  - avd                : PyAVD network configuration builder"
    echo ""
    echo "Available agents:"
    echo "  - config-reviewer       : EOS configuration audit agent"
    echo "  - avd-config-generator  : AVD config generation orchestrator"
    echo ""
    echo "Examples:"
    echo "  $0 claude skill eos-fabric-design"
    echo "  $0 copilot skill avd /path/to/my/repo"
    echo "  $0 copilot agent config-reviewer /path/to/my/repo"
    echo ""
    echo "One-liner (no download needed):"
    echo "  curl -fsSL ${BASE_URL}/scripts/install-remote.sh | bash -s -- claude skill eos-fabric-design"
    exit 1
}

# Check for curl or wget
download() {
    local url="$1"
    if command -v curl &> /dev/null; then
        curl -fsSL "$url" 2>/dev/null
    elif command -v wget &> /dev/null; then
        wget -qO- "$url" 2>/dev/null
    else
        echo -e "${RED}Error: curl or wget required${NC}" >&2
        exit 1
    fi
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

# Build URL
if [ "$TYPE" == "skill" ]; then
    FILE_URL="${BASE_URL}/skills/${NAME}/${PLATFORM}.md"
else
    FILE_URL="${BASE_URL}/agents/${NAME}/${PLATFORM}.md"
fi

echo -e "${YELLOW}Fetching ${TYPE} '${NAME}' for ${PLATFORM}...${NC}"

# Download content
CONTENT=$(download "$FILE_URL")

if [ -z "$CONTENT" ]; then
    echo -e "${RED}Error: Failed to download ${TYPE} '${NAME}'${NC}"
    echo -e "${RED}URL: ${FILE_URL}${NC}"
    echo ""
    echo "Available skills: eos-fabric-design, avd"
    echo "Available agents: config-reviewer, avd-config-generator"
    exit 1
fi

# Handle installation
if [ "$PLATFORM" == "claude" ]; then
    echo -e "${YELLOW}Installing for Claude Code...${NC}"
    echo ""
    echo "Option 1: Copy to .claude/ folder"
    echo "Option 2: Use 'claude project add-instructions'"
    echo ""
    echo "========== START COPY =========="
    echo "$CONTENT"
    echo "=========== END COPY ==========="
    echo ""

    # Try to copy to clipboard
    if command -v pbcopy &> /dev/null; then
        echo "$CONTENT" | pbcopy
        echo -e "${GREEN}✓ Content copied to clipboard (macOS)${NC}"
    elif command -v xclip &> /dev/null; then
        echo "$CONTENT" | xclip -selection clipboard
        echo -e "${GREEN}✓ Content copied to clipboard (Linux)${NC}"
    elif command -v xsel &> /dev/null; then
        echo "$CONTENT" | xsel --clipboard
        echo -e "${GREEN}✓ Content copied to clipboard (Linux)${NC}"
    else
        echo -e "${YELLOW}Tip: Install pbcopy/xclip/xsel for automatic clipboard copy${NC}"
    fi

elif [ "$PLATFORM" == "copilot" ]; then
    if [ -z "$TARGET_PATH" ]; then
        echo -e "${RED}Error: target_path required for Copilot installation${NC}"
        usage
    fi

    if [ ! -d "$TARGET_PATH" ]; then
        echo -e "${RED}Error: Target path '$TARGET_PATH' does not exist${NC}"
        exit 1
    fi

    GITHUB_DIR="$TARGET_PATH/.github"
    mkdir -p "$GITHUB_DIR"

    TARGET_FILE="$GITHUB_DIR/copilot-instructions.md"

    echo -e "${YELLOW}Installing for GitHub Copilot...${NC}"
    echo "$CONTENT" > "$TARGET_FILE"
    echo -e "${GREEN}✓ Installed to $TARGET_FILE${NC}"
fi

echo ""
echo -e "${GREEN}Done!${NC}"

