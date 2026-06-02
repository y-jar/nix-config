{pkgs, ...}:

{
    # This imports the modules depending on what the user picked within the main flake.nix.
    imports = [
        ./niri-bin/default.nix # My super epic niri config
        # ./sway-bin/default.nix
        ./wayle.nix # wayle the super epic uhhh shell? i am not sure on what it is
        # ./noctalia.nix # a Quick shell 
    ];
}
