#!/usr/bin/env bash
# Quick verification script to ensure the 404 error is fixed

echo "Testing that install-remote.sh downloads the correct files..."
echo ""

REPO_BRANCH="main"
REPO_URL="https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/${REPO_BRANCH}"

# Test each file that install-remote.sh tries to download
FILES=(
    "claude_plugin.json"
    "docs/skills/generate_avd_data.md"
    "docs/skills/index.md"
    "docs/skills/metadata.json"
    "docs/examples/eos_designs_minimal_fabric.yml"
    "docs/examples/pyavd_hello_world.py"
    "README.md"
    "QUICK_INSTALL.md"
    "LICENSE"
)

FAILED=0

for file in "${FILES[@]}"; do
    echo -n "Checking $file... "
    if curl -fsSL -I "${REPO_URL}/${file}" > /dev/null 2>&1; then
        echo "✓ OK"
    else
        echo "✗ FAILED (404)"
        FAILED=$((FAILED + 1))
    fi
done

echo ""
if [ $FAILED -eq 0 ]; then
    echo "✅ All files are accessible - no 404 errors!"
    exit 0
else
    echo "❌ $FAILED file(s) returned 404 errors"
    exit 1
fi
