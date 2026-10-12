# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: ~/.profile writer + the dirSetup lines bus (POSIX sh, no NixOS pieces).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/profile-bus.nix] =-=-=
# liijar hjem modules write dotfiles DIRECTLY into hjem's user `files`/`packages`
# options (they are evaluated inside the hjem user submodule). The only
# remaining transport is `dirSetup`: lines from multiple modules that get
# merged into the ~/.profile written HERE (mkdir + systemctl --user enable
# steps). Set with lib.mkBefore/lib.mkAfter for ordering.
#
# The .profile is POSIX sh on purpose (Debian's /bin/sh is dash): no `source`,
# no `[[ ]]`, no arrays in any dirSetup snippet.
# =-=-=[end liijar/profile-bus.nix] =-=-=
{ config, lib, ... }:
{
  options.hjemDotfiles.dirSetup = lib.mkOption {
    type = lib.types.nullOr lib.types.lines;
    default = null;
    internal = true;
    description = "POSIX sh commands merged into ~/.profile (written by liijar/profile-bus.nix)";
  };

  config.files.".profile" = {
    executable = true;
    text = ''
      ${lib.optionalString (config.hjemDotfiles.dirSetup != null) config.hjemDotfiles.dirSetup}
      . ${config.environment.loadEnv}
    '';
  };
}
