# Arista AVD Skills for AI Assistants

This repository contains **Markdown skills** that teach AI coding assistants how to work with
Arista AVD and PyAVD. The skills are written in a simple, model-agnostic format so they can
be reused with GitHub Copilot, Claude, Gemini, or any other LLM that can read Markdown
documentation.

## Repository Contents

- `docs/skills/`
  - `PYAVD_SCHEMAS.md` – **SKILL: PyAVD Network Configuration Builder**
    - Explains how to use PyAVD schemas to build Arista EOS configurations programmatically.
- `docs/examples/`
  - Reserved for small, concrete examples that demonstrate how to apply the skills.

## Standard Skill Format

Each skill in `docs/skills/` follows the same basic Markdown structure so that different
LLMs can consume it consistently:

1. **Title**
   - First line: `# SKILL: <Skill Name>`
2. **Metadata block**
   - A short block of bold fields, for example:
     - `**Skill Type**`: Domain or category
     - `**Domain**`: Technology or product area
     - `**Complexity**`: Basic / Intermediate / Advanced
     - `**Prerequisites**`: What the user or agent is expected to know
3. **Core sections** (typical ordering)
   - `## Skill Overview` – What the skill is about and when to use it
   - `## Quick Start` – Minimal setup and a small end-to-end example
   - `## Detailed Reference` – Deeper explanations, tables, and edge cases
   - `## Examples` – A few realistic examples that can be copied or adapted
4. **Model-agnostic wording**
   - The content should avoid tool-specific commands whenever possible.
   - When necessary, keep separate notes for Copilot / Claude / Gemini.

The existing `PYAVD_SCHEMAS.md` file is the reference implementation of this format.

## Using These Skills

These Markdown files are meant to be **included as reference documentation** alongside your
code, not imported as a Python package.

Typical ways to use them:

- Open your network automation project and this repository in the same IDE workspace.
- Configure your AI assistant to treat the files in `docs/skills/` as reference docs.
- When prompting the model, explicitly mention the skill name, for example:
  - “Use the *SKILL: PyAVD Network Configuration Builder* to design the YAML and Python
    code for this fabric.”

For detailed step-by-step instructions on integrating these skills with GitHub Copilot,
Claude, and Gemini, see **`INSTALL.md`** in this repository.
