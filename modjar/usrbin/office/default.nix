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
        description = "Enable office apps (~800MiB, LibreOffice)";
      };
    };
  }; # end options

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      libreoffice # LibreOffice office suite
      jupyter # Web-based notebook environment for interactive computing; mainly used for school and notetaking
      # [Technical Writing]
      pandoc # Conversion between documentation formats
    ];
  };
}
