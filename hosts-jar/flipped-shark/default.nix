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
    ./hardware-configuration.nix # grabs the hardware
    ../../modules-jar/sys-bin/default.nix # loads the system config
    #./battery-config.nix # handles my max charge fixs
    ./hardware-fix.nix
  ];
  # add Bootloader options here[from /etc/nixos/configuration.nix]
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
