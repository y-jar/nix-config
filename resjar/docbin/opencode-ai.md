**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

> **Note:** This documentation was written with the assistance of AI.

---

# AI / OpenCode Setup

This document covers the opencode configuration, available models, and custom agents.

## Available Models

### Cloud Models (Default)
Your default model is whichever cloud API key you have configured (e.g., Anthropic, OpenAI). This is used for the main `build` agent.

### Local Models (llama.cpp)
Local models run via llama.cpp's `llama-server` on your machine. They are available in opencode via the `/models` command.

| Model | ID | Notes |
| :--- | :--- | :--- |
| **Qwen3.5 9B** | `llama/qwen3.5-9b` | Vision-language model, solid for code and general tasks. |

### Downloading Models
Models are auto-downloaded by llama-server on first request (HuggingFace GGUF via `models-preset`). Models are cached in `/var/cache/llama-cpp`:

```bash
curl -s http://localhost:11434/v1/models
```

### Switching Models
In opencode, type `/models` to see available models and select one. The local models appear under the "llama.cpp (local)" provider.

## Custom Agents

These agents are defined declaratively in the Nix config (`modjar/usrbin/ai[cringe]/opencode.nix`):

### nix-helper
A specialist for NixOS configuration help. Understands:
- Nix language syntax and evaluation
- NixOS module system (options, config, imports)
- Flake structure and patterns
- Home Manager integration

Use `@nix-helper` in the chat to invoke this agent for Nix-related tasks.

### doc-writer
A documentation specialist that maintains consistent style across all project docs. Understands:
- The project's linking conventions
- Markdown formatting standards
- The docbin directory structure

Use `@doc-writer` in the chat to invoke this agent for documentation tasks.

### conlang-writer
A specialist for constructed language creation and maintenance. Helps with:
- **Auditing** — scan vocabulary for inconsistencies, orphaned roots, broken derivations
- **Word mapping** — trace root → affix → word chains, map relationships between words
- **Documentation** — write grammar docs and word entries in your writing style
- **Word generation** — suggest new words following existing phonological/morphological patterns

Knows the project structure:
- `./conlangs/l1-lang/vocab/` — words, roots, particles, adjectives, folds (affixes)
- `./conlangs/l1-lang/docs/` — grammar and documentation
- Files use markdown with Obsidian YAML frontmatter (properties)

Use `@conlang-writer` in the chat to invoke this agent for conlang tasks.

## Configuration Location

The opencode configuration is managed declaratively through Nix:
- **Nix module:** `modjar/usrbin/ai[cringe]/opencode.nix`
- **Generated config:** `~/.config/opencode/opencode.json`
- **Generated agents:** `~/.config/opencode/agent/*.md`
- **Global instructions:** `~/.config/opencode/AGENTS.md`

To make changes, edit the Nix module and rebuild your system with `nhs <hostname>`.
