{
  # ======[]
  description = "Nix in a Jar"; # a flake for managing my per host nixos configurations
  # ======[]
  # ===========================inputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05"; # this sets the version of nixpkgs to use [I try to keep it up to date]

    # grabs home-manager from the nix-community repo
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs"; # locks version to the nixpkgs to reduce duplicate data
    };

    # noctalia is a NixOS module for managing the Noctalia shell [the pretty bar/shell for niri and hyprland]
    # noctalia @ https://docs.noctalia.dev/v4/getting-started/nixos/
    # noctalia = {
    #   url = "github:noctalia-dev/noctalia-shell";
    #   inputs.nixpkgs.follows = "nixpkgs"; # locks version to the nixpkgs to reduce duplicate data
    # };
  }; # end of inputs

  # ==========================outputs
  # ======[]
  # this is where the actual NixOS configurations are defined
  # each entry here corresponds to a host-jar/configuration
  # ======[]
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        # ======[]
        calender = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            hostnm = "calender";
          };
          modules = [
            ./modules/sys-bin # base system entry
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
            ./modules/sys-bin # base system entry
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
            ./modules/sys-bin # base system entry
            ./modules/host-jar/yilyonix/yilyonix.nix # entry system
          ]; # end of modules
        }; # end of yilyonix
        # ======[]
        # PLACEHOLDER = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs;
        #     hostnm = "PLACEHOLDER";
        #   };
        #   modules = [
        #     ./modules/sys-bin # base sys entry for all hosts [for per host, system setup is within host-jar/[HOST]/default.nix->Wherever]
        #     ./modules/host-jar/PLACEHOLDER # config entry directory within host-jar/
        #   ]; # end of modules
        # }; # end of END OF PLACEHOLDER
      }; # end of configurations
    }; # end of outputs
}
