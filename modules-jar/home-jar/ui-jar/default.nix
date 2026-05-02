{pkgs, ...}:

{
    # This imports the modules depending on what the user picked within the main flake.nix.
    imports = [ ]
    ++ (if desktop == "sway" then [ ./sway-bin/default.nix ] else [ ])
    ++ (if desktop == "niri" then [ ./niri-bin/default.nix ] else [ ]);
}
