# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
{
  # =-=-=-=-=-=-=-=[Scroll down to !!Hosts!!]
  description = "My Nix within a Jar";

  # =-=-=-=[binary caches / substituters]
  # not trusting
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
            hostDir = ./hstjar/${hostName}; # this host's dir (user.nix, net.nix, ...)
            fleetDir = ./hstjar; # every host dir, for fleet-wide data (net.nix phone book)
          }; # end of special args
          modules = [
            ./juajar/sysjar # Base system core entry
            ./juajar/WMs # Window managers: NixOS half (the hjem half rides in hjemkey)
            ./juajar/hjemkey.nix # Hjem entry (user backend)
            ./hstjar/${hostName} # Host-specific directory entry [what happens here can depend on each system]
          ]; # end of modules
        }; # end of mkJar

      # =-=-=[Recovery ISO] shared body: installer tools + jarhelp/nixinstall
      mkIso =
        base:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/${base}"
            (
              { pkgs, lib, ... }:
              {
                environment.systemPackages = [
                  pkgs.git
                  pkgs.vim
                  pkgs.nh
                  pkgs.fastfetch
                  pkgs.neovim
                  pkgs.gum
                  pkgs.fzf
                  (pkgs.writeShellScriptBin "jarhelp" (builtins.readFile ./resjar/nixbin/jarhelp))
                  (pkgs.writeShellScriptBin "nixinstall" (builtins.readFile ./resjar/nixbin/nixinstall))
                ];
                networking.hostName = "recovery";
                services.openssh.enable = true;
                boot.zfs.forceImportRoot = false; # recommended; silence zfs warning
                users.users.root.initialHashedPassword = lib.mkForce null; # silence pw warning; "nixos" still wins
                users.users.root.initialPassword = "nixos";
                system.stateVersion = "26.05";
              }
            )
          ]; # End of modules
        }; # end of mkIso
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
        calender = mkJar "calender"; # main pc
        fearra = mkJar "fearra"; # personal theater pc

        # ========[ISO / recovery]
        iso = mkIso "installation-cd-minimal.nix"; # nix build .#iso

        # ========[ISO / recovery - graphical GNOME]
        iso-gnome = mkIso "installation-cd-graphical-gnome.nix"; # nix build .#iso-gnome
      }; # end of nixosConfigurations

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt; # nix fmt
      packages = {
        x86_64-linux = {
          iso = self.nixosConfigurations.iso.config.system.build.isoImage; # nix build .#iso
          iso-gnome = self.nixosConfigurations.iso-gnome.config.system.build.isoImage; # nix build .#iso-gnome
          rsakura = inputs.rsakura.packages.x86_64-linux.default; # nix shell ~/nix-config#rsakura
          nueon = inputs.nueon.packages.x86_64-linux.default; # nix build .#nueon
          nueon-bin = inputs.nueon.packages.x86_64-linux.nueon-bin; # nix build .#nueon-bin
        };
      };
    }; # end of flake outputs
  # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=[INPUTS]=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  inputs = {
    # [nixpkgs]
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # [nixpkgs-unstable] pulls a newer opencode than stable ships (1.19 vs 1.15)
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";

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
      url = "github:y-jar/icon-jar"; # [icons + profile pictures i collected]
    }; # end of icon-jar
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
    # [tuneshon] my lightweight NixOS update tool (nix flake + gui/cli)
    tuneshon = {
      url = "github:y-jar/tuneshon";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # end of tuneshon
    # [nueon] my conlang editor/creation app (Tauri: Rust + Svelte)
    # nixpkgs.follows so the runtime WebKit/GTK closure is shared with the system
    # (no duplicate). The binary path uses the prebuilt release .deb.
    nueon = {
      url = "github:y-jar/nueon";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # end of nueon
    # [gruvbox-dark-yazi] community gruvbox flavor for yazi (theme.toml = [flavor])
    gruvbox-dark-yazi = {
      url = "github:bennyyip/gruvbox-dark.yazi";
      flake = false;
    }; # end of gruvbox-dark-yazi
    # [cachyos kernel]
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    # [hjem] THE user backend (home-manager is gone) [https://github.com/feel-co/hjem]
    hjem.url = "github:feel-co/hjem";

    # [authentik-nix] self-hosted SSO IdP (for outline + future apps)
    # NOTE: no nixpkgs.follows on purpose: upstream pins its own nixpkgs because
    # the python deps (poetry2nix) break against foreign nixpkgs versions.
    authentik-nix = {
      url = "github:nix-community/authentik-nix";
    }; # end of authentik-nix
  }; # end of inputs
}
