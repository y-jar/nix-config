{
  inputs,
  config,
  lib,
  ...
}:

{
  config = {
    system.stateVersion = "26.05"; # [CHANGE THIS]
    #            [note, this should be the same as the home manager state version]
    #            [system state version from first install]
    home-manager.users.jar.home.stateVersion = "26.05"; # [CHANGE THIS]
    #            [home manager state version from first install]

    # Fill this out!
    sysSettings = {
      # =============[users] [list of users to create]
      users = [ "jar" ];
      adminUsers = [ "jar" ];
      # =============[users]^^^

      # =============[experience install]
      # [pick one or more if you know what you're doing]
      gnome.enable = true; # sets gnome [on by default]
      hyprland.enable = false; # sets hyprland
      niri.enable = false; # sets niri
      # =============[experience install]^^^

      # =============[hardware]
      # nvidia.enable = true;
      bluetooth.enable = true; # sets blueman in home packages
      # [power management]
      tlp.enable = false; # NOTE: mutually exclusive with powerprofiles, pick one
      powerprofiles.enable = true; # sets power profiles daemon [what i prefer]
      audio = {
        enable = true; # sets audio and adds some apps
        addon.enable = false; # adds my audio setup
      };
      # =============[hardware]^^^

      # =============[software]
      flatpak.enable = false; # sets flatpak in the system [still needs to be enabled in user.nix]
      gaming = {
        drivers = {
          enable = true; # sets gaming drivers
          amd.enable = true; # sets amd drivers
          intel.enable = false; # sets intel drivers
          nvidia.enable = false; # sets nvidia drivers [NOT IMPLEMENTED]
        }; # end of drivers
        steam.enable = true; # sets steam and associated libraries for gaming, but not more important drivers
      }; # end of gaming
      virtcam.enable = true; # sets virtual camera for things like OBS
      virt.enable = true; # sets virtualization and installs virtualization tools
      # =============[software]^^^
      # =============[Server]
      server = {
        jellyfin = {
          enable = false; # sets jellyfin server
          juser = "candle"; # sets jellyfin user for perms for file access
        }; # end of jellyfin
      }; # end of server
    }; # end of sysSettings

    # set user for git [be sure to replace all instances of USERNAME and NAME
    #                     with your actual username and name                 ]
    users.users.jar.description = "jar";
    home-manager.users.jar.usrSettings = {
      name = "jar";
      email = "park.7qs@gmail.com";
    };
  }; # end of config
}
