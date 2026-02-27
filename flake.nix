{
  description = "Jar's Modular NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # This MUST match your 'networking.hostName'
    nixosConfigurations.yil-jar = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/yil-jar/default.nix # The system entry
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jar = import ./modules/home/default.nix;
          home-manager.backupFileExtension = "backup"; # for files that dont work when rebuilding, it will just back them up so it can do it correctly
        }
      ];
    };
  };
}

