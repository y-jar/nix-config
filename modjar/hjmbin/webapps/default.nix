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

  mkLauncher =
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

  builtApps = map (a: {
    inherit a;
    slug = toSlug a.name;
    launcher = mkLauncher a;
  }) cfg.apps;

  webappsPkg = pkgs.runCommand "webapps-entries" { nativeBuildInputs = [ ]; } (
    lib.concatMapStrings (entry: ''
      mkdir -p $out/applications $out/bin

      cat > $out/applications/${entry.slug}.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=${entry.a.name}
      Exec=webapp-${entry.slug}
      Icon=${if entry.a.icon != null then entry.a.icon else defaultIcon}
      Categories=${entry.a.category};
      Terminal=false
      EOF

      cp ${entry.launcher} "$out/bin/webapp-${entry.slug}"
      chmod +x "$out/bin/webapp-${entry.slug}"
    '') builtApps
  );

  result =
    if cfg.enable then
      {
        desktopDir = "${webappsPkg}/applications";
        binDir = "${webappsPkg}/bin";
      }
    else
      null;
in
{
  config.hjemDotfiles.webapps = result;
}
