{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.office;
in
{
  options = {
    usrSettings.office = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable office apps";
      };
    };
  }; # end options

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      libreoffice # LibreOffice office suite
      # [Technical Writing]
      pandoc # Conversion between documentation formats
    ];
  };
}
