# Changelog

## [Unreleased]

### Fixed
- Fixed 404 error in `install-remote.sh` - changed from non-existent `INSTALL.md` to `QUICK_INSTALL.md`

### Added
- Forgejo CI/CD workflow for automated testing of installation scripts
- Local test script (`test-install.sh`) for pre-commit validation
- CI testing documentation (`CI_TESTING.md`)
- Workflow documentation in `.forgejo/workflows/README.md`

### Testing
- Automated tests for local Copilot installation
- Automated tests for local Claude installation  
- Automated tests for remote Copilot installation
- Automated tests for remote Claude installation
- Script syntax validation
- Uninstallation verification

