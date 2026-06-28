{
  # ======[]
  description = "My nix within a Jar";
  # ======[OUTPUTS]
  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        # THIS is a template for creating new nixos configurations,
        #     Just copy and paste this block and replace TEMPLATE
        #     with the name of your new configuration
        # ========[]
        # TEMPLATE = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = {
        #     inherit inputs;
        #     hostnm = "TEMPLATE"; # sets HOSTNAME [within, modjar/sysbin/networking/default.nix]
        #   }; # end of specialArgs
        #   modules = [
        #     ./modjar/sysbin # base system entry
        #     ./hstjar/TEMPLATE # entry system [configurate in this directory]
        #     # ^^^^^^          | In this directory is where home-manager configuration is stored
        #   ]; # end of modules
        # }; # end of TEMPLATE

        # ========[]
        loom = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            hostnm = "loom"; # sets HOSTNAME
          }; # end of specialArgs
          modules = [
            ./modjar/sysbin # base system entry
            ./hstjar/loom # entry system
          ]; # end of modules
        }; # end of loom

        # ========[]
        calender = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            hostnm = "calender"; # sets HOSTNAME
          }; # end of specialArgs
          modules = [
            ./modjar/sysbin # base system entry
            ./hstjar/calender # entry system
          ]; # end of modules
        }; # end of calender

        # ========[]
        yilyonix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            hostnm = "yilyonix"; # sets HOSTNAME
          }; # end of specialArgs
          modules = [
            ./modjar/sysbin # base system entry
            ./hstjar/yilyonix # entry system
          ]; # end of modules
        }; # end of yilyonix

        # ========[]
        ziiemar = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            hostnm = "ziiemar"; # sets HOSTNAME
          }; # end of specialArgs
          modules = [
            ./modjar/sysbin # base system entry
            ./hstjar/ziiemar # entry system [configurate in this directory]
            # ^^^^^^          | In this directory is where home-manager configuration is stored
          ]; # end of modules
        }; # end of ziiemar

        # ========[]
        candle = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            hostnm = "candle"; # sets HOSTNAME [within, modjar/sysbin/networking/default.nix]
          }; # end of specialArgs
          modules = [
            ./modjar/sysbin # base system entry
            ./hstjar/candle # entry system [configurate in this directory]
            # ^^^^^^          | In this directory is where home-manager configuration is stored
          ]; # end of modules
        }; # end of candle

        # ========[]
        whale = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            hostnm = "whale"; # sets HOSTNAME
          }; # end of specialArgs
          modules = [
            ./modjar/sysbin # base system entry
            ./hstjar/whale # entry system
          ]; # end of modules
        }; # end of whale

        # ========[^^ paste new config ^^]
      }; # end of configurations
    }; # end of outputs

  # ======[INPUTS]
  inputs = {
    # =====[core parts]
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-25D11.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs"; # locks version to the nixpkgs to reduce duplicate data
    }; # End of homemanager

    # =====[addons]
    wall-jar = {
      url = "github:y-jar/wall-jar"; # [wallpapers i collected]
      flake = false;
    }; # end of wall-jar
    # [nix defined neovim config]
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # end of nvf
  }; # end of inputs
}
