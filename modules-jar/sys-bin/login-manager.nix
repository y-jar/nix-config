{ pkgs, ...}:
{
    # KDE's SDDM
    # services.displayManager.sddm = {
    #     enable = false;
    #     wayland.enable = true;
    #     theme = "catppuccin-mocha-mauve"; # comes from pkgs.catppuccin-sddm
    #     # Options: catppuccin-latte / catppuccin-frappe / catppuccin-macchiato / catppuccin-mocha

    #     # settings for sddm
    #     settings = {
    #       Theme = {
    #         Background = "/etc/nixos-wallpaper/wallpick.webp";
    #       };
    #     };
    #     # make the theme visible to SDDM
    #     extraPackages = [ pkgs.catppuccin-sddm ]; 
    # };

    # copy wallpick.webp into the built system
    # environment.etc."nixos-wallpaper/wallpick.webp" = {
    #     source = ./wallpick.webp; # MY WALLPAPR :P
    # };

    # Gnome's GDM
    services.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
}