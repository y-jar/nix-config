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

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # NOTE This MUST match your 'networking.hostName'
    nixosConfigurations.yil-jar = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/default.nix # The system entry
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jar = import ./modules-jar/home-jar/default.nix;
          home-manager.backupFileExtension = "backup"; 
          # ^^for files that dont work when rebuilding, 
          #   it will just back them up so it can do it correctly
        }
      ];
    };
  };
}

