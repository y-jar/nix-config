# =-=-=[espanso] =-=-=
# "Shorts" - text expansion abbreviations (trigger -> replacement).
# Config lives in ~/.config/espanso/ (managed by this module).
#
# HOW TO USE
#   1. Add pairs in your host's home.nix under usrSettings.espanso.shorts.
#      Triggers conventionally start with ':' so they don't fire mid-word.
#   2. Run `home-manager switch`. Matches hot-reload; no restart needed.
#   3. `espanso status` / `espanso restart` for the daemon.
#
# SYNTAX CHEAT-SHEET
#   trigger  : the abbreviation string
#   replace  : what replaces it (use \n for multiline)
#   $|$      : cursor hint - caret lands here after expansion
#   vars     : date/time/etc - defined in usrSettings.espanso.vars,
#              used in replacements as {{name}}
#
# WAYLAND NOTE
#   The daemon + security wrapper are system-level: sysSettings.espanso.enable
#   (services.espanso with pkgs.espanso-wayland). Do NOT enable the home-manager
#   services.espanso module - it can't create the security wrapper and would
#   start a second daemon.
# =-=-=[end espanso] =-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.espanso;
  yaml = pkgs.formats.yaml { };

  matches = lib.mapAttrsToList (trigger: replace: { inherit trigger replace; }) cfg.shorts;
in
{
  options = {
    usrSettings.espanso = {
      enable = lib.mkEnableOption "Enable espanso config (text expander)";

      shorts = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Espanso trigger -> replacement pairs, editable per host";
        example = {
          ":addr" = "123 Jar Street, Warrington";
          ":np" = "now playing: $|$";
        };
      }; # end of shorts

      vars = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [ ];
        description = "Espanso match vars (e.g. date/time), used as {{name}} in replacements";
        example = [
          {
            name = "mydate";
            type = "date";
            params = {
              format = "%Y-%m-%d";
            };
          }
        ];
      }; # end of vars

      settings = lib.mkOption {
        type = yaml.type;
        default = { };
        description = "Extra espanso config/default.yml settings";
        example = {
          show_notifications = false;
        };
      }; # end of settings
    }; # end of usrSettings.espanso
  }; # end of options

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "espanso/config/default.yml".source = yaml.generate "default.yml" (
        {
          keyboard_layout = {
            layout = "us";
          };
        }
        // cfg.settings
      );

      "espanso/match/base.yml".source = yaml.generate "base.yml" {
        inherit matches;
      };

      "espanso/match/globals.yml".source = lib.mkIf (cfg.vars != [ ]) (
        yaml.generate "globals.yml" {
          vars = cfg.vars;
        }
      );
    }; # end of xdg.configFile
  }; # end of config
}
