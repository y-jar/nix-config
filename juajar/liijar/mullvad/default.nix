# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: run selected apps outside the Mullvad tunnel.
# -=-=-=-=-=-=-=-=-=-=-=
# Linux Mullvad has no persistent per-app allowlist. The supported bypass is the
# setuid mullvad-exclude wrapper (services.mullvad-vpn.enableExcludeWrapper).
#
# Instead of rewriting each app's .desktop file, this module installs command
# shims in a dedicated directory:
#   ~/.local/share/mullvad-bypass/bin/<command>
# Desktop entries and terminals resolve bare Exec/command names through PATH, so
# a shim named `firefox` (or `Discord`, `opencode`, ...) intercepts both launch
# paths:
#   <shim> -> mullvad-exclude <real command> "$@"
#
# The dedicated directory is used so enabling Mullvad bypass never exposes the
# rest of ~/.local/bin (webapp launchers, uv pythons, user scripts) to the WM or
# desktop session.
#
# usrset.mullvad.bypassEnable gates the whole feature. When false, no shims are
# written and the directory stays empty. usrset.mullvad.bypass then accepts:
#   - a package: shim name comes from meta.mainProgram; target is lib.getExe pkg.
#     Use packages for GUI apps or when the exact version matters.
#   - a string: shim name is the string; the real command is resolved from PATH
#     with the shim directory removed, so the shim never calls itself.
#
# Limits:
#   - .desktop entries with an absolute Exec path do not use PATH.
#   - the shim directory must be on the session PATH. The NixOS Mullvad module
#     adds it to environment.d; log out/in once after enabling it so the WM sees
#     it.
#   - shell aliases/functions win over PATH; `alias oc=opencode` still reaches
#     the opencode shim.
#   - already-running apps keep their current route; fully quit single-instance
#     apps (Firefox, Chromium, Discord, Vesktop, opencode) before relaunching.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.mullvad;

  # Isolated so the WM never gains the rest of ~/.local/bin.
  shimDir = ".local/share/mullvad-bypass/bin";

  # NixOS puts the setuid wrapper in /run/wrappers/bin.
  exclude =
    if config.usrset.system.platform == "nixos" then
      "/run/wrappers/bin/mullvad-exclude"
    else
      "mullvad-exclude";

  packageValues = lib.filter (entry: !builtins.isString entry) cfg.bypass;
  commandValues = lib.filter builtins.isString cfg.bypass;

  packageWrappers = lib.concatMap (
    pkg:
    let
      program = pkg.meta.mainProgram or null;
    in
    if program == null then
      lib.warn "mullvad.bypass: ${pkg.name} has no meta.mainProgram; use a command string instead" [ ]
    else
      [
        {
          name = program;
          source = pkgs.writeShellScript "mullvad-bypass-${program}" ''
            exec ${exclude} ${lib.getExe pkg} "$@"
          '';
        }
      ]
  ) packageValues;

  commandWrappers = map (name: {
    inherit name;
    source = pkgs.writeShellScript "mullvad-bypass-${name}" ''
      set -euo pipefail
      name=${lib.escapeShellArg name}
      self="$HOME/${shimDir}"
      new_path=
      IFS=: read -r -a parts <<< "$PATH"
      for part in "''${parts[@]}"; do
        [ "$part" = "$self" ] || new_path="''${new_path:+$new_path:}$part"
      done
      real="$(PATH="$new_path" command -v "$name")" || {
        echo "mullvad-bypass: '$name' not found outside $self" >&2
        exit 127
      }
      exec ${exclude} "$real" "$@"
    '';
  }) commandValues;

  wrappers = packageWrappers ++ commandWrappers;

  files = builtins.listToAttrs (
    map (wrapper: {
      name = "${shimDir}/${wrapper.name}";
      value.source = wrapper.source;
    }) wrappers
  );
in
{
  config = lib.mkIf (cfg.bypassEnable && config.usrset.system.mullvad && wrappers != [ ]) {
    files = files;
  };
}
