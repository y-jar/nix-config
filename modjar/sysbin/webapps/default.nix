# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: System-level webapps: declares sysSettings.webapps + autostart wiring.
# -=-=-=-=-=-=-=-=-=-=-=
# Browser apps treated as desktop apps. The data lives in each host's
# hstjar/<host>/webapps.nix (sets sysSettings.webapps.apps). This module only
# declares the option shape and, for apps with `autostart = true`, appends their
# launcher to sysSettings.autostart.commands so the WM spawns them at session start.
# The actual desktop entries + launchers are built user-level:
#   home-manager hosts  -> modjar/usrbin/webapps
#   hjem hosts          -> modjar/hjmbin/webapps
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  ...
}:

let
  cfg = config.sysSettings.webapps;

  # Turn a display name into a safe launcher/desktop id: lowercased, spaces -> '-'.
  toSlug =
    name:
    lib.toLower (
      builtins.replaceStrings
        [
          " "
          "."
          "/"
          "_"
          "("
          ")"
          "'"
          "&"
          ":"
        ]
        [
          "-"
          "-"
          "-"
          "-"
          "-"
          "-"
          "-"
          "-"
          "-"
        ]
        name
    );
in
{
  options.sysSettings.webapps = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable per-host web apps (browser apps treated as desktop apps).";
    }; # end of enable

    apps = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Display name shown in launchers (fuzzel/rofi).";
            }; # end of name
            url = lib.mkOption {
              type = lib.types.str;
              description = "The web address to open.";
            }; # end of url
            mode = lib.mkOption {
              type = lib.types.enum [
                "tabbed"
                "app"
                "pwa"
              ];
              default = "app";
              description = ''
                Launch style:
                  tabbed -> opens the url as a tab in the normal browser window
                  app    -> standalone frameless window (chromium --app / separate firefox profile)
                  pwa    -> app-mode + always-isolated profile (like an installed PWA)
              '';
            }; # end of mode
            browser = lib.mkOption {
              type = lib.types.nullOr (
                lib.types.enum [
                  "chromium"
                  "firefox"
                  "librewolf"
                ]
              );
              default = null;
              description = "Which browser to launch. null = default (usrSettings.browsers.default / hjmSettings.browsers.default); pwa/app default to chromium.";
            }; # end of browser
            icon = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Icon path (absolute). null = defaults to the JarOnPar icon from icon-jar.";
            }; # end of icon
            category = lib.mkOption {
              type = lib.types.str;
              default = "Network";
              description = "XDG category used for grouping in some launchers.";
            }; # end of category
            autostart = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Launch this web app when the Window Manager session starts.";
            }; # end of autostart
            isolate = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Give the app its own profile/user-data dir so logins don't leak between apps (mode=pwa always isolates).";
            }; # end of isolate
            extraArgs = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Extra flags passed to the browser (e.g. \"--start-maximized\").";
            }; # end of extraArgs
          }; # end of submodule options
        }
      );
      default = [ ];
      description = "List of browser apps to expose as desktop apps.";
    }; # end of apps
  }; # end of options

  config = lib.mkIf cfg.enable {
    # Apps with autostart get their launcher appended to the WM session autostart
    # list. `listOf str` merges across modules, so this combines with the host's
    # hstjar/<host>/autostart.nix entries (no override).
    sysSettings.autostart.commands = lib.concatLists (
      map (a: lib.optional a.autostart "webapp-${toSlug a.name}") cfg.apps
    ); # end of autostart.commands
  }; # end of config
}
