# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: git + gh + lazygit user config.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.usrset.git;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      # set git username and email from usrset
      settings = {
        user.name = config.usrset.name;
        user.email = config.usrset.email;
        init.defaultBranch = "main"; # git init defaults to main instead of master
      }; # end of settings
    }; # end of git config
    # programs.delta provides the (wrapped) delta binary, so the raw
    # pkgs.delta from shared.nix is filtered out here to avoid a
    # wrapped/unwrapped buildEnv collision. hjem has no programs.delta and
    # takes the shared list as-is.
    home.packages = lib.filter (p: p != pkgs.delta) shared.packages;
    programs.delta = {
      enable = true;
      options = {
        side-by-side = true;
        line-numbers = true;
      };
    }; # end of delta config
  }; # end of config
}
