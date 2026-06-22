# ref: https://wiki.nixos.org/wiki/Jellyfin
{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.sysSettings.server.jellyfin;
in
{
  options = {
    sysSettings.server.jellyfin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Jellyfin server";
      }; # end of jellyfin.enable
      juser = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Jellyfin user";
      }; # end of jellyfin.juser
    }; # end of jellyfin
  }; # end of options

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
      user = cfg.juser;
      # note: the default port is 8096.

      # hardware acceleration
      # hardwareAcceleration = {
      #   enable = true;
      #   type = "nvenc";
      #   device = "/dev/dri/by-path/pci-0000:01:00.0-render"; # device path for hardware acceleration
      # }; # end of hardwareAcceleration
    }; # end of services.jellyfin

    # packages
    environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-desktop
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ]; # end of environment.systemPackages

    # user
    # sets the jellyfin group to include all users
    users.groups = {
      jellyfin = {
        members = config.sysSettings.users;
      }; # end of jellyfin
    }; # end of users.groups
  }; # end of config
}
