# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Web apps (browser apps as desktop apps) — hjem side.
# -=-=-=-=-=-=-=-=-=-=-=
# Reads the host's sysset.webapps (passed via hjem.specialArgs) and writes
# per-app launcher scripts + .desktop entries into ~/.local/bin and
# ~/.local/share/applications directly into hjem's user `files` option
# (liijar modules are evaluated inside the hjem user submodule). Shared
# helpers live in ./shared.nix.
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

  mkLauncher =
    a:
    let
      slug = shared.toSlug a.name;
      browser = shared.resolveBrowser a;
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
      browser = shared.resolveBrowser a;
      app = shared.warnIfNoAppMode browser a;
    in
    {
      a = app;
      slug = shared.toSlug app.name;
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
      Icon=${if entry.a.icon != null then entry.a.icon else shared.defaultIcon}
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
in
{
  config = {
    # per-file entries (relative home path -> store file) so ~/.local/bin and
    # ~/.local/share/applications keep user-owned content
    files = lib.optionalAttrs (result != null) (
      lib.mapAttrs' (rel: path: lib.nameValuePair rel { source = path; }) result
    );
    # pwa/app webapps run chromium --app; auto-install via shared.nix
    packages = shared.packages;
  };
}
