{ pkgs, desktop, ... }:
{
  imports = [
    # App Module Paths
    ./foot.nix 		     # Pulls in terminal/font settings
    ./nvim.nix 		     # Pulls the nvim config (this is under heavy questioning)
    ./app-launcher.nix	     # Pulls the app-launcher
    ./fastfetch.nix # Pulls my fastfetch config
  ];
}
