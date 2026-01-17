# PowerShell uninstallation script for generate_avd_data plugin
# Requires PowerShell 5.1 or higher

$ErrorActionPreference = "Stop"

# Plugin information
$PluginName = "generate_avd_data"

Write-Host "========================================" -ForegroundColor Yellow
Write-Host "Uninstalling $PluginName" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

# Determine Claude plugin directory
if ($env:CLAUDE_PLUGINS_DIR) {
    $PluginsDir = $env:CLAUDE_PLUGINS_DIR
} else {
    $PluginsDir = Join-Path $env:APPDATA "Claude\plugins"
}

$InstallDir = Join-Path $PluginsDir $PluginName

# Check if plugin is installed
if (-not (Test-Path $InstallDir)) {
    Write-Host "Plugin is not installed at: $InstallDir" -ForegroundColor Yellow
    exit 0
}

Write-Host "Plugin directory: $InstallDir"
Write-Host ""

# Confirm uninstallation
$confirmation = Read-Host "Are you sure you want to uninstall $PluginName? (y/N)"
if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
    Write-Host "Uninstallation cancelled."
    exit 0
}

# Remove plugin directory
Write-Host "Removing plugin files..."
Remove-Item -Recurse -Force $InstallDir

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Uninstallation completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Plugin removed from: $InstallDir"
Write-Host ""

exit 0
