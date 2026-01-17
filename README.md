# Generate AVD Data - AI Skill Plugin

This repository contains an AI skill plugin for generating Arista AVD (Arista Validated Designs) network configurations. The `generate_avd_data` skill enables AI assistants to construct valid network configurations using PyAVD's data models and schemas.

## Features

- **AI-ready skill documentation** for PyAVD network configuration generation
- **450+ schema fragments** for comprehensive network coverage
- **Intent-based network design** using EOS Designs
- **Device-specific configuration** generation with EOS CLI Config Gen
- **Ready-to-use examples** in Python and YAML

## Quick Install

### Via Claude Plugin Command (Recommended)

```bash
# Clone the repository
git clone https://github.com/titom73/skill-avd-inventory-builder.git
cd skill-avd

# Install the plugin
./install.sh        # Unix/macOS/Linux
# or
.\install.ps1       # Windows PowerShell
```

The plugin will be installed to your Claude plugins directory and will be immediately available for use.

### One-Line Remote Install (No Git Clone Required)

For **GitHub Copilot** or **Claude Plugin**, you can install directly without cloning:

#### Interactive Mode

```bash
# Download and run the installer - will prompt for choices
curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash

# Or using wget
wget -qO- https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
```

#### Automated Mode (No User Interaction)

**For GitHub Copilot:**
```bash
# Fully automated installation
INSTALL_MODE=copilot INSTALL_PYAVD=yes CREATE_COPILOT_INSTRUCTIONS=yes \
  curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
```

**For Claude Plugin:**
```bash
# Fully automated installation
INSTALL_MODE=claude INSTALL_PYAVD=yes \
  curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
```

**Environment Variables:**
- `INSTALL_MODE`: `copilot` or `claude` (required for non-interactive)
- `INSTALL_PYAVD`: `yes` or `no` (optional, skips PyAVD prompt)
- `CREATE_COPILOT_INSTRUCTIONS`: `yes` or `no` (optional, skips Copilot instructions prompt)

## What's Included

### Skills
- **[generate_avd_data](docs/skills/generate_avd_data.md)**: PyAVD Network Configuration Builder
  - Understanding PyAVD's dual-schema architecture
  - Building intent-based network designs
  - Generating device-specific configurations
  - Validating network data models

### Examples
- **[eos_designs_minimal_fabric.yml](docs/examples/eos_designs_minimal_fabric.yml)**: Minimal fabric example for EOS Designs
- **[pyavd_hello_world.py](docs/examples/pyavd_hello_world.py)**: Complete PyAVD workflow demonstration

### Documentation
- **[generate_avd_data.md](docs/skills/generate_avd_data.md)**: Comprehensive PyAVD schema reference
- **[Skills Index](docs/skills/index.md)**: Overview of all available skills

## Prerequisites

- **Python 3.10+** (required for PyAVD)
- **PyAVD 5.0.0+** (install with `pip install pyavd`)
- **Claude Desktop** or compatible AI environment

## Usage

Once installed, the skill is automatically available in your Claude environment. Reference it in your prompts:

```
Using the generate_avd_data skill, create a 2-spine / 4-leaf fabric design 
for a data center with BGP underlay and VXLAN overlay.
```

### Examples

```
Generate a minimal AVD fabric with:
- 1 spine (vEOS-lab platform)
- 2 leaf switches
- BGP AS 65000 for spine
- VXLAN EVPN overlay
```

For more detailed examples, see:
- [docs/examples/eos_designs_minimal_fabric.yml](docs/examples/eos_designs_minimal_fabric.yml)
- [docs/examples/pyavd_hello_world.py](docs/examples/pyavd_hello_world.py)

## Advanced Installation

For manual installation, vendoring into your project, or use with other AI assistants (GitHub Copilot, Gemini), see [INSTALL.md](INSTALL.md).

## Uninstallation

```bash
./uninstall.sh      # Unix/macOS/Linux
# or
.\uninstall.ps1     # Windows PowerShell
```

## License

This repository is licensed. See [LICENSE](LICENSE).

## Quick Links

- **[QUICK_INSTALL.md](QUICK_INSTALL.md)**: Complete installation and usage guide
- **[Skills Documentation](docs/skills/generate_avd_data.md)**: Full skill reference
