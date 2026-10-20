# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: AI tools (packages bucket): opencode + uv + lmstudio.
# -=-=-=-=-=-=-=-=-=-=-=
# Packages under the ai.* fine toggles (so a host can keep opencode
# while skipping LM Studio's ~2.3GiB); the opencode config file writes
# live in ./opencode.nix. The local llama.cpp / ollama servers are
# system-side (sysset.ai, juajar/sysjar/ai).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  hjm = config.usrset.ai;

  # opencode from unstable: newer than the copy in stable nixpkgs (1.19 vs 1.15)
  unstablePkgs = inputs.nixpkgsUnstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  # opencode + uv + lmstudio under the ai.* fine toggles
  aiPackages =
    lib.optionals (hjm.enable && hjm.opencode.enable) [
      unstablePkgs.opencode # AI coding agent (TUI) [pinned to nixpkgs-unstable]
      unstablePkgs.opencode-desktop # AI coding agent (desktop GUI) [pinned to nixpkgs-unstable]
      pkgs.uv # rust based python package installer (opencode dep)
    ]
    ++ lib.optionals (hjm.enable && hjm.lmstudio.enable) [
      pkgs.lmstudio # local LLM runtime (~2.3GiB)
    ]; # end of aiPackages
in {
  imports = [ ./opencode.nix ];

  config = {
    # opencode + uv + lmstudio under the ai.* gates (see aiPackages)
    packages = aiPackages;
  }; # end of config
}
