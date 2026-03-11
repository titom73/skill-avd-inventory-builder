# Agents

## What is an Agent?

An **agent** is an autonomous orchestration system that can:

- Fetch information from multiple sources
- Call external tools (APIs, CLIs, databases)
- Chain multiple steps autonomously
- Maintain context memory between steps

**Use an agent when you want to:**

- Read a design doc and compare with a running-config
- Query NetBox, Git, or inventories
- Run automated validations
- Orchestrate multi-step workflows

---

## Available Agents

| Agent                                           | Description                                                        | Claude | Copilot |
| ----------------------------------------------- | ------------------------------------------------------------------ | ------ | ------- |
| [config-reviewer](./config-reviewer/)           | Compares EOS configs with best practices and proposes corrections  | ✅     | ✅      |
| [avd-config-generator](./avd-config-generator/) | Generates EOS configs from PyAVD designs                           | ✅     | ✅      |

---

## Installation

### Claude Code

1. Add the `<agent>/claude.md` file to the `.claude/` folder of your project
2. Or use the command: `claude project add-instructions <agent>/claude.md`
3. Optional: Add context files (configs, inventories)

### GitHub Copilot

1. Create a `.github/copilot-instructions.md` file at the root of the repo
2. Copy the content of `<agent>/copilot.md`
3. Or use the script: `../scripts/install.sh copilot <agent-name>`

---

## Skill vs Agent Difference

| Aspect           | Skill                   | Agent                 |
| ---------------- | ----------------------- | --------------------- |
| Focus            | Expert methodology      | Orchestration         |
| Autonomy         | User-guided             | Semi-autonomous       |
| External tools   | No                      | Yes                   |
| Memory           | Session                 | Persistent context    |
| Use cases        | Generation, review      | Workflows, automation |

---

## Create a New Agent

1. Copy the `_templates/` folder to a new folder
2. Rename according to the agent's function
3. Define the tools/sources the agent can use
4. Adapt the `claude.md` and `copilot.md` files
5. Update this README

See [_templates/](./_templates/) for templates.
