# Forgejo CI/CD Workflows

This directory contains Forgejo/GitHub Actions workflows for continuous integration and testing.

## Workflows

### test-install.yml

Tests all installation scripts to ensure they work correctly in both local and remote scenarios.

**Jobs:**
- `test-local-install-copilot`: Tests local installation for GitHub Copilot mode
- `test-local-install-claude`: Tests local installation for Claude Plugin mode
- `test-remote-install-copilot`: Tests remote installation for GitHub Copilot mode
- `test-remote-install-claude`: Tests remote installation for Claude Plugin mode
- `test-script-syntax`: Validates Bash script syntax

**Triggers:**
- Push to `main` or `develop` branches (when install scripts are modified)
- Pull requests to `main` or `develop` branches (when install scripts are modified)
- Manual workflow dispatch

**What is tested:**
- Script execution without errors
- Proper file creation in target directories
- Copilot instructions file creation
- Uninstallation functionality
- Script syntax validation

## Running Tests Locally

You can run the tests locally using act (GitHub Actions compatible runner) or by manually executing the scripts in test mode:

### Test Local Installation (Copilot)
```bash
# Create test environment
mkdir -p /tmp/test-project
cd /tmp/test-project
git init
git config user.email "test@example.com"
git config user.name "Test User"

# Run installation
INSTALL_MODE=copilot INSTALL_PYAVD=no CREATE_COPILOT_INSTRUCTIONS=yes bash /path/to/skill-avd/install.sh
```

### Test Remote Installation (Copilot)
```bash
# Create test environment
mkdir -p /tmp/test-remote-project
cd /tmp/test-remote-project
git init
git config user.email "test@example.com"
git config user.name "Test User"

# Run remote installation
INSTALL_MODE=copilot INSTALL_PYAVD=no CREATE_COPILOT_INSTRUCTIONS=yes bash /path/to/skill-avd/install-remote.sh
```

### Test Claude Installation
```bash
export CLAUDE_PLUGINS_DIR=/tmp/claude-test-plugins
mkdir -p $CLAUDE_PLUGINS_DIR

INSTALL_MODE=claude INSTALL_PYAVD=no bash /path/to/skill-avd/install.sh
```

## CI Configuration

For Forgejo, ensure the following:
1. Actions are enabled in your Forgejo instance
2. Runners are configured and available
3. Python 3.11+ is available in the runner environment

## Troubleshooting

### Tests fail with "file not found"
- Ensure all required files exist in the repository:
  - `README.md`
  - `QUICK_INSTALL.md`
  - `LICENSE`
  - `claude_plugin.json`
  - All files in `docs/skills/` and `docs/examples/`

### Remote installation fails with 404
- Check that the GitHub repository URL is correct in `install-remote.sh`
- Verify that the branch name is correct (default: `main`)
- Ensure all files being downloaded exist in the repository
