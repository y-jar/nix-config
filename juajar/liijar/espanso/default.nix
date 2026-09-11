# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: espanso: match/config yaml file generation.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[espanso] =-=-=
# "Shorts" - text expansion abbreviations (trigger -> replacement).
# Config lives in ~/.config/espanso/ (managed by this module).
#
# HOW TO USE
#   1. Add pairs in your host's user.nix under usrset.espanso.shorts.
#      Triggers conventionally start with ':' so they don't fire mid-word.
#   2. Matches hot-reload; no restart needed.
#   3. `espanso status` / `espanso restart` for the daemon.
#
# SYNTAX CHEAT-SHEET
#   trigger  : the abbreviation string
#   replace  : what replaces it (use \n for multiline)
#   $|$      : cursor hint - caret lands here after expansion
#   vars     : date/time/etc - defined in usrset.espanso.vars,
#              used in replacements as {{name}}
#
# WAYLAND NOTE
#   The daemon + security wrapper are system-level: sysset.espanso.enable
#   (services.espanso with pkgs.espanso-wayland). Do NOT start a second
#   daemon at user level.
# =-=-=[end espanso] =-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.espanso;

  yaml = pkgs.formats.yaml { };

  matches = lib.mapAttrsToList (trigger: replace: { inherit trigger replace; }) cfg.shorts;

  espansoFiles = {
    ".config/espanso/config/default.yml" = yaml.generate "espanso-default.yml" (
      {
        keyboard_layout = {
          layout = "us";
        };
      }
      // cfg.settings
    );

    ".config/espanso/match/base.yml" = yaml.generate "espanso-base.yml" {
      inherit matches;
    };
  }
  // lib.optionalAttrs (cfg.vars != [ ]) {
    ".config/espanso/match/globals.yml" = yaml.generate "espanso-globals.yml" {
      vars = cfg.vars;
    };
  }; # end of espansoFiles
in
{
  config = lib.mkIf cfg.enable {
    files = lib.mapAttrs (_: v: { source = v; }) espansoFiles;
  }; # end of config
}
