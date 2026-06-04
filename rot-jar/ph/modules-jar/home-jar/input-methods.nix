{ pkgs, ... }: {
  i18n.inputMethod = {
    enable = true; 
    type = "fcitx5";
    # fcitx
    fcitx5 = {
      addons = with pkgs; [ 
        fcitx5-mozc 
      ];

      # Hardcode the input order directly via Nix
      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us"; # Sets the underlying base system layout
        };
        # Item 0 is my absolute boot default
        "Groups/0/Items/0".Name = "keyboard-us"; 
        
        # Item 1 is what i toggle into when want Japanese
        "Groups/0/Items/1".Name = "mozc";
      }; # End of Settings
    }; # End of fcitx5
  }; # End of i18n

  # home.sessionVariables = {
  #   GTK_IM_MODULE = "";
  #   QT_IM_MODULE = "";
  #   XMODIFIERS = "@im=fcitx"; 
  # };
}