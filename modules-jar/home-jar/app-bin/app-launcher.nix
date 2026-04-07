{pkgs, ...}:
{
	programs.anyrun = {
		enable = true;
		config = {
		    x = { fraction = 0.5; };
		    y = { fraction = 0.3; };
		    width = { fraction = 0.3; };
		    hideIcons = false;
		    ignoreExclusiveZones = false;
		    layer = "overlay";
		    hideOnBlur = true;
		    closeOnClick = true;
		    showResultsImmediately = true;
		    maxEntries = 5;
		};
	};
}
