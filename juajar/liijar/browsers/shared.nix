# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Browsers shared data: firefox/librewolf/chromium packages per-toggle.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/browsers/shared.nix] =-=-=
# The browser packages both backends agree on, gated per usrset.browsers
# toggle. hjem hosts install them as plain packages (hjem.nix); home-manager
# hosts get the same browsers via the programs.* wrappers in hm.nix, so
# hm.nix does NOT re-add these raw packages to home.packages.
# =-=-=[end liijar/browsers/shared.nix] =-=-=
{
  cfg,
  pkgs,
  lib,
  ...
}:
{
  packages =
    lib.optionals (cfg.enable && cfg.firefox) [ pkgs.firefox ]
    ++ lib.optionals (cfg.enable && cfg.librewolf) [ pkgs.librewolf ]
    ++ lib.optionals (cfg.enable && cfg.chromium) [ pkgs.chromium ]; # end of packages
}
