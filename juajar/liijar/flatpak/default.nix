# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: flatpak + bazaar packages + the XDG_DATA_DIRS env line.
# -=-=-=-=-=-=-=-=-=-=-=
# The env line lands in the user environment -> .profile via loadEnv
# (lets flatpak apps show up properly).
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.flatpak;

  flatpakPackages = with pkgs; [
    flatpak
    bazaar # appstore
  ]; # end of flatpakPackages

  # lets flatpak work
  flatpakSessionVariables = {
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
  }; # end of flatpakSessionVariables
in
{
  config = lib.mkIf cfg.enable {
    packages = flatpakPackages; # end of packages
    environment.sessionVariables = flatpakSessionVariables; # end of sessionVariables
  }; # end of config
}
