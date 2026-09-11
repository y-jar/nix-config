# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Web apps (browser apps as desktop apps) — home-manager side.
# -=-=-=-=-=-=-=-=-=-=-=
# Data comes from the host's hstjar/<host>/webapps.nix (sets sysset.webapps,
# declared by juajar/sysjar/webapps, passed here as the `webapps` specialArg).
# Per app this builds a launcher script + a fuzzel/rofi-searchable .desktop
# entry (writeShellScriptBin + makeDesktopItem into home.packages). Mode pwa/app
# hand off to the browser in a standalone (isolated) window; mode tabbed opens
# the url as a normal tab. Shared helpers live in ./shared.nix.
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

  shared = import ./shared.nix {
    cfg = webapps;
    inherit pkgs lib;
    defaultBrowser = config.usrset.browsers.default or "chromium";
  };

  buildApp =
    a:
    let
      browser = shared.resolveBrowser a;
      app = shared.warnIfNoAppMode browser a;
      slug = shared.toSlug app.name;
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
        icon = if app.icon != null then app.icon else shared.defaultIcon;
        categories = [ app.category ];
        type = "Application";
      };
    };

  apps = map buildApp cfg.apps;
in
lib.mkIf cfg.enable {
  # launcher scripts + their .desktop entries; the makeDesktopItem output lands
  # the desktop file in ~/.local/share/applications so fuzzel/rofi find the app.
  home.packages = map (x: x.pkg) apps ++ map (x: x.desktopItem) apps ++ shared.packages; # auto-install chromium for pwa/app (see shared.nix)
}
