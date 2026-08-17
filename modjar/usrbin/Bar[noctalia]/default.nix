# =-=-=[noctalia] =-=-=
# Noctalia desktop shell (Quickshell based). Kept optional so hosts can pick
# the shell they want: noctalia vs shelljar.
# ref: usrSettings.noctalia.enable
# =-=-=[end noctalia] =-=-=

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.noctalia;
in
{
  options = {
    usrSettings.noctalia.enable = lib.mkOption {
      type = lib.types.bool;
      default = true; # on by default so existing hosts keep noctalia until they swap shells
      description = "Enable the noctalia desktop shell";
    }; # end of usrSettings.noctalia.enable
  }; # end of options

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      noctalia-shell # Sleek and minimal desktop shell thoughtfully crafted for Wayland, built with Quickshell
    ];
  }; # end of config
}
