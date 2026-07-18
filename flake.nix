 #  _______
 # '   /      ___  .___
 #     |     /   ` /   \
 #     |    |    | |   '
 #  `--/    `.__/| /
# -=-=-=-=-=-=-=-=-=-=-=
{
  # =-=-=-=-=-=-=-=[Scroll down to !!Hosts!!]
  description = "My Nix within a Jar";
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
    # [nix-index-database] pre-built nix-index + comma wrapper [this did shit, no longer needed]
    # nix-index-database = {
    #   url = "github:nix-community/nix-index-database";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # }; # end of nix-index-database

    # =====[addons]
    wall-jar = {
      url = "github:y-jar/wall-jar"; # [wallpapers i collected]
      flake = false;
    }; # end of wall-jar
    icon-jar = {
      url = "github:y-jar/icon-jar"; # [icons i collected]
      flake = false;
    }; # end of icon-jar
    pfp-jar = {
      url = "github:y-jar/pfp-jar"; # [profile pictures i collected]
      flake = false;
    }; # end of pfp-jar
    # [nix defined neovim config]
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # end of nvf
    rsakura.url = "github:preprocessor/rsakura"; # whisper's cool rust rewite fork
    # [cachyos kernel]
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  }; # end of inputs
}

# Go back Up!
