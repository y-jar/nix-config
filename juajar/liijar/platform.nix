# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Platform switches for the user layer (packages.install).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/platform.nix] =-=-=
# usrset.packages.install = false drops EVERY module's `packages` list (mkForce beats
# the plain definitions in each app module), so hjem only writes dotfiles and the
# host's own package manager provides the programs. That is the mode for a Debian
# host that is only "nixified" through hjem: apt owns binaries, nix owns configs.
#
# Config files still point at store paths for the generated bits (scripts, themes),
# which hjem keeps alive; only the profile PATH entries go away.
# =-=-=[end liijar/platform.nix] =-=-=
{ config, lib, ... }:

{
  config = lib.mkIf (!config.usrset.packages.install) {
    packages = lib.mkForce [ ];
  };
}
