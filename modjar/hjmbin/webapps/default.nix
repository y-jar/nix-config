# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Web apps (browser apps as desktop apps) — hjem side.
# -=-=-=-=-=-=-=-=-=-=-=
# Mirror of modjar/usrbin/webapps/ (home-manager). Reads the host's
# sysSettings.webapps (passed via hjem.specialArgs) and writes per-app launcher
# scripts + .desktop entries into ~/.local/bin and ~/.local/share/applications
# through the hjemDotfiles mechanism (wired in modjar/hjemkey.nix).
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

  defaultBrowser = config.hjmSettings.browsers.default or "chromium";
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

  builtApps = map (a: let
    browser = resolveBrowser a;
    app = lib.warnIf (a.mode != "tabbed" && lib.elem browser [ "firefox" "librewolf" ]) ''
      webapp '${a.name}' (mode '${a.mode}') uses ${browser}, which has no --app/frameless mode —
      it will open as a regular browser window with the tab UI. Set browser = "chromium" (and
      enable a chromium-based browser) for a true standalone app window.
    '' a;
  in {
    a = app;
    slug = toSlug app.name;
    launcher = mkLauncher app;
  }) cfg.apps;

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

  # per-file entries (relative home path -> store path): hjemkey writes these
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
needsChromium = lib.any (a: a.mode != "tabbed" && resolveBrowser a == "chromium") cfg.apps;
in
{
  config = {
    hjemDotfiles.webapps = result;
    # pwa/app webapps run chromium --app; make sure it's installed even if the
    # browsers sheet has chromium off (installing chrome is implied by picking pwa/app).
    packages = lib.mkIf (cfg.enable && needsChromium) [ pkgs.chromium ];
  };
}
