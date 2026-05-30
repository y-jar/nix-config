{
  description = "do jars contain flakesQ";
  
  # =========================INPUTS==============================
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
  # var block
  let
    local = import ./local.nix; # imports the file that contains my hostname, after an install, find a way to just remove it or something./..
    # BEFORE YOU USE THIS CONFIG: change this to the hostName you want(within local.nix), note, be sure to read the error warning if you dont use what i have pre configured within hosts-jar/
    chosenHost = local.chosenHost; # this mainly affects the window manager sub option, making sure screen stuff works.
    sharedArgs = { inherit inputs; hostnm = host; }; # sharedArgs fuynctions as global args

  in {
    #=============================================OUTPUTS====================================================
    # Configures the OS, block
    # NOTE This MUST match your 'networking.hostName'(networking.nix) @ 'nixosConfigurations.HOSTNAME = ...'
    nixosConfigurations.${chosenHost} = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # not needed but added (thx tony uses nix btw)
      #special arguments to pass to modules that need them. the `...` in {}:
      specialArgs = sharedArgs;

      # 
      modules = [
        # The system entry, uses the picked host for the dir name
        # WARNING READ BEFORE LEAVING: Will give an error if hostname doesnt have a default.nix within it's own hosts-jar directory
        # to add your own, just make a new dir within hosts-jar and copy /nixos/default.nix into your new dir so it will not give an error
        ./hosts-jar/${chosenHost}/default.nix

        # [home-manager]: manages and outputs settings for home-manager
        home-manager.nixosModules.home-manager {
          # setup
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup"; # backups stuff if conflicting
          home-manager.extraSpecialArgs = sharedArgs; # shared my args
          home-manager.users.jar = import ./modules-jar/home-jar/default.nix; # sets the main user home Entry
        } # end of home manager

        # []
      ]; # end of modules
    }; # end of nixosConfigurations
  }; # end of output `in`
} # end of flake module

