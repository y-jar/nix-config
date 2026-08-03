{ config, inputs, lib, pkgs, ... }:
{
  # optjons for user to deny
  options = {
    sysSettings.UseNixPkgsYoinks = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable nixPkgs yoinks overlay, this includes pkgs from people whom one might or might not trust";
      }; # end of enable
    }; # end of UseNixPkgsYoinks
  }; # end of options
  # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=[NIX Grabbos / OVERLAYS]=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  config = lib.mkIf config.sysSettings.UseNixPkgsYoinks.enable {
    # [rsakura]:
    nixpkgs.overlays = [
      inputs.rsakura.overlays.default
    ]; # end of overlays
  }; # end of config
}
