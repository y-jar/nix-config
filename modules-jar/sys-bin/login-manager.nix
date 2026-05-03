{ pkgs, ...}:
{
    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "catppuccin-mocha"; # comes from pkgs.catppuccin-sddm
        # Options: catppuccin-latte / catppuccin-frappe / catppuccin-macchiato / catppuccin-mocha

        # settings for sddm
        settings = {
          Theme = {
            Background = "/etc/nixos-wallpaper/wallpick.webp";
          };
        };
    };

    # copy wallpick.webp into the built system
    environment.etc."nixos-wallpaper/wallpick.webp" = {
        source = ./wallpick.webp; # MY WALLPAPR :P
    };
}