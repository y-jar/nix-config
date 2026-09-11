# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Editors shared data: vscodium/zed/obsidian/helix packages per-toggle.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/editors/shared.nix] =-=-=
# Mirrors the old hjmbin editors bucket: vscodium/zed follow the master
# toggle + their own sub-toggle; obsidian/helix follow only their own
# sub-toggle. home-manager hosts install all of these via programs.* in
# hm.nix (hjem hosts never had the plain gnome-text-editor base list, so
# that stays HM-side only). nvf is NOT here hjem hosts get it via the
# system-level bridge (sysset.nvf), not as a user package.
# =-=-=[end liijar/editors/shared.nix] =-=-=
{
  cfg,
  pkgs,
  lib,
  ...
}:
{
  packages =
    lib.optionals (cfg.enable && cfg.vscodium.enable) [ pkgs.vscodium ]
    ++ lib.optionals (cfg.enable && cfg.zed.enable) [ pkgs.zed-editor ]
    ++ lib.optionals cfg.obsidian.enable [ pkgs.obsidian ]
    ++ lib.optionals cfg.helix.enable [ pkgs.helix ]; # end of packages
}
