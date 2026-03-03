{
  description = "Main Config Flake";

  inputs = {
    # THis is where one can chanage the version of the os
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # places home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let
  	# NOTE: Change this to whatever WMs/DEs you have in the default within ./modules-jar/home-jar/ui-bin/default.nix
  	chosenDesktop = "sway";

	# NOTE: change this to the hostName you want, the presets i made are:
	# 	yil-jar, 'calender', cold-flip, or aanri
	chosenHost = "yil-jar";
  in {
    # NOTE This MUST match your 'networking.hostName'(networking.nix) @ 'nixosConfigurations.HOSTNAME = ...'
    nixosConfigurations.${chosenHost} = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # not needed but added (thx tony uses nix btw)

      #special arguments to pass to modules that need them.
      specialArgs = { 
      	inherit inputs;
	desktop = chosenDesktop;
	hostnm = chosenHost;
      };

      # 
      modules = [
        ./hosts-jar/${chosenHost}/default.nix # The system entry, uses the picked host for the dir name

	# manages and outputs settings for home-manager
        home-manager.nixosModules.home-manager {
	  # basic reqs to enable
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

	  # extraSpecialArgs passes vars from specialArgs to home-manager modules that call req them. Ex: { pkgs, desktop, ...}: We pulled 'desktop' 
	  # EXTRA NOTE: if a arg is passed, and something needs it, all preceeding nodes must pull it so the last node can use it.
	  home-manager.extraSpecialArgs = {
	  	inherit inputs; # no clue on what
	  	desktop = chosenDesktop; # this sets the arg so we can just change the de/WM in the let block.
		hostnm = chosenHost; # sets the hostname for home-manager
	  };

	  # sets the main user home Entry so we can use stuff
          home-manager.users.jar = import ./modules-jar/home-jar/default.nix;
	  home-manager.backupFileExtension = "backup"; # backups stuff if conflicting
        }
      ];
    };
  };
}

