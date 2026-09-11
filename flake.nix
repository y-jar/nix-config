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
      # =-=-=[Systems that will be x86_64-linux] [hjem is THE user backend]
      mkJar =
        hostName:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs self;
            hostnm = hostName; # Dynamically sets hostnm for networking/Zsh
          }; # end of special args
          modules = [
            ./juajar/sysjar # Base system core entry
            ./juajar/hjemkey.nix # Hjem entry (user backend)
            ./hstjar/${hostName} # Host-specific directory entry [what happens here can depend on each system]
          ]; # end of modules
        }; # end of mkJar
      # =-=-=[Systems that will be non x86_64-linux] [WIP]
      urnJar =
        { hostName, arch }:
        nixpkgs.lib.nixosSystem {
          system = arch; # Dynamically sets the architecture
          specialArgs = {
            inherit inputs self;
            hostnm = hostName;
          }; # end of special args
          modules = [
            ./juajar/sysjar # Entry for The System
            ./hstjar/${hostName} # Entry for The host
          ]; # end of modules
        }; # end of urnJar
    in
    {
      # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=!!HOSTS!!=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      nixosConfigurations = {
        # [TEMPLATE] scaffold a new host from hstjar/0_TEMPLATE via the installer.
        # Append new hosts below using `mkJar "<hostname>"` (a matching
        # hstjar/<hostname>/ directory must exist).
        # TEMPLATE = mkJar "TEMPLATE";

        # Do not edit this comment below
        # ===[INSTALLER: append new hosts on the line below]===
        yilyonix = mkJar "yilyonix"; # test bench [Might need to FIX]
        ziiemar = mkJar "ziiemar"; # personal laptop
        candle = mkJar "candle"; # gaming mini build
        whale = mkJar "whale"; # Server system under loomjar (proxmox server)
        vmjar = mkJar "vmjar"; # Virtual config
        yil01 = mkJar "yil01"; # Thinkpad Laptop thats super cute
        petrichor = mkJar "petrichor"; # kwaytea's Pewta
        yil02 = mkJar "yil01"; # yil01 evaluated under the same sheet (live test twin)
        calender = mkJar "calender"; # main pc

        # ========[for non x86 systems..] [WIP]
        # TEMPLATE  = urnJar { hostName = "TEMPLATE"; arch = "aarch64-linux"; };

        # ========[ISO / recovery]
        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ({ pkgs, lib, ... }: {
              environment.systemPackages = with pkgs; [
                git
                vim
                nh
                fastfetch
                neovim
                gum
                fzf
                (pkgs.writeShellScriptBin "jarhelp" (builtins.readFile ./resjar/nixbin/jarhelp))
                (pkgs.writeShellScriptBin "installjar" (builtins.readFile ./resjar/nixbin/install.sh))
              ];
              networking.hostName = "recovery";
              services.openssh.enable = true;
              boot.zfs.forceImportRoot = false; # recommended; silence zfs/xfs? warning
              users.users.root.initialHashedPassword = lib.mkForce null; # silence pw warning; "nixos" still wins
              users.users.root.initialPassword = "nixos";
              system.stateVersion = "26.05";
            })
          ]; # End of modules
        }; # End of iso

        # ========[ISO / recovery - graphical GNOME]
        iso-gnome = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
            ({ pkgs, lib, ... }: {
              environment.systemPackages = with pkgs; [
                git
                vim
                nh
                fastfetch
                neovim
                gum
                fzf
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
        }; # End of iso-gnome
      }; # end of nixosConfigurations

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt; # nix fmt
      packages.x86_64-linux.iso = self.nixosConfigurations.iso.config.system.build.isoImage; # nix build .#iso
      packages.x86_64-linux.iso-gnome = self.nixosConfigurations.iso-gnome.config.system.build.isoImage; # nix build .#iso-gnome
      packages.x86_64-linux.rsakura = inputs.rsakura.packages.x86_64-linux.default; # nix shell ~/nix-config#rsakura
    }; # end of flake outputs
  # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=[INPUTS]=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  inputs = {
    # [nixpkgs]
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # [mangowm] wayland compositor (dwl-based) ships nixosModules.mango
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # end of mangowm

    # =====[ My addons]
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
    shelljar = {
      # [my quickshell island shell]
      url = "github:y-jar/shelljar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcskins-jar = {
      url = "github:y-jar/mcskins-jar";
      flake = false;
    };
    # =====[nix defined neovim config]
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # end of nvf
    rsakura.url = "github:preprocessor/rsakura"; # whisper's cool rust rewite fork
    # [cachyos kernel]
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    # [hjem] THE user backend (home-manager is gone) [https://github.com/feel-co/hjem]
    hjem.url = "github:feel-co/hjem";
  }; # end of inputs
}
