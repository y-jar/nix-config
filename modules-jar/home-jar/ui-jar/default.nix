{pkgs, ...}:

{
    # This imports the modules depending on what the user picked within the main flake.nix.
    imports = [
        ./niri-bin/default.nix
        # ./sway-bin/default.nix
        ./waybar.nix
     ];
}
