# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem git: .gitconfig generation + shared git packages.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[git] =-=-=
# Generates ~/.gitconfig with user identity,
# delta for diffs, and sensible defaults.
# (home-manager hosts write .gitconfig via programs.git instead)
# =-=-=[end git] =-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.git;
  shared = import ./shared.nix { inherit cfg pkgs lib; };

  gitconfig = pkgs.writeText "gitconfig" ''
    [user]
      name = ${config.usrset.name}
      email = ${config.usrset.email}

    [core]
      editor = nvim
      pager = delta

    [interactive]
      diffFilter = delta --color-only

    [merge]
      conflictStyle = zdiff3

    [diff]
      colorMoved = default

    [pull]
      rebase = true

    [init]
      defaultBranch = main

    [delta]
      side-by-side = true
      line-numbers = true

    [advice]
      objectNameWarning = false

    [safe]
      directory = /tmp
  '';
in
{
  config = lib.mkIf cfg.enable {
    files.".gitconfig".source = gitconfig;
    packages = shared.packages;
  }; # end of config
}
