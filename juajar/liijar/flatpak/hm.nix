# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Flatpak user-level + bazaar app store.
# -=-=-=-=-=-=-=-=-=-=-=
# Packages + the XDG_DATA_DIRS env line live in ./shared.nix.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.usrset.flatpak;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = lib.mkIf cfg.enable {
    home.packages = shared.packages; # end of home.packages
    home.sessionVariables = shared.sessionVariables; # end of sessionVariables

    #services.flatpak.enable = true;
    #services.flatpak.packages = [ { appId = "com.kde.kdenlive"; origin = "flathub";  } ];
    #services.flatpak.update.onActivation = true;
  }; # end of config
}
