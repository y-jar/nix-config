{ ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "IntoneMono Nerd Font\:size=11";
        pad = "15x15"; # Adds some breathing room inside the window
      };

      colors-dark = {
        # background = "1a1b26";
        # foreground = "cfc9c2";
        alpha = 0.7; # trans parency
      };

      cursor = {
        style = "beam";
        blink = "yes";
      };
    };
  };
}
