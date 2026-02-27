{ pkgs, ... }:

{
  # Enable the underlying Flatpak services and visual things
  services.flatpak.enable = true;
  services.packagekit.enable = true; # for some sec questions some apps might need
  services.dbus.enable = true; # Ensures apps can talk to the system for things like notifications
  fonts.fontDir.enable = true; # This makes sure Flatpaks can see the fonts you installed via Nix

  
  # THE PASSWORD POPUP (Polkit)
  # This allows Bazaar to ask the system for permission to install things
  security.polkit.enable = true;
  
  # Essential for Wayland/Sway. This lets Flatpaks "talk" to the system system... hopefully..
  # goodness this is annoying
  xdg.portal = {
    enable = true;
    wlr.enable = true; # Specifically for Sway
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # Standard fallback
    config.common.default = "*"; # Uses available portals for everything
  };

  # STEAM FIX: This is the important part!
  # It installs the 'udev rules' so controllers are recognized
  hardware.steam-hardware.enable = true;

  # This allows Flatpak to mount the filesystems it needs for installation
  boot.supportedFilesystems = [ "fuse" ];
  environment.systemPackages = [ pkgs.fuse3 pkgs.polkit_gnome ];

  # Desktop Integration
  

  # Optional: Auto-add Flathub (The "App Store" source, VERY NICE
  # 	Kus i be forgetting it everytime)
  # This runs a script on activation so you don't have to run the 
  # 'flatpak remote-add' command manually.
  system.activationScripts.flatpak-repo = {
    text = ''
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
