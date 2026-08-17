# =-=-=[plymouth] =-=-=
# My custom boot splash logo. Toggle per-host via sysSettings.boot.plymouth.enable.
# Logo lives at resjar/imagebin/boot-logo.png. PNG format only.
# =-=-=[end plymouth] =-=-=

{ config, lib, ... }:
let
  cfg = config.sysSettings.boot.plymouth;
in
{
  # options for the boot splash
  options = {
    sysSettings.boot.plymouth.enable = lib.mkEnableOption "Custom logo boot splash via plymouth";
  }; # end of options

  # configuration for the boot splash
  config = lib.mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      theme = "bgrt"; # simple logo + spinner, background from firmware when available
      logo = ../../../resjar/imagebin/boot-logo.png; # my logo
    };
  }; # end of config
}
