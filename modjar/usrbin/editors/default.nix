{
  config,
  lib,
  pkgs,
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
      obsidian.enable = lib.mkEnableOption "Enable obsidian editor";
    }; # end of editors options
  }; # end of options

  config = lib.mkIf cfg.enable {
    # Install each editor if the master switch is on OR the editor is explicitly enabled
    programs.vscodium.enable = cfg.vscodium.enable;
    programs.zed-editor.enable = cfg.zed.enable;
    programs.obsidian.enable = cfg.obsidian.enable;

    home.packages = [
      pkgs.lorem # Generate placeholder text
    ];
  }; # end of config
}
