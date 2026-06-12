{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysSettings.gaming.steam;
in
{
  options = {
    sysSettings.gaming.steam.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables Steam";
    }; # end of sysSettings.gaming.steam.enable
  }; # end of options

  config = lib.mkIf cfg.enable {
    hardware.steam-hardware.enable = true;
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      # extra packages
      extraPackages = with pkgs; [
        libxcursor # X Cursor extension
        libxi # X Input extension
        libxinerama # Xinerama extension
        libxscrnsaver # X Screen Saver extension
        libpng # PNG image format library
        libpulseaudio # PulseAudio is a free and open-source sound server
        libvorbis # Vorbis audio compression reference implementation
        stdenv.cc.cc.lib # The default build environment for Unix packages in Nixpkgs and gcc
        libkrb5 # MIT Kerberos 5
        keyutils # Tools used to control the Linux kernel key management system
        mangohud # for huds
        protonup-qt # installer for proton versions
      ]; # end of extraPackages
    }; # end of programs.steam

    # sets the steam group to include all users
    users.groups = {
      steam = {
        members = config.sysSettings.users;
      };
    }; # end of users.groups
    # firewall rules for steam, from
    networking.firewall.allowedTCPPorts = [ 24872 ];
    networking.firewall.allowedUDPPorts = [ 24872 ];
  }; # end of config
}
