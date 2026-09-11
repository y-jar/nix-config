# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: REFERENCE EXAMPLE app: cowsay (home-manager backend).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/cowsay/hm.nix] =-=-=
# WHAT THIS FILE IS:
#   The home-manager adapter. It is evaluated inside the HM user scope
#   (home-manager.users.<mainUser>), which means the options available
#   here are the HM ones:
#     home.packages, home.file, xdg.configFile, home.sessionVariables,
#     programs.*, systemd.user.*, ...
#   Imported automatically by juajar/liijar/hm.nix no registration.
#
# RULES OF THUMB (learned the hard way):
#   - keep this file a THIN adapter: gate with lib.mkIf, map shared data,
#     nothing else. the app logic lives in shared.nix.
#   - if a programs.<app> module exists for your app (programs.git,
#     programs.delta, programs.opencode...), it usually provides the
#     binary itself often WRAPPED. do NOT also add the raw pkgs.<app>
#     from shared.nix or you get two different store paths fighting over
#     the same /bin entry (buildEnv collision). filter it out like:
#       home.packages = lib.filter (p: p != pkgs.<app>) shared.packages;
#     (see liijar/git/hm.nix and liijar/ai/hm.nix for real cases)
#   - home.file takes HOME-RELATIVE paths (".config/foo/bar"), same keys
#     shared.nix uses identical mapping to the hjem side.
# =-=-=[end liijar/cowsay/hm.nix] =-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # cfg = the toggles from the host sheet (hstjar/<host>/user.nix),
  # declared once in liijar/options.nix.
  cfg = config.usrset.cowsay;

  # shared = the app's data (packages + files), single-sourced.
  shared = import ./shared.nix { inherit cfg lib pkgs; };
in
{
  # config = the HM-side wiring. lib.mkIf keeps everything off when the
  # toggle is off. use lib.mkMerge (NEVER `//`) when you need multiple
  # gated sections `//` does not compose module properties.
  config = lib.mkIf cfg.enable {
    home.packages = shared.packages;
  }; # end of config
}
