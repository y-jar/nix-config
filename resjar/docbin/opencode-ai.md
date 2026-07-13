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
| **GLM 4.7** | `ollama/glm-4.7` | Recommended by Ollama for opencode. Good general-purpose coding model. |
| **Qwen3 Coder** | `ollama/qwen3-coder` | Specialized for code generation and editing. |

### Pulling Models
Before using a local model, pull it with Ollama:
```bash
ollama pull glm-4.7
ollama pull qwen3-coder
```

### LM Studio Models (Local)
Local models run via LM Studio on your machine. They are available in opencode via the `/models` command.

| Model | ID | Notes |
| :--- | :--- | :--- |
| **GLM 4.6V Flash** | `lmstudio/zai-org/glm-4.6v-flash` | Lightweight and fast. Great for quick tasks. |
| **Ministral 3 14B Reasoning** | `lmstudio/mistralai/ministral-3-14b-reasoning` | Mistral's reasoning model, good for analysis. |
| **Qwen3.5 9B** | `lmstudio/qwen/qwen3.5-9b` | Solid all-rounder for code and general tasks. |

### Downloading LM Studio Models
Before using a local model, download it with the LM Studio CLI:
```bash
pull-models
```

Or manually:
```bash
lms get zai-org/glm-4.6v-flash
lms get mistralai/ministral-3-14b-reasoning
lms get qwen/qwen3.5-9b
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
