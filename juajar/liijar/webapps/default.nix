# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: web apps (browser apps as desktop apps).
# -=-=-=-=-=-=-=-=-=-=-=
# Reads the host's sysset.webapps (passed via the `webapps` specialArg) and
# writes per-app launcher scripts + .desktop entries into ~/.local/bin and
# ~/.local/share/applications. Mode pwa/app hand off to the browser in a
# standalone (isolated) window; mode tabbed opens the url as a normal tab.
{
  config,
  lib,
  pkgs,
  webapps,
  ...
}:

let
  cfg = webapps;

  # =-=-=[helpers]
  # Effective browser for an app: explicit override, else tabbed -> default, app/pwa -> chromium.
  defaultBrowser = config.usrset.browsers.default or "chromium";
  resolveBrowser =
    a:
    if a.browser != null then
      a.browser
    else if a.mode == "tabbed" then
      defaultBrowser
    else
      "chromium";

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

  # pwa/app webapps run chromium --app; auto-install it so picking pwa/app
  # just works (installing chrome is implied by picking pwa/app, even if the
  # browsers sheet has chromium off).
  needsChromium = lib.any (a: a.mode != "tabbed" && resolveBrowser a == "chromium") cfg.apps;
  webappsPackages = lib.optionals (cfg.enable && needsChromium) [ pkgs.chromium ]; # end of webappsPackages

  # =-=-=[launcher + desktop entries]
  mkLauncher =
    a:
    let
      slug = toSlug a.name;
      browser = resolveBrowser a;
      isChromy = browser == "chromium";
      isFirefoxFamily = lib.elem browser [
        "firefox"
        "librewolf"
      ];
      isolate = a.isolate || a.mode == "pwa";
      profileDir = "$HOME/.local/share/webapps/${slug}";
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
      cmd =
        if a.mode == "tabbed" then
          ''${browser} "${a.url}"''
        else if isChromy then
          ''${browser} --app="${a.url}" ${isoFlags} ${extra}''
        else
          ''${browser} ${isoFlags} "${a.url}" ${extra}'';
    in
    pkgs.writeText "webapp-${slug}" ''
      #!/bin/sh
      exec ${cmd}
    '';

  builtApps = map (
    a:
    let
      browser = resolveBrowser a;
      app = warnIfNoAppMode browser a;
    in
    {
      a = app;
      slug = toSlug app.name;
      launcher = mkLauncher app;
    }
  ) cfg.apps;

  webappsPkg = pkgs.runCommand "webapps-entries" { nativeBuildInputs = [ ]; } (
    lib.concatMapStrings (entry: ''
      mkdir -p $out/applications $out/bin

      cat > $out/applications/${entry.slug}.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=${entry.a.name}
      Exec=$out/bin/webapp-${entry.slug}
      Icon=${if entry.a.icon != null then entry.a.icon else defaultIcon}
      Categories=${entry.a.category};
      Terminal=false
      EOF

      cp ${entry.launcher} "$out/bin/webapp-${entry.slug}"
      chmod +x "$out/bin/webapp-${entry.slug}"
    '') builtApps
  );

  # per-file entries (relative home path -> store path): these are written
  # individually so ~/.local/bin and ~/.local/share/applications keep
  # user-owned content instead of being replaced by whole-dir symlinks.
  # Exec uses the absolute store path so launching works from fuzzel/DE
  # sessions where ~/.local/bin is not on PATH.
  result =
    if cfg.enable then
      builtins.listToAttrs (
        lib.concatMap (entry: [
          {
            name = ".local/share/applications/${entry.slug}.desktop";
            value = "${webappsPkg}/applications/${entry.slug}.desktop";
          }
          {
            name = ".local/bin/webapp-${entry.slug}";
            value = "${webappsPkg}/bin/webapp-${entry.slug}";
          }
        ]) builtApps
      )
    else
      null;
in
{
  config = {
    # per-file entries (relative home path -> store file) so ~/.local/bin and
    # ~/.local/share/applications keep user-owned content
    files = lib.optionalAttrs (result != null) (
      lib.mapAttrs' (rel: path: lib.nameValuePair rel { source = path; }) result
    );
    # pwa/app webapps run chromium --app; auto-install (see webappsPackages)
    packages = webappsPackages;
  };
}
