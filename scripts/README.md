# Installation Scripts

## Quick Install (No Clone Required)

Install skills and agents directly from the internet with a single command:

```bash
# One-liner installation (no git clone needed!)
curl -fsSL https://git.as73.inetsix.net/ai/arista-skills-agents/raw/branch/main/scripts/install-remote.sh | bash -s -- <platform> <type> <name> [target_path]
```

### Examples

```bash
# Install EOS Fabric Design skill for Claude Code (copies to clipboard)
curl -fsSL https://git.as73.inetsix.net/ai/arista-skills-agents/raw/branch/main/scripts/install-remote.sh | bash -s -- claude skill eos-fabric-design

# Install AVD skill for GitHub Copilot
curl -fsSL https://git.as73.inetsix.net/ai/arista-skills-agents/raw/branch/main/scripts/install-remote.sh | bash -s -- copilot skill avd /path/to/my/repo

# Install Config Reviewer agent for Copilot
curl -fsSL https://git.as73.inetsix.net/ai/arista-skills-agents/raw/branch/main/scripts/install-remote.sh | bash -s -- copilot agent config-reviewer /path/to/my/repo
```

---

## install-remote.sh

Remote installer that downloads and installs skills/agents directly from the Git server.

### Usage

```bash
./install-remote.sh <platform> <type> <name> [target_path]
```

### Available Components

| Type   | Name                  | Description                              |
| ------ | --------------------- | ---------------------------------------- |
| skill  | `eos-fabric-design`   | Arista EOS datacenter fabric design      |
| skill  | `avd`                 | PyAVD network configuration builder      |
| agent  | `config-reviewer`     | EOS configuration audit agent            |
| agent  | `avd-config-generator`| AVD config generation orchestrator       |

---

## install.sh

Local installer for when you have cloned the repository.

### Usage

```bash
./install.sh <platform> <type> <name> [target_path]
```

### Arguments

| Argument      | Description          | Values                   |
| ------------- | -------------------- | ------------------------ |
| `platform`    | Target platform      | `claude`, `copilot`      |
| `type`        | Component type       | `skill`, `agent`         |
| `name`        | Skill/agent name     | e.g., `eos-fabric-design`|
| `target_path` | Target repo path     | (required for copilot)   |

### Examples

#### Install a skill for Claude Code

```bash
./install.sh claude skill eos-fabric-design
# Content is copied to clipboard (macOS)
# Or copy the file to the project's .claude/ folder
```

#### Install a skill for GitHub Copilot

```bash
./install.sh copilot skill eos-fabric-design /path/to/my/repo
# Creates .github/copilot-instructions.md in the target repo
```

#### Install an agent for GitHub Copilot

```bash
./install.sh copilot agent config-reviewer /path/to/my/repo
```

---

## Prerequisites

- **macOS**: `pbcopy` (included by default) for clipboard copy
- **Linux**: `xclip` or `xsel` for clipboard copy (`apt install xclip`)
- **All**: `curl` or `wget` for remote installation

## Platform Behavior

### Claude Code

1. Displays the skill/agent content
2. Automatically copies to clipboard
3. Add the file to the project's `.claude/` folder

### GitHub Copilot

**For Skills:**

1. Creates the `.github/` folder if needed
2. Copies the file to `.github/copilot-instructions.md`
3. The skill is active for the entire repo

**For Agents:**

1. Creates the `.github/agents/` folder if needed
2. Copies the file to `.github/agents/<name>.md`
3. Also copies to `AGENTS.md` at the repo root (GitHub standard)
4. The agent is available for Copilot's agentic features
