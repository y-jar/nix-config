# =-=-=[git] =-=-=
# Generates ~/.gitconfig with user identity,
# delta for diffs, and sensible defaults.
# ref: modjar/usrbin/git/default.nix
# =-=-=[end git] =-=-=

{
  config,
  lib,
  pkgs,
  ...
}:
let
  hjm = config.hjmSettings;

  gitconfig = pkgs.writeText "gitconfig" ''
    [user]
      name = ${hjm.name}
      email = ${hjm.email}

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
  config = lib.mkIf hjm.git.enable {
    hjemDotfiles.gitconfig = gitconfig;
  };
}
