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

These agents are defined declaratively in the Nix config (`juajar/liijar/ai/default.nix`):

### nix-helper
A specialist for NixOS configuration help. Understands:
- Nix language syntax and evaluation
- NixOS module system (options, config, imports)
- Flake structure and patterns
- Home Manager / hjem integration
- This repo's sysset/usrset option pattern and directory routing

Use `@nix-helper` in the chat to invoke this agent for Nix-related tasks.

### loomworker
A general assistant for the Loom worldbuilding vault (Obsidian knowledge base). Handles:
- World, lore, metaphysics, species, and history
- Conlang (Ylle'an) vocabulary, grammar, and word-building via `loom-lang-loader.py`
- Creative writing projects (stories, songs, poems)
- Editing and maintaining worldbuilding documentation

Use `@loomworker` in the chat to invoke this agent for worldbuilding/conlang/creative work.

## Configuration Location

The opencode configuration is managed declaratively through Nix:
- **Nix module:** `juajar/liijar/ai/default.nix`
- **Generated config:** `~/.config/opencode/opencode.json`
- **Generated agents:** `~/.config/opencode/agents/*.md`
- **Global instructions:** `~/.config/opencode/AGENTS.md`

To make changes, edit the Nix module and rebuild your system with `nhs <hostname>`.
