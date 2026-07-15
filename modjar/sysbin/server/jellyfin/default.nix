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
        description = "Enable Jellyfin server (~500MiB)";
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
      openFirewall = true; # Open firewall for Jellyfin[8096 and another port]
      user = cfg.juser; # Jellyfin user
      # note: the default port is 8096.

      # [hardware acceleration]
      # hardwareAcceleration = {
      #   enable = true;
      #   type = "nvenc";
      #   device = "/dev/dri/by-path/pci-0000:01:00.0-render"; # device path for hardware acceleration
      # }; # end of hardwareAcceleration
    }; # end of services.jellyfin

    # [packages]
    environment.systemPackages = [
      pkgs.jellyfin # Jellyfin Server
      pkgs.jellyfin-desktop # Jellyfin Desktop Client
      pkgs.jellyfin-web # Web Client for Jellyfin
      pkgs.jellyfin-ffmpeg # Complete, cross-platform solution to record, convert and stream audio and video (Jellyfin fork)
    ]; # end of environment.systemPackages

    # [sets the jellyfin group to include all users]
    users.groups = {
      jellyfin = {
        members = config.sysSettings.users;
      }; # end of jellyfin
    }; # end of users.groups
  }; # end of config
} # end of End
