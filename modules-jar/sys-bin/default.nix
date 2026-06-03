{ ... }:
{
  # this is where everything gets called
  imports = [
    # Main Sys
    ./configuration.nix # loads main contents of the system
    ./users.nix # Loads the users
    ./nix-settings.nix # Loads settings for nix ie. buffer size for downloads
    ./networking.nix # firewall and app specific netoworking fixes
    ./audio.nix # Handles audio [also refers to other audio files]
    ./display.nix # Sets up DE / WMs + other related stuff
    ./login-manager.nix # Sets up and enables a login screen like sddm or gdm
    # ./virtualization.nix # [WIP] Enables the use of VMs
    ./languages.nix # main languages and associated things
    # 
    ./v412loopback.nix # Enables the Camera OBS Option
    ./flatpak-manager.nix # flatpack settings / fixes
    ./fonts.nix # loads System fonts [refer if ricing]
    ./load-scripts.nix # adds scripts for the system
  ];
}
