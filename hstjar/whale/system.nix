{
  inputs,
  config,
  lib,
  ...
}:

{
  config = {
    system.stateVersion = "VersionNumber"; # [CHANGE THIS]
    #            [note, this should be the same as the home manager state version]
    #            [system state version from first install]
    home-manager.users.PLEASECHANGEME_USERNAME.home.stateVersion = "HomeManagerVersionNumber"; # [CHANGE THIS]
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
      hyprland.enable = false; # sets hyprland ~19MiB
      niri.enable = true; # sets niri
      # =============[experience install]^^^

      # =============[hardware]
      # nvidia.enable = true;
      bluetooth.enable = true; # sets blueman in home packages
      # [power management]
      tlp.enable = false; # NOTE: mutually exclusive with powerprofiles, pick one
      powerprofiles.enable = true;
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
          amd.enable = false; # sets amd drivers
          intel.enable = true; # sets intel drivers
          nvidia.enable = false; # sets nvidia drivers [NOT IMPLEMENTED]
        }; # end of drivers
        steam.enable = false; # sets steam and associated libraries for gaming, but not more important drivers
      }; # end of gaming
      virtcam.enable = false; # sets virtual camera for things like OBS
      virt.enable = false; # sets virtualization and installs virtualization tools
      # =============[software]^^^

      # =============[Server]
      server = {
        jellyfin = {
          enable = true; # sets jellyfin server
          juser = "jar"; # sets jellyfin user for perms for file access
        }; # end of jellyfin
      }; # end of server
      # =============[Server]^^^
    }; # end of sysSettings

    # set user for git [be sure to replace all instances of USERNAME and NAME
    #                     with your actual username and name                 ]
    users.users.jar.description = "jar";
    home-manager.users.jar.usrSettings = {
      name = "y-jar";
      email = "park.7qs@gmail.com";
    };
  }; # end of config
}
