{
  ...
}:
{
  imports = [
    ./audio.nix # sets up my audio config
    ./pkgs-base.nix # ALL SYS LEVEL PKGS
    ./power.nix # anything power related
    ./users.nix # declairs users
    ./networking.nix # anything network related that isnt host specific
    ./security.nix # smart things
    ./fonts.nix # grabs them fonts
    ./gaming.nix # any gaming related fixes that isnt host specific
    #
    ./display.nix # sets up anything sparkly [niri, gnome..]
    ./display-pkgs.nix # anything DE or WM asisting pkgs
    ./way-portal.nix # anything portal or wayland related is mostly here
    ./login-manager.nix # surely you know...
    #
    ./zsh.nix # my shell of choice
    ./load-scripts.nix # loads any custom scripts
    #
    ./tweaks.nix # This is where any unsorted fixes go
    ../nix-bin/nix-settings.nix # any nix settings
  ];
  # Set what timeZone you want
  time.timeZone = "America/New_York";
  system.stateVersion = "25.11"; # keep this the same :)
}
