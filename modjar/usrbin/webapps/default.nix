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

  buildApp =
    a:
    let
      slug = toSlug a.name;
      browser =
        if a.browser != null then
          a.browser
        else
          (if a.mode == "tabbed" then defaultBrowser else "chromium");
      isChromy = browser == "chromium";
      isFirefoxFamily = lib.elem browser [
        "firefox"
        "librewolf"
      ];
      isolate = a.isolate || a.mode == "pwa";
      profileDir = "$HOME/.local/share/webapps/${slug}";
      # isolation flags (only meaningful outside tabbed mode)
      isoFlags =
        if (a.mode == "tabbed") then
          ""
        else if isChromy && isolate then
          "--user-data-dir=\"${profileDir}\" --no-first-run"
        else if isFirefoxFamily && (a.mode != "tabbed") then
          "--new-instance --no-remote --profile \"${profileDir}\""
        else
          "";
      extra = lib.concatStringsSep " " a.extraArgs;

      launcher = pkgs.writeShellScriptBin "webapp-${slug}" (
        if a.mode == "tabbed" then
          ''
            exec ${browser} "${a.url}"
          ''
        else if isChromy then
          ''
            exec ${browser} --app="${a.url}" ${isoFlags} ${extra}
          ''
        else
          ''
            exec ${browser} ${isoFlags} "${a.url}" ${extra}
          ''
      );
    in
    {
      pkg = launcher;
      desktopItem = pkgs.makeDesktopItem {
        name = slug;
        desktopName = a.name;
        exec = "${launcher}/bin/webapp-${slug}";
        icon = if a.icon != null then a.icon else defaultIcon;
        categories = [ a.category ];
        type = "Application";
      };
    };

  apps = map buildApp cfg.apps;
in
lib.mkIf cfg.enable {
  # launcher scripts + their .desktop entries; the makeDesktopItem output lands
  # the desktop file in ~/.local/share/applications so fuzzel/rofi find the app.
  home.packages = map (x: x.pkg) apps ++ map (x: x.desktopItem) apps;
}
