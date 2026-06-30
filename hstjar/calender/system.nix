{
  inputs,
  config,
  lib,
  ...
}:

{
  config = {
    system.stateVersion = "25.11"; # [CHANGE THIS]
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
      niri.enable = true; # sets niri
      cinnamon.enable = false; # sets cinnamon
      # =============[experience install]^^^

      # =============[hardware]
      # nvidia.enable = true;
      bluetooth.enable = false; # sets blueman in home packages
      # [power management]
      tlp.enable = false; # NOTE: mutually exclusive with powerprofiles, pick one
      powerprofiles.enable = true;
      audio = {
        enable = true; # sets audio and adds some apps
        addon.enable = true; # adds my audio setup
      };
      # =============[hardware]^^^

      # =============[software]
      localsend.enable = true;
      flatpak.enable = false; # sets flatpak in the system [still needs to be enabled in user.nix]
      gaming = {
        drivers = {
          enable = true; # sets gaming drivers
          amd.enable = true; # sets amd drivers
          intel.enable = false; # sets intel drivers
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
          juser = "jar"; # sets jellyfin user for perms for file access
        }; # end of jellyfin
      }; # end of server
    }; # end of sysSettings

    # set user for git [be sure to replace all instances of USERNAME and NAME
    #                     with your actual username and name                 ]
    users.users.jar.description = "jar";
    home-manager.users.jar.usrSettings = {
      name = "y-jar"; # This is mainly used for my git settings :P
      email = "park.7qs@gmaiil.com";
    };
  }; # end of config
}
