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

### Local Models (Ollama)
Local models run via Ollama on your machine. They are available in opencode via the `/models` command.

| Model | ID | Notes |
| :--- | :--- | :--- |
| **Qwen3.5 9B** | `ollama/qwen3.5:9b` | Solid all-rounder for code and general tasks. |
| **Qwen3.5 9B (MLX)** | `ollama/qwen3.5:9b-mlx` | MLX variant of Qwen3.5 9B. |
| **Ministral 3 14B** | `ollama/frob/ministral-3:14b` | Mistral's larger reasoning model, good for analysis. |
| **Ministral 3 3B** | `ollama/frob/ministral-3:3b` | Lightweight Mistral model for quick tasks. |
| **Mistral 7B** | `ollama/mistral:7b` | General-purpose Mistral model. |
| **Gemma 4** | `ollama/gemma4:latest` | Google's latest Gemma model. |

### Pulling Models
Before using a local model, pull it with Ollama:
```bash
ollama pull qwen3.5:9b
ollama pull qwen3.5:9b-mlx
ollama pull frob/ministral-3:14b
ollama pull frob/ministral-3:3b
ollama pull mistral:7b
ollama pull gemma4:latest
```

### Switching Models
In opencode, type `/models` to see available models and select one. The local models appear under the "Ollama (local)" provider.

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
