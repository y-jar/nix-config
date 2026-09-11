# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Git shared data: gh + lazygit + delta packages.
# -=-=-=-=-=-=-=-=-=-=-=
{
  cfg,
  pkgs,
  lib,
  ...
}:
{
  packages = with pkgs; [
    gh # for github login
    lazygit # for kool github viewing
    delta # diff pager + side-by-side diffs (the generated .gitconfig uses it)
  ]; # end of packages
}
