# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: TTY console font selection.
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.sysset.console;
in
{
  options.sysset.console.font = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "TTY console font name. null = kernel default.";
  }; # end of font option

  config = lib.mkIf (cfg.font != null) {
    console = {
      font = cfg.font;
      packages = with pkgs; [ terminus_font ];
    }; # end of console config
  }; # end of config
}
