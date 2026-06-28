#*/-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Hi, This is the system configuration file for the picked host.
# If you're new here, just think of it as a checklist to fill out.
# Things to note:
# 1. You should change the stateVersion to the version you're using
# 2. You should change the home-manager state version to the version you're using
# 3. You should change all PLEASECHANGEME_* placeholders to your actual username
#   or values.
# 4. whether or not something is false or true is entirely up to you. enable what
#    you need!
#
# And remember, your configuration is yours to customize.
# After you're done, head over to ./user.nix to configure your user!
#*/-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

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
      users = [ "PLEASECHANGEME_USERNAME" ];
      adminUsers = [ "PLEASECHANGEME_USERNAME" ];
      # =============[users]^^^

      # =============[experience install]
      # [pick one or more if you know what you're doing]
      gnome.enable = true; # sets gnome [on by default]
      hyprland.enable = true; # sets hyprland ~19MiB
      niri.enable = true; # sets niri
      cinnamon.enable = true; # sets cinnamon
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
      localsend.enable = true; # sets localsend in the system
      flatpak.enable = false; # sets flatpak in the system [still needs to be enabled in user.nix]
      gaming = {
        drivers = {
          enable = true; # sets gaming drivers
          amd.enable = false; # sets amd drivers
          intel.enable = false; # sets intel drivers
          nvidia.enable = false; # sets nvidia drivers [NOT IMPLEMENTED]
        }; # end of drivers
        steam.enable = true; # sets steam and associated libraries for gaming, but not more important drivers
      }; # end of gaming
      virtcam.enable = false; # sets virtual camera for things like OBS
      virt.enable = true; # sets virtualization and installs virtualization tools
      # =============[software]^^^

      # =============[Server]
      server = {
        jellyfin = {
          enable = false; # sets jellyfin server
          juser = "PLEASECHANGEME_USERNAME"; # sets jellyfin user for perms for file access
        }; # end of jellyfin
        sleepyjar = {
          enable = false; # sets sleepy service
          interval = "weekly"; # sets interval for sleepy service
          # some* options for sleepy service:
          # daily: reboots every midnight
          # weekly: reboots every Sunday at midnight
          # "Fri 03:00:00": reboots every Friday at 3am
          # "*-*-1,15 02:00:00": reboots on the 1st and 15th of every month at 2am
        }; # end of sleepyjar
      }; # end of server
      # =============[Server]^^^
    }; # end of sysSettings

    # set user for git [be sure to replace all instances of USERNAME and NAME
    #                     with your actual username and name                 ]
    users.users.PLEASECHANGEME_USERNAME.description = "NAME";
    home-manager.users.PLEASECHANGEME_USERNAME.usrSettings = {
      name = "PLEASECHANGEME_NAME";
      email = "PLEASECHANGEME_EMAIL";
    };
  }; # end of config
}
