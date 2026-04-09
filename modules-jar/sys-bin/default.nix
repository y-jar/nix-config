{ ... }:
{
  # imports other modules like:
  # -the hardware configuration for support
  # -desktop module for adding a baseline for UX (currently sway and wayland)
  # -Other nodes where it is important to take mesures to seperate(flatpaks)
  #  NOTE on flatpak-manager.nix, after rebuild switching, be sure to reboot. 
  #  		Then you can run a command like ```flatpak install flathub bazaar```
  
  # this is where everything gets called
  imports = [
    # Main Sys
    ./configuration.nix # loads main contents of the system
    ./nix-settings.nix # Loads settings for nix ie. buffer size for downloads
    ./networking.nix # firewall and app specific netoworking fixes
    ./audio.nix # [WIP] handles audio
    ./display.nix # Sets up DE / WMs + other related stuff
    ./login-manager.nix # Sets up and enables a login screen like sddm
    #./virtualization.nix # [WIP] Enables the use of VMs
    # 
    ./v412loopback.nix # Enables the Camera OBS Option
    ./flatpak-manager.nix # flatpack settings / fixes
    ./fonts.nix # loads System fonts [refer if ricing]
    ./load-scripts.nix # adds scripts for the system
  ];
}
