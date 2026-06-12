{ config, lib, ... }:

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
      hyprland.enable = true; # sets hyprland
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
        addon.enable = true; # adds my audio setup
      };
      # =============[hardware]^^^

      # =============[software]
      flatpak.enable = true; # sets flatpak in the system [still needs to be enabled in user.nix]
      gaming = {
        steam.enable = true; # sets steam
        prism.enable = true; # sets prismlauncher
        heroic.enable = true; # sets heroic
      };
      virtcam.enable = true; # sets virtual camera for things like OBS
      virt.enable = true; # sets virtualization and installs virtualization tools
      # =============[software]^^^
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
