# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: AI tools shared package bucket (opencode + LM Studio).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/ai/shared.nix] =-=-=
# The ai package list shared by both backends (home-manager hm.nix, hjem
# hjem.nix), gated on the usrset.ai toggles (master + opencode/lmstudio fine
# toggles so a host can keep opencode while skipping LM Studio's ~2.3GiB).
# Config generation stays per-backend: HM drives programs.opencode
# (opencode.nix + siblings), hjem writes the files directly (hjem.nix).
# =-=-=[end liijar/ai/shared.nix] =-=-=
{
  cfg,
  pkgs,
  lib,
  ...
}:

{
  packages =
    lib.optionals (cfg.enable && cfg.opencode.enable) [
      pkgs.opencode # AI coding agent (TUI)
      pkgs.opencode-desktop # AI coding agent (desktop GUI)
      pkgs.uv # rust based python package installer (opencode dep)
    ]
    ++ lib.optionals (cfg.enable && cfg.lmstudio.enable) [
      pkgs.lmstudio # local LLM runtime (~2.3GiB)
    ];
}
