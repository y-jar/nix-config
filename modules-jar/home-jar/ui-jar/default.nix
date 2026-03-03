{pkgs, desktop, ...}:

{
    # This imports the modules depending on what the user picked within the main flake.nix.
    imports = [ ]
    ++ (if desktop == "sway" then [ ./sway.nix ] else [ ])
    ++ (if desktop == "niri" then [ ./niri.nix ] else [ ]);
}
