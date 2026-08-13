{
  config,
  lib,
  hostnm, pkgs,
  ...
}:
let
  cfg = config.usrSettings.niri;
  hostSpecificFile = ./host-inputs + "/${hostnm}.kdl"; # host-specific input
  targetKdlSource =
    if builtins.pathExists hostSpecificFile then hostSpecificFile else ./host-inputs/0-unknown.kdl;
in
{
  options = {
    usrSettings.niri.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Niri window manager";
    }; # end of usrSettings.niri.enable
  }; # end of options

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "niri/config.kdl".source = ./config.kdl; # base linker
      # [global]
      "niri/bindings.kdl".source = ./bindings.kdl;
      "niri/base.kdl".source = ./base.kdl;
      "niri/rules.kdl".source = ./rules.kdl;
      "niri/startups.kdl".source = ./startups.kdl;
      # [host specific]
      "niri/host-inputs.kdl".source = targetKdlSource;
      # Pin waypaper to the awww backend and to the wallpaper folder.
      "waypaper/config.ini".text = ''
        [Settings]
        backend = awww
        folder = ~/resjar/wall-jar/wall-bin
      '';
    }; # end of xdg.configFile
    home.packages = with pkgs; [
      awww # animated wallpaper daemon for Wayland
      waypaper # GUI wallpaper setter for Wayland-based window managers
    ];
  }; # end of config
}
