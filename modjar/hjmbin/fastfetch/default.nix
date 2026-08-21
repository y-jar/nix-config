# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem: fastfetch system-fetch config + ascii logos.
# -=-=-=-=-=-=-=-=-=-=-=
# ref: modjar/usrbin/fastfetch/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  hjm = config.hjmSettings;
in
{
  config = lib.mkIf hjm.fastfetch.enable {
    packages = [ pkgs.fastfetch ];
    hjemDotfiles = {
      fastfetchConfig = ../../usrbin/fastfetch/config.jsonc;
      fastfetchLogos = ../../usrbin/fastfetch/logos-bin;
    };
  };
}
