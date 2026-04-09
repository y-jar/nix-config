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

    # flatpak method to install via nix [be sure to add it to `outputs = {}`]
    #nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let
  #=====================================MAKE CHANGES HERE==============================================
  	# NOTE: Change this to whatever WMs/DEs you have in the default within ./modules-jar/home-jar/ui-bin/default.nix
  	# current listed options[has to be named the pkg]:
    #  sway[waybar], niri[workin progress], plasma[comes with basic apps with]
  	chosenDesktop = "plasma";

	# BEFORE YOU USE THIS CONFIG: change this to the hostName you want, the presets i made are:
  # DEFAULT [if i dont know or anyone else]:
  # nixos [note, swap out the hardwareconfig file with the one within the /etc/nixos/.. dir]
  # VIRTUAL MECHINE OPTION[bios]
  #   vmo
  # OTHER HOSTNAMES [More will be added as i go]:
  # 	yilyonix, 'calender', cold-flip, aanri, tyun
	chosenHost = "yilyonix"; # this mainly affects the window manager sub option, making sure screen stuff works.


  #=============================================Outputs====================================================
  in {
    # Configures the OS, block
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
        # The system entry, uses the picked host for the dir name
        ./hosts-jar/${chosenHost}/default.nix

        # manages and outputs settings for home-manager
        home-manager.nixosModules.home-manager {
          # basic reqs to enable
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # [extraSpecialArgs] passes vars or modules as specialArgs to home-manager modules that call req them.
          #   Ex: { pkgs, desktop, ...}: We pulled 'desktop'
          # EXTRA NOTE: if an arg is passed, and something needs it, all preceeding nodes must pull it
          #   [using `...`]. Once you reach a file that uses it and has ... in files before it, call the arg in
          # the method arguments imput at the top Ex. { pkgs, hostnm, ...}:
          #                                                   ||||||  |||
          #                                                   |||||| [use this in preceeding files 2 pass hostnm]
          #                                                 [Arg you want for a specific file]
          home-manager.extraSpecialArgs = {
            inherit inputs; # no clue on what
            desktop = chosenDesktop; # this sets the arg so we can just change the de/WM in the let block.
            hostnm = chosenHost; # sets the hostname for home-manager
          };

          # sets the main user home Entry so we can use stuff
          home-manager.users.jar = import ./modules-jar/home-jar/default.nix;
          home-manager.backupFileExtension = "backup"; # backups stuff if conflicting
        } # end of home manager

        # method for installing flatpaks declareitivly*
        #nix-flatpak.nixosModules.nix-flatpak
      ]; # end of modules
    }; # end of nixosConfigurations
  }; # end of output `in`
} # end of flake module

