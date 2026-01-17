# PowerShell installation script for generate_avd_data plugin
# Requires PowerShell 5.1 or higher

$ErrorActionPreference = "Stop"

# Plugin information
$PluginName = "generate_avd_data"
$PluginVersion = "1.0.0"

Write-Host "========================================" -ForegroundColor Green
Write-Host "Installing $PluginName v$PluginVersion" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Determine Claude plugin directory
if ($env:CLAUDE_PLUGINS_DIR) {
    $PluginsDir = $env:CLAUDE_PLUGINS_DIR
} else {
    $PluginsDir = Join-Path $env:APPDATA "Claude\plugins"
}

$InstallDir = Join-Path $PluginsDir $PluginName

Write-Host "Target directory: $InstallDir"
Write-Host ""

# Create plugin directory
Write-Host "Creating plugin directory..."
New-Item -ItemType Directory -Force -Path "$InstallDir\docs\skills" | Out-Null
New-Item -ItemType Directory -Force -Path "$InstallDir\docs\examples" | Out-Null

# Copy files
Write-Host "Copying skill files..."
Copy-Item -Force "claude_plugin.json" "$InstallDir\"
Copy-Item -Force "README.md" "$InstallDir\"
Copy-Item -Force "INSTALL.md" "$InstallDir\"
Copy-Item -Force "LICENSE" "$InstallDir\"

Write-Host "Copying skills..."
Copy-Item -Force "docs\skills\generate_avd_data.md" "$InstallDir\docs\skills\"
Copy-Item -Force "docs\skills\index.md" "$InstallDir\docs\skills\"
Copy-Item -Force "docs\skills\metadata.json" "$InstallDir\docs\skills\"

Write-Host "Copying examples..."
Copy-Item -Force "docs\examples\eos_designs_minimal_fabric.yml" "$InstallDir\docs\examples\"
Copy-Item -Force "docs\examples\pyavd_hello_world.py" "$InstallDir\docs\examples\"

# Check Python version
Write-Host ""
Write-Host "Checking Python version..."
try {
    $PythonVersion = & python --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ $PythonVersion found" -ForegroundColor Green
        
        # Check if pyavd is installed
        $PyavdCheck = & python -c "import pyavd; print(pyavd.__version__)" 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ PyAVD $PyavdCheck is already installed" -ForegroundColor Green
        } else {
            Write-Host "⚠ PyAVD is not installed" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "To install PyAVD, run:"
            Write-Host "  pip install pyavd"
            Write-Host ""
        }
    }
} catch {
    Write-Host "⚠ Python not found" -ForegroundColor Yellow
    Write-Host "Python 3.10+ is required for this plugin"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Installation completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Plugin installed to: $InstallDir"
Write-Host ""
Write-Host "Usage:"
Write-Host "  In Claude, reference the skill in your prompts:"
Write-Host "  'Using the generate_avd_data skill, create a fabric design...'"
Write-Host ""
Write-Host "Examples available at:"
Write-Host "  $InstallDir\docs\examples\"
Write-Host ""

exit 0
