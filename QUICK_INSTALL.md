# Installation & Usage Guide

Complete guide for installing and using the `generate_avd_data` skill with GitHub Copilot, Claude, Gemini, and CI/CD platforms.

## Table of Contents

- [Quick Start](#quick-start)
- [Installation Methods](#installation-methods)
  - [One-Line Remote Install](#one-line-remote-install)
  - [Local Installation (Git Clone)](#local-installation-git-clone)
  - [Manual Installation](#manual-installation)
  - [Vendoring into Your Project](#vendoring-into-your-project)
- [Automated Installation](#automated-installation)
- [Environment Variables](#environment-variables)
- [Using with AI Assistants](#using-with-ai-assistants)
  - [GitHub Copilot](#using-with-github-copilot)
  - [Claude](#using-with-claude)
  - [Gemini](#using-with-gemini)
- [CI/CD Integration](#cicd-integration)
- [Advanced Integration](#advanced-integration)
- [Troubleshooting](#troubleshooting)
- [Uninstallation](#uninstallation)

---

## Quick Start

### Interactive Installation (Recommended)

Install without cloning the repository - the script will guide you:

```bash
# Using curl
curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
```

The script will:

1. Detect if you're in a git repository
2. Ask you to choose between **GitHub Copilot** or **Claude Plugin**
3. Download all files from GitHub
4. Install to the appropriate location
5. Optionally create `.github/copilot-instructions.md` (for Copilot)
6. Check Python and PyAVD installation
7. Optionally install PyAVD

### Fully Automated (CI/CD)

For GitHub Copilot:
```bash
INSTALL_MODE=copilot INSTALL_PYAVD=yes CREATE_COPILOT_INSTRUCTIONS=yes \
  curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
```

For Claude Plugin:

```bash
INSTALL_MODE=claude INSTALL_PYAVD=yes \
  curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
```

### Get Help

```bash
curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash -s -- --help
```

---

## Installation Methods

### One-Line Remote Install

**Best for**: Quick setup without cloning the repository.

#### Interactive Mode

```bash
curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
```

Choose installation mode when prompted:

- **Option 1**: GitHub Copilot (installs to `docs/skills/generate_avd_data/`)
- **Option 2**: Claude Plugin (installs to Claude plugins directory)

#### Non-Interactive Mode

**For GitHub Copilot:**

```bash
# With command-line flag
curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash -s -- --copilot

# With environment variable
INSTALL_MODE=copilot curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
```

**For Claude Plugin:**

```bash
# With command-line flag
curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash -s -- --claude

# With environment variable
INSTALL_MODE=claude curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
```

### Local Installation (Git Clone)

**Best for**: Development, customization, or contributing.

#### For Claude Plugin

```bash
# Clone the repository
git clone https://github.com/titom73/skill-avd-inventory-builder.git
cd skill-avd

# Run the installation script
./install.sh        # Unix/macOS/Linux
# or
.\install.ps1       # Windows PowerShell
```

**Installation Locations:**

- macOS: `~/Library/Application Support/Claude/plugins/generate_avd_data/`
- Linux: `~/.config/claude/plugins/generate_avd_data/`
- Windows: `%APPDATA%\Claude\plugins\generate_avd_data\`

Override default location with `CLAUDE_PLUGINS_DIR` environment variable.

#### For GitHub Copilot

1. Clone this repository into your project or alongside it
2. Optionally vendor the skills into your project (see [Vendoring](#vendoring-into-your-project))

### Manual Installation

**Best for**: Custom setups or when you need full control.

#### For Claude Plugin

```bash
# Create plugin directory
mkdir -p "$HOME/.config/claude/plugins/generate_avd_data"

# Copy files (assumes you've cloned the repo)
cp -r docs/ "$HOME/.config/claude/plugins/generate_avd_data/"
cp claude_plugin.json "$HOME/.config/claude/plugins/generate_avd_data/"

# Install PyAVD
pip3 install pyavd
```

#### For GitHub Copilot

```bash
# In your project directory
mkdir -p docs/skills/generate_avd_data

# Copy skill files
cp -r <skill-avd-repo>/docs/ docs/skills/generate_avd_data/

# Optionally create Copilot instructions
mkdir -p .github
cat > .github/copilot-instructions.md << 'INSTRUCTIONS'
# GitHub Copilot Instructions

## Available Skills

### generate_avd_data - PyAVD Network Configuration Builder

Location: `docs/skills/generate_avd_data/`

When generating Arista AVD configurations, reference the skill documentation
in `docs/skills/generate_avd_data/docs/skills/generate_avd_data.md`.
INSTRUCTIONS
```

### Vendoring into Your Project

**Best for**: Including skills directly in your project for GitHub Copilot or Gemini.

1. **Clone or fork this repository** next to your network automation projects

2. **Copy selected skills** into your project:
   ```bash
   mkdir -p docs/skills
   cp <skill-avd-repo>/docs/skills/generate_avd_data.md docs/skills/
   cp -r <skill-avd-repo>/docs/examples docs/
   ```

3. **Add to version control**:
   ```bash
   git add docs/skills docs/examples
   git commit -m "Add AVD skill documentation"
   ```

Your AI assistant will automatically index these files.

---

## Automated Installation

### GitHub Copilot

#### Fully Automated (No Prompts)

```bash
INSTALL_MODE=copilot \
INSTALL_PYAVD=yes \
CREATE_COPILOT_INSTRUCTIONS=yes \
  curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
```

#### Skip Optional Components

```bash
INSTALL_MODE=copilot \
INSTALL_PYAVD=no \
CREATE_COPILOT_INSTRUCTIONS=no \
  curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
```

### Claude Plugin

#### Install with PyAVD

```bash
INSTALL_MODE=claude \
INSTALL_PYAVD=yes \
  curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
```

#### Install without PyAVD

```bash
INSTALL_MODE=claude \
INSTALL_PYAVD=no \
  curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
```

---

## Environment Variables

Control installation behavior with environment variables:

| Variable | Required | Values | Description |
|----------|----------|--------|-------------|
| `INSTALL_MODE` | Yes (for non-interactive) | `copilot`, `claude`, `1`, `2` | Installation target |
| `INSTALL_PYAVD` | No | `yes`, `no`, `y`, `n`, `true`, `false`, `1`, `0` | Auto-install PyAVD |
| `CREATE_COPILOT_INSTRUCTIONS` | No | `yes`, `no`, `y`, `n`, `true`, `false`, `1`, `0` | Create `.github/copilot-instructions.md` (Copilot mode only) |
| `CLAUDE_PLUGINS_DIR` | No | Path | Override default Claude plugins directory |

---

## Using with AI Assistants

### Using with GitHub Copilot

Once the skill is installed in your project:

1. **Ensure files are in your repository**:
   - `docs/skills/generate_avd_data/docs/skills/generate_avd_data.md`
   - `docs/examples/` (optional but recommended)

2. **Open your project** in VS Code or your IDE with GitHub Copilot enabled

3. **Optionally create `.github/copilot-instructions.md`** (auto-created if you used `CREATE_COPILOT_INSTRUCTIONS=yes`):
   ```markdown
   # GitHub Copilot Instructions

   ## Available Skills

   ### generate_avd_data - PyAVD Network Configuration Builder

   When working with Arista AVD configurations, reference the skill
   documentation in `docs/skills/generate_avd_data/docs/skills/generate_avd_data.md`.
   ```

4. **Use in Copilot Chat**:
   ```
   Using the generate_avd_data skill, create a 2-spine / 4-leaf fabric
   with BGP underlay and VXLAN EVPN overlay.
   ```

**Example Prompts:**
- "Using the generate_avd_data skill, generate YAML for a minimal fabric"
- "Based on examples in generate_avd_data, write a Python script using PyAVD"
- "What are the required fields for l3leaf configuration in generate_avd_data?"

### Using with Claude

#### After Plugin Installation

Skills are automatically available in Claude:

**Example Prompts:**
```
Using the generate_avd_data skill, create a 2-spine / 4-leaf fabric design.
```

```
Based on the pyavd_hello_world.py example in generate_avd_data,
create a Python script for a 3-tier fabric.
```

```
What are the required fields for l3leaf configuration according
to the generate_avd_data skill?
```

#### Manual Reference Method

If not using plugin installation:

1. Add the skill Markdown files to your Claude project/workspace as reference material
2. In your prompts, tell Claude which skill to use:
   ```
   You have access to the documentation file generate_avd_data.md
   (SKILL: PyAVD Network Configuration Builder). Use it to generate
   valid inputs for PyAVD and EOS Designs.
   ```

### Using with Gemini

Gemini can use these files as long-form documentation:

1. **Make files available to Gemini**:
   - Add them to your code repository that Gemini Code Assist can see
   - Upload them as documentation files (depending on the product)

2. **Reference explicitly in prompts**:
   ```
   In the `docs/skills/generate_avd_data.md` file, there is a skill called
   "PyAVD Network Configuration Builder". Follow that documentation to produce
   structured data and configurations for Arista AVD.
   ```

---

## CI/CD Integration

### GitHub Actions

```yaml
name: Install AVD Skill

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  install-skill:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install AVD Skill
        run: |
          INSTALL_MODE=copilot \
          INSTALL_PYAVD=yes \
          CREATE_COPILOT_INSTRUCTIONS=yes \
          curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash

      - name: Verify installation
        run: |
          test -f docs/skills/generate_avd_data/docs/skills/generate_avd_data.md
          python3 -c "import pyavd; print(f'PyAVD {pyavd.__version__} installed')"
```

### GitLab CI

```yaml
install_avd_skill:
  stage: setup
  image: python:3.11
  script:
    - export INSTALL_MODE=copilot
    - export INSTALL_PYAVD=yes
    - export CREATE_COPILOT_INSTRUCTIONS=yes
    - curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
    - test -f docs/skills/generate_avd_data/docs/skills/generate_avd_data.md
    - python3 -c "import pyavd; print(f'PyAVD {pyavd.__version__} installed')"
  artifacts:
    paths:
      - docs/skills/generate_avd_data/
    expire_in: 1 day
```

### Jenkins Pipeline

```groovy
pipeline {
    agent any

    stages {
        stage('Install AVD Skill') {
            steps {
                sh '''
                    export INSTALL_MODE=copilot
                    export INSTALL_PYAVD=yes
                    export CREATE_COPILOT_INSTRUCTIONS=yes
                    curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
                '''
            }
        }

        stage('Verify Installation') {
            steps {
                sh '''
                    test -f docs/skills/generate_avd_data/docs/skills/generate_avd_data.md
                    python3 -c "import pyavd; print('PyAVD installed')"
                '''
            }
        }
    }
}
```

### Azure DevOps Pipeline

```yaml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

steps:
- checkout: self

- task: UsePythonVersion@0
  inputs:
    versionSpec: '3.11'

- script: |
    export INSTALL_MODE=copilot
    export INSTALL_PYAVD=yes
    export CREATE_COPILOT_INSTRUCTIONS=yes
    curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
  displayName: 'Install AVD Skill'

- script: |
    test -f docs/skills/generate_avd_data/docs/skills/generate_avd_data.md
    python3 -c "import pyavd; print('PyAVD installed')"
  displayName: 'Verify Installation'
```

### CircleCI

```yaml
version: 2.1

jobs:
  install-skill:
    docker:
      - image: cimg/python:3.11
    steps:
      - checkout
      - run:
          name: Install AVD Skill
          command: |
            INSTALL_MODE=copilot \
            INSTALL_PYAVD=yes \
            CREATE_COPILOT_INSTRUCTIONS=yes \
            curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
      - run:
          name: Verify Installation
          command: |
            test -f docs/skills/generate_avd_data/docs/skills/generate_avd_data.md
            python3 -c "import pyavd; print('PyAVD installed')"

workflows:
  version: 2
  install-and-verify:
    jobs:
      - install-skill
```

---

## Advanced Integration

### Docker

#### Dockerfile

```dockerfile
FROM python:3.11-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Initialize git repo for Copilot mode
RUN git init

# Install AVD skill
RUN INSTALL_MODE=copilot \
    INSTALL_PYAVD=yes \
    CREATE_COPILOT_INSTRUCTIONS=yes \
    curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash

# Verify installation
RUN test -f docs/skills/generate_avd_data/docs/skills/generate_avd_data.md && \
    python3 -c "import pyavd; print(f'PyAVD {pyavd.__version__} installed')"

CMD ["/bin/bash"]
```

#### docker-compose.yml

```yaml
version: '3.8'

services:
  avd-dev:
    build: .
    volumes:
      - .:/workspace
    environment:
      - INSTALL_MODE=copilot
      - INSTALL_PYAVD=yes
      - CREATE_COPILOT_INSTRUCTIONS=yes
```

### Makefile

```makefile
.PHONY: install-skill-copilot install-skill-claude verify-skill

install-skill-copilot:
@echo "Installing AVD skill for GitHub Copilot..."
@INSTALL_MODE=copilot \
 INSTALL_PYAVD=yes \
 CREATE_COPILOT_INSTRUCTIONS=yes \
 curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
@echo "Skill installed successfully!"

install-skill-claude:
@echo "Installing AVD skill for Claude..."
@INSTALL_MODE=claude \
 INSTALL_PYAVD=yes \
 curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
@echo "Skill installed successfully!"

verify-skill:
@test -f docs/skills/generate_avd_data/docs/skills/generate_avd_data.md && \
 echo "✓ Skill documentation found" || \
 echo "✗ Skill documentation not found"
@python3 -c "import pyavd; print(f'✓ PyAVD {pyavd.__version__} installed')" || \
 echo "✗ PyAVD not installed"
```

**Usage:**
```bash
make install-skill-copilot
make install-skill-claude
make verify-skill
```

### Ansible Playbook

```yaml
---
- name: Install AVD Skill
  hosts: localhost
  gather_facts: yes

  tasks:
    - name: Ensure git repository
      git:
        repo: https://github.com/your-org/your-project.git
        dest: /tmp/network-project
        version: main

    - name: Install AVD skill for Copilot
      shell: |
        INSTALL_MODE=copilot \
        INSTALL_PYAVD=yes \
        CREATE_COPILOT_INSTRUCTIONS=yes \
        curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
      args:
        chdir: /tmp/network-project
        creates: /tmp/network-project/docs/skills/generate_avd_data

    - name: Verify installation
      stat:
        path: /tmp/network-project/docs/skills/generate_avd_data/docs/skills/generate_avd_data.md
      register: skill_file

    - name: Check if skill was installed
      assert:
        that:
          - skill_file.stat.exists
        fail_msg: "AVD skill installation failed"
        success_msg: "AVD skill installed successfully"
```

**Usage:**
```bash
ansible-playbook install-avd-skill.yml
```

---

## Troubleshooting

### curl or wget not found

The script requires either `curl` or `wget`. Install one:

```bash
# macOS (curl is pre-installed)
brew install wget

# Ubuntu/Debian
sudo apt-get update && sudo apt-get install -y curl

# CentOS/RHEL
sudo yum install -y curl

# Alpine Linux (for Docker)
apk add --no-cache curl
```

### Not in a git repository (for Copilot mode)

If you select GitHub Copilot mode but are not in a git repository:

```bash
cd <your-project>
git init  # If needed
curl -fsSL https://raw.githubusercontent.com/titom73/skill-avd-inventory-builder/main/install-remote.sh | bash
```

### Script fails in CI/CD

Ensure curl or wget is available in your CI/CD environment:

```bash
# In your CI script before running install
command -v curl || (apt-get update && apt-get install -y curl)
```

### Git repository not detected in CI/CD

Initialize git before installation:

```bash
git init
git config user.email "ci@example.com"
git config user.name "CI Bot"
```

### Permission denied

If you get permission errors:

```bash
# Make sure you have write access to the installation directory
ls -la ~/.config/claude/plugins/  # For Claude
ls -la docs/skills/                # For Copilot

# Or run with sudo (preserving environment variables)
sudo -E bash -c 'INSTALL_MODE=claude INSTALL_PYAVD=yes curl -fsSL ... | bash'
```

### PyAVD installation fails

If PyAVD installation fails, install it manually:

```bash
# Upgrade pip first
python3 -m pip install --upgrade pip

# Install PyAVD
pip3 install pyavd

# Or with specific version
pip3 install pyavd==5.0.0
```

---

## Uninstallation

### Using Uninstall Scripts (Local Installation)

```bash
./uninstall.sh      # Unix/macOS/Linux
# or
.\uninstall.ps1     # Windows PowerShell
```

### Manual Uninstallation

#### For Claude Plugin

```bash
# Linux
rm -rf ~/.config/claude/plugins/generate_avd_data

# macOS
rm -rf ~/Library/Application\ Support/Claude/plugins/generate_avd_data

# Windows
rmdir /s %APPDATA%\Claude\plugins\generate_avd_data
```

#### For GitHub Copilot

```bash
rm -rf docs/skills/generate_avd_data
```

---

## PyAVD Installation

The script automatically detects if PyAVD is installed and offers to install it if missing:

```bash
pip3 install pyavd
```

You can also install it manually later if you prefer.

---

## Keeping Skills in Sync

Because these skills describe how to use Arista AVD and PyAVD, you should:

- Track which AVD / PyAVD version your project uses
- Update or refresh the skill files when you upgrade AVD / PyAVD
- Regenerate or extend examples under `docs/examples/` to match your environment

By keeping the skills current and consistently formatted, you help AI assistants generate correct, production-ready configurations for your network.

---

## Additional Resources

- **Repository**: https://github.com/titom73/skill-avd-inventory-builder
- **Skill Documentation**: [docs/skills/generate_avd_data.md](docs/skills/generate_avd_data.md)
- **Examples**:
  - [eos_designs_minimal_fabric.yml](docs/examples/eos_designs_minimal_fabric.yml)
  - [pyavd_hello_world.py](docs/examples/pyavd_hello_world.py)
