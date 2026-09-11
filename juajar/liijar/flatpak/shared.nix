# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Flatpak shared data: flatpak + bazaar packages + XDG_DATA_DIRS.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/flatpak/shared.nix] =-=-=
# The flatpak+bazaar packages and the XDG_DATA_DIRS line shared by both
# backends (union: hjem hosts previously only got bazaar). hm.nix maps
# sessionVariables to home.sessionVariables, hjem.nix to
# environment.sessionVariables.
# =-=-=[end liijar/flatpak/shared.nix] =-=-=
{
  cfg,
  pkgs,
  lib,
  ...
}:
{
  packages = with pkgs; [
    flatpak
    bazaar # appstore
  ]; # end of packages

  sessionVariables = {
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"; # lets flatpak work
  }; # end of sessionVariables
}
