# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Fastfetch shared data (package + config/logo file sources).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/fastfetch/shared.nix] =-=-=
# Pure data shared by both backends: the fastfetch package and the two
# home-relative file sources (config.jsonc + logos-bin, siblings of this
# file). hm.nix maps them into home.file, hjem.nix into hjem's user files.
# =-=-=[end liijar/fastfetch/shared.nix] =-=-=
{ pkgs, ... }:

{
  packages = [ pkgs.fastfetch ];

  files = {
    ".config/fastfetch/config.jsonc" = ./config.jsonc;
    ".config/fastfetch/logos-bin" = ./logos-bin;
  };
}
