# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: git: .gitconfig generation + git/gh/lazygit/delta packages.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[git] =-=-=
# Generates ~/.gitconfig with user identity,
# delta for diffs, and sensible defaults.
# =-=-=[end git] =-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.git;

  gitPackages = with pkgs; [
    gh # for github login
    lazygit # for kool github viewing
    delta # diff pager + side-by-side diffs (the generated .gitconfig uses it)
  ]; # end of gitPackages

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
    packages = gitPackages;
  }; # end of config
}
