{
  # ===========================inputs
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
    # noctalia = {
    #   url = "github:noctalia-dev/noctalia-shell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  }; # end of inputs

  # ==========================outputs
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      # from what i understand: this `set` below is declairations of indevidual hosts and loads them..
      nixosConfigurations = {
        # ======[]
        calender = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            hostnm = "calender";
          };
          modules = [
            ./modules/sys-bin/0-base.nix # base system entry
            ./modules/host-jar/calender/calender.nix # entry system
          ]; # end of modules
        }; # end of calender
        # ======[]
        flipped-jar = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            hostnm = "flipped-jar";
          };
          modules = [
            ./modules/sys-bin/base.nix # base system entry
            ./modules/host-jar/flipped-jar/flipped-jar.nix # entry system
          ]; # end of modules
        }; # end of flipped-jar
        # ======[]
        yilyonix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            hostnm = "yilyonix";
          };
          modules = [
            ./modules/sys-bin/base.nix # base system entry
            ./modules/host-jar/yilyonix/yilyonix.nix # entry system
          ]; # end of modules
        }; # end of yilyonix
        # ======[]
        # PLACEHOLDER = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     ./modules/sys-bin/base.nix # base system entry
        #     ./modules/host-jar/PLACEHOLDER/PLACEHOLDER.nix # entry system
        #   ]; # end of modules
        # }; # end of END OF PLACEHOLDER
      }; # end of configurations
    }; # end of outputs
}
