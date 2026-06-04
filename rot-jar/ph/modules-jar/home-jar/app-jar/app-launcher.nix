{pkgs, ...}:
{
	programs.fuzzel = {
	  enable = true;
	  settings = {
	    main = {
	      font = "IntoneMono Nerd Font:size=12";
	      terminal = "foot";
	      prompt = "糸  ";
	      width = 30;
	      horizontal-pad = 20;
	    };
	    colors = {
	      background = "2b2622bf"; # Matches Waybar 75% opacity
	      text = "e6dfd3ff";
	      match = "d79921ff";
	      selection = "45403dff";
	      selection-text = "ebdbb2ff";
	      border = "d79921ff";
	    };
	  };
	};
}
