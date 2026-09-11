# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: fastfetch: system-fetch config + ascii logos.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.fastfetch;

  fastfetchPackages = [ pkgs.fastfetch ]; # end of fastfetchPackages

  # config.jsonc + logos-bin are siblings of this file
  fastfetchFiles = {
    ".config/fastfetch/config.jsonc" = ./config.jsonc;
    ".config/fastfetch/logos-bin" = ./logos-bin;
  }; # end of fastfetchFiles
in
{
  config = lib.mkIf cfg.enable {
    packages = fastfetchPackages;
    files = lib.mapAttrs (_: v: { source = v; }) fastfetchFiles;
  };
}
