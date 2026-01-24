# CI/CD Testing for Installation Scripts

## Overview

This document describes the continuous integration setup for testing the installation scripts of the skill-avd project.

## Changes Made

### 1. Fixed Installation Script Bug

**Problem:** The `install-remote.sh` script was trying to download a non-existent file `INSTALL.md`, causing a 404 error.

**Solution:** Changed the script to download `QUICK_INSTALL.md` instead, which exists in the repository.

**Files Modified:**
- `install-remote.sh` (lines 226 and 241)

### 2. Forgejo CI Workflow

Created a comprehensive CI workflow that automatically tests installation scripts on every push or pull request.

**Location:** `.forgejo/workflows/test-install.yml`

**Test Jobs:**
1. **test-local-install-copilot**: Tests local installation for GitHub Copilot
2. **test-local-install-claude**: Tests local installation for Claude Plugin
3. **test-remote-install-copilot**: Tests remote installation for GitHub Copilot
4. **test-remote-install-claude**: Tests remote installation for Claude Plugin
5. **test-script-syntax**: Validates Bash script syntax

**What is Tested:**
- Script execution without errors
- All required files are downloaded and copied
- Directory structure is correct
- Copilot instructions are created when requested
- Uninstallation works correctly
- Script syntax is valid

### 3. Local Test Script

Created a local test script that can be run before committing changes.

**Location:** `test-install.sh`

**Usage:**
```bash
./test-install.sh
```

This script runs the same tests as the CI but locally, allowing developers to catch issues before pushing.

## How to Use

### Running Tests Locally

```bash
# Make the script executable (first time only)
chmod +x test-install.sh

# Run all tests
./test-install.sh
```

The script will:
- Test script syntax
- Test local Copilot installation
- Test remote Copilot installation
- Test Claude installation
- Test uninstallation

### CI/CD Integration

The workflow is automatically triggered on:
- Push to `main` or `develop` branches (when install scripts change)
- Pull requests to `main` or `develop` branches (when install scripts change)
- Manual workflow dispatch

### Manual Workflow Trigger

In Forgejo UI:
1. Go to Actions tab
2. Select "Test Installation Scripts" workflow
3. Click "Run workflow"

## Testing Different Scenarios

### Test Remote Installation (as end-user would)

```bash
# Create a test project
mkdir -p /tmp/test-project
cd /tmp/test-project
git init
git config user.email "test@example.com"
git config user.name "Test User"

# Test the installation
INSTALL_MODE=copilot \
INSTALL_PYAVD=no \
CREATE_COPILOT_INSTRUCTIONS=yes \
bash <(curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh)
```

### Test Local Installation

```bash
# Clone the repository
git clone https://github.com/titom73/skill-avd-inventory-builder.git
cd skill-avd-inventory-builder

# Run local tests
./test-install.sh
```

## Troubleshooting

### CI Tests Fail

1. **Check the logs**: Look at the failed job in Forgejo Actions
2. **Run locally**: Use `./test-install.sh` to reproduce the issue
3. **Verify files**: Ensure all required files exist in the repository

### Common Issues

**404 Errors:**
- Check that all files referenced in `install-remote.sh` exist in the repository
- Verify the branch name is correct (default: `main`)
- Ensure the GitHub repository URL is correct

**Permission Denied:**
- Make sure scripts are executable: `chmod +x *.sh`

**Git Not Found:**
- Ensure git is installed in the CI runner environment
- For Copilot mode, a git repository is required

## Files Overview

```
.
├── .forgejo/
│   └── workflows/
│       ├── test-install.yml      # CI workflow definition
│       └── README.md             # Workflow documentation
├── install.sh                    # Local installation script
├── install-remote.sh             # Remote installation script (FIXED)
├── uninstall.sh                  # Uninstallation script
├── test-install.sh               # Local test runner (NEW)
└── CI_TESTING.md                 # This document (NEW)
```

## Next Steps

1. **Push changes to repository**
2. **Verify CI runs successfully**
3. **Update documentation if needed**
4. **Test the fixed remote installation script manually**

## For Forgejo Administrators

### Requirements

- Forgejo Actions must be enabled
- Runners must be configured with:
  - Ubuntu or Linux environment
  - Python 3.11+
  - Git
  - curl or wget

### Runner Configuration

Example runner configuration for Forgejo:
```yaml
# .forgejo/runner/config.yml
labels:
  - "ubuntu-latest:docker://node:20-bullseye"
```

## Verification Checklist

Before marking this as complete:
- [ ] `install-remote.sh` downloads the correct file (`QUICK_INSTALL.md`)
- [ ] All local tests pass (`./test-install.sh`)
- [ ] CI workflow is created in `.forgejo/workflows/`
- [ ] Documentation is updated
- [ ] Scripts have correct permissions
- [ ] All files are committed to git

## Contact

For issues or questions about the CI setup, please open an issue in the repository.
