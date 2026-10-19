**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

> **Note:** This documentation was written with the assistance of AI.

---

# AI / OpenCode Setup

OpenCode is configured declaratively through Nix, so the config matches the
system and rebuilds with it.

## Where it lives

- **Nix module:** [`juajar/liijar/ai/default.nix`](../../juajar/liijar/ai/default.nix)
- **Generated config:** `~/.config/opencode/opencode.json`
- **Generated agents:** `~/.config/opencode/agents/*.md`
- **Global instructions:** `~/.config/opencode/AGENTS.md`

Edit the module, then rebuild your host. Models and API keys are managed in the
generated config, not hardcoded here; check `opencode.json` for what's current.

## Custom agents

Defined in the same module:

- **nix-helper**: NixOS/Nix specialist: the module system, flakes, this repo's
  `sysset`/`usrset` pattern. Invoke with `@nix-helper`.
- **loomworker**: general assistant for the Loom worldbuilding vault: lore,
  conlang (Ylle'an), and creative writing. Invoke with `@loomworker`.

## Local models

Local models run through llama.cpp and show up in OpenCode's `/models` picker.
Which models are available depends on the host's AI config; see the module and
the `llama-cpp` / `ollama` settings in the host's `system.nix`.
