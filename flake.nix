# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
{
  # =-=-=-=-=-=-=-=[Scroll down to !!Hosts!!]
  description = "My Nix within a Jar";

  # =-=-=-=[binary caches / substituters]
  nixConfig = {
    extra-substituters = [
      "https://bazinga.cachix.org" # whisper's cache [preprocessor]
      "https://onelock.cachix.org"
    ];
    extra-trusted-public-keys = [
      "bazinga.cachix.org-1:WI9TV6l0gBVhcfY7OQM5zWqYmESIarKME0fjVN6yDYU="
      "onelock.cachix.org-1:Wyy9XrWqFKcPxkZXQg5yZXtsbKTbkaga44UWRJfgqEg="
    ];
  };
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
      # =-=-=[Systems that will be x86_64-linux] [uses hjem instead of home-manager]
      mkHjemJar = hostName: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          hostnm = hostName;
        }; # end of special args
        modules = [
          ./modjar/sysbin # Base system core entry
          ./modjar/hjemkey.nix # Hjem entry (alternative to home-manager)
          ./hstjar/${hostName} # Host-specific directory entry
        ]; # end of modules
      }; # end of mkHjemJar
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

        # [Dont change the line below]
        # ===[INSTALLER: append new hosts on the line below]===
        loom = mkJar "loom"; # silly pc
        calender = mkJar "calender"; # main pc
        yilyonix = mkJar "yilyonix"; # test bench [Might need to FIX]
        ziiemar = mkJar "ziiemar"; # personal laptop
        candle = mkJar "candle"; # gaming mini build
        whale = mkJar "whale"; # Server system
        vmjar = mkJar "vmjar"; # Virtual config

        # ========[hjem hosts (alternative to home-manager)] [Not fully implemented and toying with it]

        # ========[for non x86 systems..] [WIP]
        # TEMPLATE  = urnJar { hostName = "TEMPLATE"; arch = "aarch64-linux"; };

        # ========[ISO / recovery]
        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ({ pkgs, lib, ... }: {
              environment.systemPackages = with pkgs; [
                git vim nh fastfetch neovim
                gum fzf
                (pkgs.writeShellScriptBin "jarhelp" (builtins.readFile ./resjar/nixbin/jarhelp))
                (pkgs.writeShellScriptBin "installjar" (builtins.readFile ./resjar/nixbin/install.sh))
              ];
              networking.hostName = "recovery";
              services.openssh.enable = true;
              boot.zfs.forceImportRoot = false; # recommended; silence zfs warning
              users.users.root.initialHashedPassword = lib.mkForce null; # silence pw warning; "nixos" still wins
              users.users.root.initialPassword = "nixos";
              system.stateVersion = "26.05";
            })
          ]; # End of modules
        }; # End of iso
      }; # end of nixosConfigurations

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt; # nix fmt
      packages.x86_64-linux.iso = self.nixosConfigurations.iso.config.system.build.isoImage; # nix build .#iso
    }; # end of nixosConfigurations
    # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=[INPUTS]=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  inputs = {
    # [nixpkgs]
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
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
    # [hjem] alternative to home-manager [https://github.com/feel-co/hjem]
    hjem.url = "github:feel-co/hjem";
  }; # end of inputs
}

# Go back Up!
