{ pkgs, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "IntoneMono Nerd Font:size=11";
        pad = "15x15"; # Adds some breathing room inside the window
      };

      colors = {
        # This is a nice "Dark Charcoal" theme
        background = "1a1b26";
        foreground = "cfc9c2";
        
        # You can also set transparency (0.0 to 1.0)
        alpha = 0.7; 
      };

      cursor = {
        style = "beam";
        blink = "yes";
      };
    };
  };
}
