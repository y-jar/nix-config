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
  cfg = config.usrSettings.git;
in
{
  options = {
    usrSettings.git.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable git";
    };
  }; # end of options

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      # set git username and email from usrSettings
      settings = {
        user.name = config.usrSettings.name;
        user.email = config.usrSettings.email;
        init.defaultBranch = "main"; # git init defaults to main instead of master
      }; # end of settings
    }; # end of git config
    home.packages = with pkgs; [
      gh # for github login
      lazygit # for kool github viewing
    ]; # end of home.packages
    programs.delta = {
      enable = true;
      options = {
        side-by-side = true;
        line-numbers = true;
      };
    }; # end of delta config
  }; # end of config
}
