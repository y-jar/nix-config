{ pkgs, ...}:
{
    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        # theme = "catppuccin-mocha";

        # settings = {
        #   Theme = {
        #     Current = "layan";
        #     CursorTheme = "breeze_cursors";
        #     Font = "Noto Sans,10,-1,5,50,0,0,0,0,0";
        #   };
        #   Users = {
        #     MaximumUid = 60000;
        #     MinimumUid = 1000;
        #   };
        # };
    };
}