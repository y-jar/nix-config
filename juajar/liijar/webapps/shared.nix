# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Web apps shared helpers + the chromium auto-install package.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/webapps/shared.nix] =-=-=
# Pure helper functions + package gates shared by the home-manager (hm.nix)
# and hjem (hjem.nix) webapps backends. Each backend keeps its own
# launcher/desktop-entry build mechanism; only the identical helpers (toSlug,
# resolveBrowser, the warnIf wrapper), the vendored icon and the chromium
# auto-install live here. Data comes from the host's hstjar/<host>/webapps.nix
# (sysset.webapps, passed as the `webapps` specialArg to both backends).
# =-=-=[end liijar/webapps/shared.nix] =-=-=
{
  cfg,
  pkgs,
  lib,
  defaultBrowser,
  ...
}:

let
  # Effective browser for an app: explicit override, else tabbed -> default, app/pwa -> chromium.
  resolveBrowser =
    a:
    if a.browser != null then
      a.browser
    else if a.mode == "tabbed" then
      defaultBrowser
    else
      "chromium";

  # pwa/app webapps run chromium --app; auto-install it so picking pwa/app just works.
  needsChromium = lib.any (a: a.mode != "tabbed" && resolveBrowser a == "chromium") cfg.apps;
in
{
  # Lowercase name; spaces/punct -> '-'.
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

  inherit resolveBrowser;

  # Warn when a non-tabbed webapp picks a browser without --app/frameless mode.
  warnIfNoAppMode =
    browser: a:
    lib.warnIf
      (
        a.mode != "tabbed"
        && lib.elem browser [
          "firefox"
          "librewolf"
        ]
      )
      ''
        webapp '${a.name}' (mode '${a.mode}') uses ${browser}, which has no --app/frameless mode —
        it will open as a regular browser window with the tab UI. Set browser = "chromium" (and
        enable a chromium-based browser) for a true standalone app window.
      ''
      a;

  # Vendored icon (resjar/imagebin/JarOnPar.png) so webapps don't depend on the
  # icon-jar input / resYoink being enabled.
  defaultIcon = ./../../../resjar/imagebin/JarOnPar.png;

  # auto-install chromium for pwa/app webapps (installing chrome is implied by
  # picking pwa/app, even if the browsers sheet has chromium off).
  packages = lib.optionals (cfg.enable && needsChromium) [ pkgs.chromium ];
}
