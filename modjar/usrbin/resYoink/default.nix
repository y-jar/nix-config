{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.usrSettings.resYoink;
in
{
  options.usrSettings.resYoink = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable resource symlinks (wallpapers, icons, pfps)";
    };
    wallpapers = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Symlink wall-jar into picjar/";
    };
    icons = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Symlink icon-jar into picjar/";
    };
    profilePictures = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Symlink pfp-jar into picjar/";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = lib.mkMerge [
      (lib.mkIf cfg.wallpapers { "resjar/wall-jar".source = inputs.wall-jar; })
      (lib.mkIf cfg.icons { "resjar/icon-jar".source = inputs.icon-jar; })
      (lib.mkIf cfg.profilePictures { "resjar/pfp-jar".source = inputs.pfp-jar; })
    ];
  };
}
