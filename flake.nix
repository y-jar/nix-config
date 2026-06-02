{
  description = "do jars contain flakesQ";
  
  # =========================INPUTS==============================
  inputs = {
    # THis is where one can chanage the version of the os
    # linktoothers: 
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # places home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs"; # locks version to the nixpkgs to reduce duplicate data
    };

    # noctalia @ https://docs.noctalia.dev/v4/getting-started/nixos/
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  # var block
  let
    local = import ./local.nix; # imports the file that contains my hostname, after an install, find a way to just remove it or something./..
    chosenHost = local.chosenHost; # this mainly affects the window manager sub option, making sure screen stuff works.
    sharedArgs = { inherit inputs; hostnm = chosenHost; }; # sharedArgs fuynctions as global args
  in {
    #=============================================OUTPUTS====================================================
    # NOTE This MUST match your 'networking.hostName'(networking.nix) @ 'nixosConfigurations.HOSTNAME = ...'
    nixosConfigurations.${chosenHost} = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # not needed but added (thx tony uses nix btw)
      specialArgs = sharedArgs; # arguments to pass to modules that need them. the `...` in {}:
      # the placement
      modules = [
        # The system entry, uses the picked host for the dir name
        # WARNING READ BEFORE LEAVING: Will give an error if hostname doesnt have a default.nix within it's own hosts-jar directory
        # to add your own, just make a new dir within hosts-jar and copy /nixos/default.nix into your new dir so it will not give an error
        ./hosts-jar/${chosenHost}/default.nix

        # [home-manager]
        home-manager.nixosModules.home-manager {
          # setup
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup"; # backups stuff if conflicting
            extraSpecialArgs = sharedArgs; # shared my args
            users = {
              jar = import ./modules-jar/home-jar/default.nix; # sets the home Entry for jar
            };
          };
        } # end of home manager
      ]; # end of modules
    }; # end of nixosConfigurations
  }; # end of output `in`
} # end of flake module

