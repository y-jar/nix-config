# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: REFERENCE EXAMPLE app: cowsay (hjem backend).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/cowsay/hjem.nix] =-=-=
# WHAT THIS FILE IS:
#   The hjem adapter. hjem modules are evaluated INSIDE the hjem user
#   submodule (hjem.users.<mainUser>), which changes the option names:
#     packages                      (NOT home.packages)
#     files."<home-path>".source    (NOT home.file)
#     environment.sessionVariables  (lands in ~/.profile via loadEnv)
#   plus osConfig to reach system-level config (osConfig.sysset.*).
#   Imported automatically by juajar/liijar/hjem.nix no registration.
#
# RULES OF THUMB (learned the hard way):
#   - same shape as hm.nix, different option names. keep it a thin adapter.
#   - hjem has no programs.* you write dotfiles directly:
#       files.".config/<app>/config".source = <generated-in-shared.nix>;
#   - lib.mkMerge for multiple gated sections. NEVER `// lib.mkIf {...}`:
#     the attrset-update operator drops every branch but the last AND
#     silently eats any plain keys (this is exactly how the media packages
#     vanished once see liijar/media/hjem.nix for the fixed shape).
#   - user systemd units don't exist in hjem scope write the unit FILE
#     into files.".config/systemd/user/<unit>" and enable it via the
#     profile bus: hjemDotfiles.dirSetup = lib.mkAfter "systemctl --user
#     enable <unit>"; (see liijar/dictation/hjem.nix)
# =-=-=[end liijar/cowsay/hjem.nix] =-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # cfg = the same host-sheet toggles the HM backend reads. one sheet,
  # both backends that's the point of the reorg.
  cfg = config.usrset.cowsay;

  # shared = the same data file hm.nix imports. change it once, both
  # backends change.
  shared = import ./shared.nix { inherit cfg lib pkgs; };
in
{
  config = lib.mkIf cfg.enable {
    packages = shared.packages;
  }; # end of config
}
