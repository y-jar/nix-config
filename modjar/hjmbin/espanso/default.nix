# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem: espanso dotfile generation.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[espanso] =-=-=
# "Shorts" - text expansion abbreviations (trigger -> replacement).
# Config lives in ~/.config/espanso/ (managed by this module).
#
# HOW TO USE
#   1. Add pairs in your host's hjem.nix under hjmSettings.espanso.shorts.
#      Triggers conventionally start with ':' so they don't fire mid-word.
#   2. Run `sudo nixos-rebuild switch`. Matches hot-reload; no restart needed.
#   3. `espanso status` / `espanso restart` for the daemon.
#
# SYNTAX CHEAT-SHEET
#   trigger  : the abbreviation string
#   replace  : what replaces it (use \n for multiline)
#   $|$      : cursor hint - caret lands here after expansion
#   vars     : date/time/etc - defined in hjmSettings.espanso.vars,
#              used in replacements as {{name}}
#
# WAYLAND NOTE
#   The daemon + security wrapper are system-level: sysSettings.espanso.enable
#   (services.espanso with pkgs.espanso-wayland). This module only writes the
#   user config files. Do NOT start a second daemon at user level.
# =-=-=[end espanso] =-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  hjm = config.hjmSettings.espanso;
  yaml = pkgs.formats.yaml { };

  matches = lib.mapAttrsToList (trigger: replace: { inherit trigger replace; }) hjm.shorts;
in
{
  config = lib.mkIf hjm.enable {
    hjemDotfiles = {
      espansoDefault = yaml.generate "espanso-default.yml" (
        {
          keyboard_layout = {
            layout = "us";
          };
        }
        // hjm.settings
      );

      espansoBase = yaml.generate "espanso-base.yml" {
        inherit matches;
      };
    }
    // lib.optionalAttrs (hjm.vars != [ ]) {
      espansoGlobals = yaml.generate "espanso-globals.yml" {
        vars = hjm.vars;
      };
    };
  };
}
