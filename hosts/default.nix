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
    ./hardware-config.nix
    ../modules-jar/sys-bin/default.nix
  ];
}
