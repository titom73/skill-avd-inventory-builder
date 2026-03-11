# Arista AI Skills & Agents

Collection of AI **skills** and **agents** for Arista EOS, compatible with **Claude Code** and **GitHub Copilot**.

## 📁 Repository Structure

```text
ai-skills-agent-arista/
├── skills/                     # Skills (expert methodologies)
│   ├── eos-fabric-design/      # EVPN/VXLAN fabric design
│   ├── avd/                    # PyAVD for config generation
│   │   ├── core.md             # Essential instructions
│   │   ├── claude.md           # Full version for Claude Code
│   │   ├── copilot.md          # Condensed version for Copilot
│   │   └── README.md
│   └── _templates/             # Templates for new skills
├── agents/                     # Agents (orchestration)
│   ├── config-reviewer/        # Configuration audit
│   ├── avd-config-generator/   # Config generation via PyAVD
│   │   ├── core.md             # Shared workflow
│   │   ├── claude.md           # Full version
│   │   ├── copilot.md          # Condensed version
│   │   └── README.md
│   └── _templates/             # Templates for new agents
├── scripts/                    # Installation scripts
└── README.md
```

---

## 🎯 Skill or Agent?

| Criteria           | Skill                         | Agent                         |
| ------------------ | ----------------------------- | ----------------------------- |
| **Focus**          | Expert methodology            | Orchestration                 |
| **Autonomy**       | User-guided                   | Semi-autonomous               |
| **External tools** | No                            | Yes                           |
| **Use cases**      | Generation, review, design    | Workflows, automation, audit  |

### Use a Skill for

- Generating or reviewing configurations according to a standard
- Validating design patterns (EVPN/VXLAN, MLAG, BGP)
- Enforcing a consistent response structure

### Use an Agent for

- Comparing a design document with a running-config
- Querying NetBox, Git, or inventories
- Running automated validations

---

## 🚀 Installation

### Claude Code

1. Add the `<skill-or-agent>/claude.md` file to the `.claude/` folder of your project
2. Or use the command: `claude project add-instructions <path>/claude.md`

### GitHub Copilot

```bash
cp skills/eos-fabric-design/copilot.md /path/to/repo/.github/copilot-instructions.md
```

---

## 🛠️ Create a New Skill/Agent

1. Copy the appropriate `_templates/` folder
2. Rename according to the domain
3. Create `core.md` with essential instructions
4. Create `claude.md` that extends core with templates and examples
5. Create `copilot.md` condensed version based on core
6. Add a `README.md`
7. Update this file

---

## 📚 Resources

- [Arista EOS User Guide](https://www.arista.com/en/um-eos)
- [Arista Validated Designs (AVD)](https://avd.arista.com/)
- [CloudVision Documentation](https://www.arista.com/en/cg-cv)
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [GitHub Copilot Instructions](https://docs.github.com/en/copilot/customizing-copilot)
