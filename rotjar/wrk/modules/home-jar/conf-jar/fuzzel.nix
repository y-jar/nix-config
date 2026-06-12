{ ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "IntoneMono Nerd Font:size=12"; # the font to use
        terminal = "foot"; # the terminal to use
        prompt = "糸 >"; # the prompt to use
        width = 30; # the width of the fuzzel window
        horizontal-pad = 20; # the horizontal padding of the fuzzel window
      }; # end of main
      colors = {
        background = "2b2622bf"; # the background color
        text = "e6dfd3ff"; # the text color
        match = "d79921ff"; # the match color
        selection = "45403dff"; # the selection color
        selection-text = "ebdbb2ff"; # the selection text color
        border = "d79921ff"; # the border color
      }; # end of colors
    }; # end of settings
  }; # end of fuzzel
}
