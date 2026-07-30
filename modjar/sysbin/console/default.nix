{ lib, config, pkgs, ... }:
let
  cfg = config.sysSettings.console;
in
{
  options.sysSettings.console.font = lib.mkOption {
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
