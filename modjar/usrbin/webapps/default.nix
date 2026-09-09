# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Web apps (browser apps as desktop apps) — home-manager side.
# -=-=-=-=-=-=-=-=-=-=-=
# Data comes from the host's hstjar/<host>/webapps.nix (sets sysSettings.webapps,
# declared by modjar/sysbin/webapps). This module reads it and, per app, builds a
# launcher script + a fuzzel/rofi-searchable .desktop entry. Mode pwa/app hand off
# to the browser in a standalone (isolated) window; mode tabbed opens the url as a
# normal tab. Auto-picked-up by the shared usrbin auto-importer.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  webapps,
  ...
}:

let
  cfg = webapps;

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

  defaultBrowser = config.usrSettings.browsers.default or "chromium";
  # Vendored icon (resjar/imagebin/JarOnPar.png) so webapps don't depend on the
  # icon-jar input / resYoink being enabled.
  defaultIcon = ./../../../resjar/imagebin/JarOnPar.png;

  # Effective browser for an app: explicit override, else tabbed -> default, app/pwa -> chromium.
  resolveBrowser =
    a:
    if a.browser != null then
      a.browser
    else if a.mode == "tabbed" then
      defaultBrowser
    else
      "chromium";

  buildApp =
    a:
    let
      browser = resolveBrowser a;
      app = lib.warnIf (a.mode != "tabbed" && lib.elem browser [ "firefox" "librewolf" ]) ''
        webapp '${a.name}' (mode '${a.mode}') uses ${browser}, which has no --app/frameless mode —
        it will open as a regular browser window with the tab UI. Set browser = "chromium" (and
        enable a chromium-based browser) for a true standalone app window.
      '' a;
      slug = toSlug app.name;
      isChromy = browser == "chromium";
      isFirefoxFamily = lib.elem browser [
        "firefox"
        "librewolf"
      ];
      isolate = app.isolate || app.mode == "pwa";
      profileDir = "$HOME/.local/share/webapps/${slug}";
      # isolation flags (only meaningful outside tabbed mode)
      isoFlags =
        if (app.mode == "tabbed") then
          ""
        else if isChromy && isolate then
          "--user-data-dir=\"${profileDir}\" --no-first-run"
        else if isFirefoxFamily && (app.mode != "tabbed") then
          "--new-instance --no-remote --profile \"${profileDir}\""
        else
          "";
      extra = lib.concatStringsSep " " app.extraArgs;
      launcher = pkgs.writeShellScriptBin "webapp-${slug}" (
        if app.mode == "tabbed" then
          ''
            exec ${browser} "${app.url}"
          ''
        else if isChromy then
          ''
            exec ${browser} --app="${app.url}" ${isoFlags} ${extra}
          ''
        else
          ''
            exec ${browser} ${isoFlags} "${app.url}" ${extra}
          ''
      );
    in
    {
      pkg = launcher;
      desktopItem = pkgs.makeDesktopItem {
        name = slug;
        desktopName = app.name;
        exec = "${launcher}/bin/webapp-${slug}";
        icon = if app.icon != null then app.icon else defaultIcon;
        categories = [ app.category ];
        type = "Application";
      };
    };

  apps = map buildApp cfg.apps;
  # pwa/app webapps run chromium --app; auto-install it so picking pwa/app just works.
  needsChromium = lib.any (a: a.mode != "tabbed" && resolveBrowser a == "chromium") cfg.apps;
in
lib.mkIf cfg.enable {
  # launcher scripts + their .desktop entries; the makeDesktopItem output lands
  # the desktop file in ~/.local/share/applications so fuzzel/rofi find the app.
  home.packages =
    map (x: x.pkg) apps
    ++ map (x: x.desktopItem) apps
    ++ lib.optionals needsChromium [ pkgs.chromium ]; # auto-install chromium for pwa/app
}
