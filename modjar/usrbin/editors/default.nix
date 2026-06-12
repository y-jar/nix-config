{
  config,
  lib,
  ...
}:

let
  cfg = config.usrSettings.editors;
in
{
  options = {
    usrSettings.editors = {
      enable = lib.mkEnableOption "Enable editors master switch";
      vscodium.enable = lib.mkEnableOption "Enable vscodium editor";
      zed.enable = lib.mkEnableOption "Enable zed editor";
    }; # end of editors options
  }; # end of options

  config = {
    # Install each editor if the master switch is on OR the editor is explicitly enabled
    programs.vscodium.enable = cfg.enable || cfg.vscodium.enable;
    programs.zed-editor.enable = cfg.enable || cfg.zed.enable;
  }; # end of config
}
