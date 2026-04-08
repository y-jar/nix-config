{ pkgs, ...}:
{
    # This will fuction if i want to configure sddm
    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true; # makes sure sddm runs through wayland
        # THEME: do some searching, just enter what they say to enter
        #theme = "";
    };

    # Downlaod themes here
    # environment.systemPackages = with pkgs; [
    #     cowsay
    # ];
}