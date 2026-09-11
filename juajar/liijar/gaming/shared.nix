# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Gaming shared data: prismlauncher + heroic packages per-toggle.
# -=-=-=-=-=-=-=-=-=-=-=
# (the HM-side mcpelauncher/zenity extras live in ./prism.nix)
{
  cfg,
  pkgs,
  lib,
  ...
}:
{
  packages =
    lib.optionals cfg.prism.enable [ pkgs.prismlauncher ]
    ++ lib.optionals cfg.heroic.enable [ pkgs.heroic ]; # end of packages
}
