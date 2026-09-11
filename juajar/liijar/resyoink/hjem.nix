# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Symlink resource repos (wallpapers/icons/pfps) into ~/resjar (hjem side).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.usrset.resYoink;
  shared = import ./shared.nix {
    inherit cfg inputs;
  };

  # [filter out entries with no source]
  activeFiles = lib.filterAttrs (_: v: v != null) shared.files;
in
{
  config = lib.mkIf cfg.enable {
    files = lib.mapAttrs (_: v: { source = v; }) activeFiles;
  }; # end of config
}
