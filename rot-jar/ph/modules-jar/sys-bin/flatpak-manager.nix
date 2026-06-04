{ pkgs, ... }:

{
  services.flatpak.enable = true;
  services.packagekit.enable = true;
  services.dbus.enable = true;
  fonts.fontDir.enable = true;

  security.polkit.enable = true;

  # Portal is handled by display.nix based on desktop choice
  xdg.portal.enable = true; # just ensure it's on, display.nix configures the rest

  # Auto-add Flathub (The "App Store" source, VERY NICE
  # 	Kus i be forgetting it everytime)
  # This runs a script on activation so you don't have to run the 
  # 'flatpak remote-add' command manually.
  # system.activationScripts.flatpak-repo = {
  #   text = ''
  #     ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  #   '';
  # };
}
