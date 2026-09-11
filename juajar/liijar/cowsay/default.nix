# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: REFERENCE EXAMPLE app: cowsay. Copy this dir for new apps.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/cowsay] =-=-=
# WHAT THIS IS:
#   The commented walkthrough for adding a new user-level app. One module
#   file per app (default.nix) + any asset siblings the same shape as
#   sysjar modules. liijar/default.nix auto-imports every app dir, so a
#   new app needs NO registration anywhere.
#
# HOW TO ADD A NEW APP:
#   1. declare the toggle in liijar/options.nix (the ONLY place usrset
#      options are declared):
#        <app>.enable = lib.mkOption { type = lib.types.bool; default = false; };
#   2. copy this cowsay/ dir to liijar/<app>/ (rename the module file)
#   3. put your packages in the `packages` list below (gated on your
#      toggles with lib.optionals see the wine gate in liijar/core)
#   4. does the app have a config file? build it and write it directly:
#        files.".config/<app>/config".source = pkgs.writeText "<app>-config" ''
#          the config content
#        '';
#      (HOME-RELATIVE paths; use pkgs.formats.<ini/yaml/json/toml>.generate
#      for structured configs see liijar/espanso, liijar/fuzzel, liijar/editors/helix.nix)
#   5. flip the toggle in hstjar/<host>/user.nix done.
#
# THE RULES (learned the hard way, all real):
#   - multiple gated sections: lib.mkMerge [ (lib.mkIf cond { ... }) ... ].
#     NEVER `// lib.mkIf {...}` the attrset-update operator does not
#     compose module properties and silently drops everything but the last
#     branch (this once vanished the whole media package set).
#   - no programs.* / home.* / home-manager anything here modules are
#     evaluated inside hjem's user submodule, so the options are:
#       packages                       (apps to install)
#       files."<home-path>".source     (dotfiles to write symlinks to
#                                      /nix/store, read-only: apps that
#                                      self-save config can't persist)
#       environment.sessionVariables   (land in ~/.profile via loadEnv)
#       hjemDotfiles.dirSetup          (lines merged into ~/.profile see
#                                      liijar/dictation for the systemctl
#                                      --user enable pattern)
#   - osConfig reaches system-level config (osConfig.sysset.*), and the
#     hasDesktop/hostnm/inputs specialArgs are available as function args.
#   - need a SYSTEM service or /etc file? that's sysjar territory (see
#     juajar/sysjar/syncthing for the user-service-as-mainUser pattern).
# =-=-=[end liijar/cowsay] =-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # cfg = the toggles from the host sheet (hstjar/<host>/user.nix).
  cfg = config.usrset.cowsay;
in
{
  # config = the wiring. lib.mkIf keeps everything off when the toggle is
  # off. this example is one bool gating one package the smallest app.
  config = lib.mkIf cfg.enable {
    packages = [
      pkgs.cowsay # MOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
    ]; # end of packages
  }; # end of config
}
