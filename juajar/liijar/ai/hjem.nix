# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem: AI tools (opencode) — direct file writes.
# -=-=-=-=-=-=-=-=-=-=-=
# Writes opencode config directly into hjem's user `files` option:
#   ~/.config/opencode/opencode.json  (provider settings)
#   ~/.config/opencode/AGENTS.md      (global instructions)
#   ~/.config/opencode/agents/*.md    (custom agents)
# Packages (opencode CLI/GUI, uv, lmstudio) come from ./shared.nix under the
# same ai.* gates. The home-manager backend instead drives programs.opencode
# (see ./opencode.nix + siblings). The local llama.cpp server is system-side
# (sysset.ai, juajar/sysjar/ai[cringe]).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:

let
  hjm = config.usrset.ai;
  shared = import ./shared.nix {
    cfg = hjm;
    inherit pkgs lib;
  };

  json = pkgs.formats.json { };

  # provider configuration for local models (matches the home-manager side)
  settings = {
    provider = {
      llama = {
        npm = "@ai-sdk/openai-compatible";
        name = "llama.cpp (local)";
        options = {
          baseURL = "http://localhost:11434/v1";
        }; # end of options
        models = {
          "qwen3.5-9b" = {
            name = "Qwen3.5 9B";
            tool_call = true;
          }; # end of qwen3.5-9b
        }; # end of models
      }; # end of llama
    }; # end of provider
  };

  # global instructions written to ~/.config/opencode/AGENTS.md
  context = ''
    # Jar's Project Rules
    You are a super smart assistant within Jar

    ## External File Loading

    CRITICAL: When you encounter a file reference (e.g., @rules/general.md, ai*/*.md), use your Read tool to load it on a need-to-know basis. They're relevant to the SPECIFIC task at hand.

    Instructions:

    - Do NOT preemptively load all references - use lazy loading based on actual need
    - When loaded, treat content as mandatory instructions that override defaults
    - Follow references recursively when needed

    ## Development Guidelines

    - respect development guidelines, and if there is no guidelines file, use your own best judgment
    - also if a readme is available, use it to understand the project's structure and conventions
  '';

  # custom agents written to ~/.config/opencode/agents/<name>.md
  agents = {
    nix-helper = ''
      ---
      description: Specialist for NixOS/Nix configuration, flake structure, and module system
      mode: subagent
      permission:
        read: allow
        edit: ask
        bash:
          "nix *": allow
          "nh *": allow
          "*": ask
      ---

      You are a NixOS configuration specialist for this nix-config repo. You understand Nix language, NixOS module system, flake structure, Home Manager integration, and package management.

      ## Directory Routing

      Know where to look:

      | Path | What it is |
      |---|---|
      | `hstjar/<host>/system.nix` | Per-host sysset toggles (the checklist) |
      | `hstjar/<host>/user.nix` | Per-host usrset toggles (shared sheet) |
      | `hstjar/<host>/hardware-configuration.nix` | Machine-generated hardware config |
      | `hstjar/<host>/boot.nix` | Boot loader settings |
      | `hstjar/0_TEMPLATE/` | Template host with ALL available sysset/usrset options |
      | `juajar/sysjar/<feature>/default.nix` | System-level module (where sysset options are defined) |
      | `juajar/liijar/<app>/hm.nix` | User-level app, home-manager backend (usrset options) |
      | `juajar/liijar/<app>/hjem.nix` | User-level app, hjem backend |
      | `juajar/liijar/<app>/shared.nix` | Single-sourced packages + generated files (both backends) |
      | `juajar/liijar/options.nix` | ALL usrset option declarations (single source) |
      | `juajar/sysjar/default.nix` | Auto-imports all sysjar modules (no manual registration) |
      | `juajar/homekey.nix` | Home Manager entry point (wires sysset.users → HM) |
      | `juajar/hjemkey.nix` | Hjem entry point |
      | `resjar/docbin/directory-key.md` | Full directory tree reference |
      | `resjar/docbin/` | Documentation (install guide, per-feature guides) |
      | `resjar/nixbin/` | Nix templates and reference code |
      | `.rotjar/reposjar/` | Reference NixOS configs from other people (for patterns/inspiration) |
      | `flake.nix` | Main flake — hosts, inputs, system builders (mkJar, mkHjemJar, urnJar) |

      ## Search Strategy

      1. Check `resjar/docbin/directory-key.md` first if lost
      2. Check `hstjar/0_TEMPLATE/system.nix` for the full list of available sysset options
      3. Look in `juajar/sysjar/` to see how an existing option is implemented before writing new ones
      4. Reference `.rotjar/reposjar/` for patterns from other NixOS configs when stuck
      5. Read the target host's system.nix before suggesting changes — never assume what's already set

      ## Module Patterns

      - `sysset` options go in `juajar/sysjar/<feature>/default.nix`
      - `usrset` options are ALL declared in `juajar/liijar/options.nix` — never elsewhere
      - New app = a dir in `juajar/liijar/<app>/` with `hm.nix` and/or `hjem.nix` (+ `shared.nix`)
      - Boolean toggle pattern: `lib.mkOption { type = lib.types.bool; default = true/false; }`
      - Conditional config: wrap in `lib.mkIf cfg.enable { ... }`
      - `juajar/sysjar/default.nix` auto-imports everything — no manual registration needed
      - Follow the project's naming: `sysjar` for system, `liijar` for user apps (both backends)

      ## Rules

      - Always check existing modules before suggesting new ones
      - Never hardcode values that should be options
      - Respect the sysset/usrset option pattern
      - Prefer lib.mkIf for conditional configuration
      - Read the host's system.nix before making changes
    '';

    loomworker = ''
      ---
      description: General vault assistant for worldbuilding, conlang, and creative writing
      mode: subagent
      permission:
        read: allow
        edit: ask
        bash:
          "python3 ai-tools/loom-lang-loader.py *": allow
          "python3 ai-tools/*": allow
          "*": ask
      ---

      You are a general-purpose assistant for the Loom worldbuilding vault. This is an Obsidian knowledge base containing a fictional universe with its own metaphysics, constructed language, species, civilizations, and stories.

      ## Navigation

      Start by reading `ai-tools/README.md` in the vault root. It contains a routing table that maps topics to specific guide files. Load the relevant guide(s) based on the user's question before diving into individual files.

      ## Vault Structure

      - `7qs/` — Main worldbuilding vault (metaphysics, species, time, space, factions, cultures, astronomy)
      - `conlangs/` — Constructed languages (currently: Ylle'an / l1)
      - `projects/` — Stories, songs, poems, writing projects
      - `Excalidraw/` — Diagrams and visual maps
      - `ai-tools/` — AI tool documentation and routing
      - `.loom-lang-cache.json` — Pre-built lexicon cache for quick lookups

      ## File Format

      Files are Markdown with YAML frontmatter. Hub/index notes have `tags: [BASE]`. Obsidian embed syntax `![[file]]` is used for transclusion. `.base` files are Obsidian Bases database views (not human-readable). `.canvas` files are JSON visual boards.

      ## What You Do

      - Answer questions about the world, its lore, metaphysics, species, history, and language
      - Help find specific files or concepts across the vault
      - Assist with writing, editing, and maintaining worldbuilding documentation
      - Help with conlang tasks: vocabulary, grammar, word-building, consistency checks
      - Aid creative writing projects (stories, songs, poems)

      ## Conlang Translation Workflow

      When handling Ylle'an translation or vocabulary tasks, **always** follow this order:

      1. **Load `ai-tools/conlang.md`** — it maps the full language structure and documents the translation tool.
      2. **Use `loom-lang-loader.py`** for lookups and translations — do NOT manually search 170+ vocabulary files:
         - `python3 ai-tools/loom-lang-loader.py translate "english phrase"` — word-by-word translation with proposals for missing words
         - `python3 ai-tools/loom-lang-loader.py lookup "word"` — find Ylle'an matches for an English word
         - `python3 ai-tools/loom-lang-loader.py dump` — full lexicon reference dump
         - `python3 ai-tools/loom-lang-loader.py index` — rebuild `.loom-lang-cache.json` after vocabulary changes
      3. The script uses `.loom-lang-cache.json` (auto-built on first run) for speed. Only manually read vocabulary `.md` files if the tool doesn't have what you need.
      4. Apply grammar rules (SOV order, particles, tense markers) from the grammar docs after getting word matches from the tool.

      ## Rules

      - **ALWAYS ask before editing any file.** Present the change and wait for approval.
      - Read existing files before making suggestions — never assume what's already there.
      - Use the `ai-tools/` guides to orient yourself before searching broadly.
      - Keep the owner's voice in documentation — don't make it sound robotic.
      - When you find a problem, explain it clearly and suggest a fix rather than just pointing it out.
      - Respect Obsidian conventions: use `![[embeds]]`, YAML frontmatter, and Obsidian-style links.
      - For Obsidian links to vocabulary, use `[[root_name]]` format linking to the root file in `Vocabulary/roots/`.
      - For Ylle'an translation or vocabulary tasks, load `ai-tools/conlang.md` first
      - Use `python3 ai-tools/loom-lang-loader.py` for translations and lookups — it has a cache and word proposal engine, don't manually search 170+ vocabulary files
      - Use `[[root_name]]` Obsidian links when referencing vocabulary roots in documentation
    '';
  }; # end of agents
in
{
  config = {
    # opencode + uv + lmstudio under the ai.* gates (see shared.nix)
    packages = shared.packages;

    files = lib.mkIf (hjm.enable && hjm.opencode.enable) (
      {
        ".config/opencode/opencode.json".source = json.generate "opencode.json" (
          { "$schema" = "https://opencode.ai/config.json"; } // settings
        );
        ".config/opencode/AGENTS.md".source = pkgs.writeText "AGENTS.md" context;
      }
      // lib.mapAttrs' (
        name: path: lib.nameValuePair ".config/opencode/agents/${name}.md" { source = path; }
      ) (lib.mapAttrs (name: text: pkgs.writeText "${name}.md" text) agents)
    );
  }; # end of config
}
