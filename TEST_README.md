# Tests and CI/CD

This folder contains scripts and workflows to test the installation scripts.

## 🔧 Bug Fix

**Problem**: `install-remote.sh` returned a 404 error when downloading `INSTALL.md`

**Solution**: The file was replaced with `QUICK_INSTALL.md` which exists in the repository.

## 🧪 Local Tests

### Quick Test

To quickly test all installation scripts:

```bash
./test-install.sh
```

This script tests:
- ✅ Bash script syntax
- ✅ Local Copilot installation
- ✅ Remote Copilot installation
- ✅ Local Claude installation
- ✅ Uninstallation

### Remote Files Verification

To verify that all files are accessible on GitHub:

```bash
./verify-remote-files.sh
```

## 🚀 CI/CD Forgejo

The CI/CD workflow is located in `.forgejo/workflows/test-install.yml`.

### Automatic Trigger

The CI runs automatically on:
- Push to `main` or `develop` (when install scripts are modified)
- Pull requests to `main` or `develop` (when install scripts are modified)

### Manual Trigger

In the Forgejo UI:
1. Go to Actions tab
2. Select "Test Installation Scripts"
3. Click "Run workflow"

### Jobs Executed

1. **test-local-install-copilot** - Local Copilot installation
2. **test-local-install-claude** - Local Claude installation
3. **test-remote-install-copilot** - Remote Copilot installation
4. **test-remote-install-claude** - Remote Claude installation
5. **test-script-syntax** - Bash syntax validation

## 📝 Updated Scripts

### install.sh

Full support for both modes (Copilot and Claude) with:
- Interactive and non-interactive mode
- Environment variables
- Command line options

```bash
# Interactive
./install.sh

# Non-interactive Copilot
INSTALL_MODE=copilot INSTALL_PYAVD=no CREATE_COPILOT_INSTRUCTIONS=yes ./install.sh

# Non-interactive Claude
INSTALL_MODE=claude INSTALL_PYAVD=no ./install.sh
```

### install-remote.sh

Fixed 404 error:
- ✅ Downloads `QUICK_INSTALL.md` instead of `INSTALL.md`
- ✅ All other files unchanged

### uninstall.sh

New options:
```bash
# Interactive
./uninstall.sh

# Non-interactive Copilot
./uninstall.sh --copilot --yes

# Non-interactive Claude
./uninstall.sh --claude --yes
```

## 📚 Documentation

- **CI_TESTING.md** - Complete CI/CD guide
- **CHANGELOG.md** - Change history
- **.forgejo/workflows/README.md** - Workflow documentation

## ✅ Verification

Before committing:

```bash
# Check syntax
bash -n install.sh
bash -n install-remote.sh
bash -n uninstall.sh

# Run tests
./test-install.sh

# Verify remote files (requires push to GitHub)
./verify-remote-files.sh
```

## 🐛 Debugging

If tests fail:

1. **404 Error**: Check that all files exist in the repo
2. **Timeout**: Verify the script isn't waiting for user input
3. **Git error**: Make sure you're in a git repository for Copilot tests

## 📦 Structure

```
.
├── install.sh                      # Local installation script (MODIFIED)
├── install-remote.sh               # Remote installation script (FIXED)
├── uninstall.sh                    # Uninstallation script (IMPROVED)
├── test-install.sh                 # Automated tests (NEW)
├── verify-remote-files.sh          # GitHub files verification (NEW)
├── CI_TESTING.md                   # CI/CD documentation (NEW)
├── CHANGELOG.md                    # Change history (NEW)
├── TEST_README.md                  # This file (NEW)
└── .forgejo/
    └── workflows/
        ├── test-install.yml        # CI/CD workflow (NEW)
        └── README.md               # Workflow docs (NEW)
```

## 🎯 Next Steps

1. ✅ Fix 404 error - **DONE**
2. ✅ Create automated tests - **DONE**
3. ✅ Setup Forgejo CI - **DONE**
4. ⏭️ Push to repository
5. ⏭️ Verify CI runs successfully
6. ⏭️ Test remote installation from GitHub

## 💡 Tips

- Always run `./test-install.sh` before committing
- Forgejo CI requires configured runners
- Tests create temporary directories that are automatically cleaned up
- In case of issues, consult `CI_TESTING.md`
