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
    usrSettings.git = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable git";
    };
  }; # end of options

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      # set git username and email from usrSettings
      userName = config.usrSettings.name;
      userEmail = config.usrSettings.email;
      extraPackages = with pkgs; [
        gh # for github login
        lazygit # for kool github viewing
      ];
    }; # end of git config
  }; # end of config
}
