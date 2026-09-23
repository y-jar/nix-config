# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: GDM display/login manager.
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.sysset.gdm;
in
{
  options = {
    sysset.gdm.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GDM display manager (opt-in; leave off for headless/WM-from-TTY hosts)";
    };
  }; # end options

  config = lib.mkIf cfg.enable {
    # this enables GDM, it is my fave, has to be picked via sysset.gdm.enable = true in sysset
    services.displayManager.gdm = {
      enable = true;
      banner = "=- Yil la kue mol loar -=";
    }; # end gdm
    environment.systemPackages = [
      pkgs.gdm-settings # GDM settings GUI
    ]; # end systemPackages
  }; # end config
}
