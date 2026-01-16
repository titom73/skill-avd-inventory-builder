# Installation & Usage Guide

This document explains how to bring the **AVD skill Markdown files** into your own
environment and how to use them with GitHub Copilot, Claude, and Gemini.

The repository only contains documentation (Markdown files). There is **no Python package**
to install.

## 1. Getting the Skill Files

You have two common options:

1. **Clone or fork the repository**
   - Clone this repository next to your network automation projects so your editor and AI
     assistant can read the skill files.
2. **Vendor selected skills into your project**
   - Copy individual files from `docs/skills/` (for example `PYAVD_SCHEMAS.md`) into a
     `docs/skills/` directory in your own repository.

In both cases, the goal is for your AI assistant to see and index the Markdown skills
alongside your code.

## 2. Using the Skills with GitHub Copilot

When working in a repository that contains the skill Markdown files:

1. Ensure `docs/skills/` (and `docs/examples/` if you add examples) are checked into your
   project.
2. Open the repository in your IDE with GitHub Copilot enabled.
3. (Optional but recommended) Add a `.github/copilot-instructions.md` file in your project
   that tells Copilot to rely on these docs. For example, you can mention:
   - Where the skills live: `docs/skills/PYAVD_SCHEMAS.md`
   - That Copilot should follow the patterns and examples from this skill when generating
     YAML or Python for Arista AVD.
4. In Copilot Chat, reference the skill by name, for example:
   - “Using the *PyAVD Network Configuration Builder* skill in `docs/skills/PYAVD_SCHEMAS.md`,
      generate a minimal design for a 2-spine / 4-leaf fabric.”

As long as the Markdown files are part of the repository, Copilot Chat can read them and
take them into account.

## 3. Using the Skills with Claude

Claude can use these skills as **reference documents**:

1. Add this repository (or the individual Markdown files) to your Claude project or
   workspace as reference material, following the provider’s documentation.
2. When you start a new conversation, tell Claude which skill to use, for example:
   - “You have access to the documentation file *PYAVD_SCHEMAS.md* (SKILL: PyAVD Network
      Configuration Builder). Use it to generate valid inputs for PyAVD and EOS Designs.”
3. Keep the skills up to date if the underlying Arista AVD / PyAVD versions change.

The exact UI steps depend on how you host Claude (web app, IDE extension, etc.), but the
pattern is always: **attach the Markdown skill files as context**, then reference them in
your prompt.

## 4. Using the Skills with Gemini

Gemini (and similar models) can also treat these files as long-form documentation:

1. Make the skill Markdown files available to Gemini, for example by:
   - Adding them to your code repository that Gemini Code Assist can see.
   - Uploading them or linking them as documentation files, depending on the product.
2. In your prompt, refer explicitly to the skill and its location, for example:
   - “In the `docs/skills/PYAVD_SCHEMAS.md` file, there is a skill called
      *PyAVD Network Configuration Builder*. Follow that documentation to produce
      structured data and configurations for Arista AVD.”

As with Claude, the exact mechanism depends on the Gemini integration you are using, but
the workflow is the same: **make the Markdown visible, then ask Gemini to follow it**.

## 5. Keeping Skills in Sync

Because these skills describe how to use Arista AVD and PyAVD, you should:

- Track which AVD / PyAVD version your project uses.
- Update or refresh the skill files when you upgrade AVD / PyAVD.
- Regenerate or extend examples under `docs/examples/` to match your environment.

By keeping the skills current and consistently formatted, you help AI assistants generate
correct, production-ready configurations for your network.
