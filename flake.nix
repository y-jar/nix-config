 #  _______
 # '   /      ___  .___
 #     |     /   ` /   \
 #     |    |    | |   '
 #  `--/    `.__/| /
# -=-=-=-=-=-=-=-=-=-=-=
{
  # =-=-=-=-=-=-=-=[Scroll down to !!Hosts!!]
  description = "My Nix within a Jar";
  # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=[INPUTS]=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  inputs = {
    # [nixpkgs]
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # [home-manager]
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
  # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=[OUTPUTS]=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      # =-=-=[Systems that will be x86_64-linux] [also uses home-manager]
      mkJar = hostName: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          hostnm = hostName; # Dynamically sets hostnm for networking/Zsh
        }; # end of special args
        modules = [
          ./modjar/sysbin # Base system core entry
          ./modjar/homekey.nix # Home-manager entry
          ./hstjar/${hostName} # Host-specific directory entry [what happens here can depend on each system]
        ]; # end of modules
      }; # end of mkJar

      # =-=-=[Systems that will be non x86_64-linux] [WIP]
      urnJar = { hostName, arch }: nixpkgs.lib.nixosSystem {
        system = arch; # Dynamically sets the architecture
        specialArgs = {
          inherit inputs;
          hostnm = hostName;
        }; # end of special args
        modules = [
          ./modjar/sysbin # Entry for The System
          ./hstjar/${hostName} # Entry for The host
        ]; # end of modules
      }; # end of uurnJar
      # =-=-=[Systems that will be ...] [WIP]
      mkWiyJar = { hostName, arch }: nixpkgs.lib.nixosSystem {
        system = arch; # Dynamically sets the architecture
        specialArgs = {
          inherit inputs;
          hostnm = hostName;
        }; # end of special args
        modules = [
          ./modjar/sysbin # Entry for The System
          ./hstjar/${hostName} # Entry for The host
        ]; # end of modules
      }; # end of uurnJar
    in
    {
      # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=!!HOSTS!!=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      nixosConfigurations = {
        # ========[base 糸s]
        # TEMPLATE = mkJar "TEMPLATE";

        loom = mkJar "loom"; # silly pc
        calender = mkJar "calender"; # main pc
        yilyonix = mkJar "yilyonix"; # test bench [Might need to FIX]
        ziiemar = mkJar "ziiemar"; # personal laptop
        candle = mkJar "candle"; # gaming mini build
        whale = mkJar "whale"; # Server system
        vmjar = mkJar "vmjar"; # Virtual config

        # ========[for non x86 systems..] [WIP]
        # TEMPLATE  = urnJar { hostName = "TEMPLATE"; arch = "aarch64-linux"; };
      }; # end of nixosConfigurations
    }; # end of nixosConfigurations
}

# Go back Up!
