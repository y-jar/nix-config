# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: .profile bootstrap lines bus (hjem backend only).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/profile-bus.nix] =-=-=
# liijar hjem modules write dotfiles DIRECTLY into hjem's user `files`/`packages`
# options (they are evaluated inside the hjem user submodule). The only
# remaining transport is `dirSetup`: lines from multiple modules that get
# merged into the .profile written by hjemkey (mkdir + systemctl --user
# enable steps). Set with lib.mkBefore/lib.mkAfter for ordering.
# =-=-=[end liijar/profile-bus.nix] =-=-=
{ lib, ... }:
{
  options.hjemDotfiles.dirSetup = lib.mkOption {
    type = lib.types.nullOr lib.types.lines;
    default = null;
    internal = true;
    description = "Shell commands merged into the .profile written by hjemkey";
  };
}
