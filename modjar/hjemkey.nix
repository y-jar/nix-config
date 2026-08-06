# =-=-=[hjemkey.nix] =-=-=
# Hjem entry point. Sets up Hjem (alternative to HM)
# for all users. Hjem manages dotfiles and user-level
# configuration by writing files into home directories.
#
# What goes here:
#   - Hjem + NixOS module imports
#   - Global hjem settings (clobberByDefault)
#   - extraModules loading (hjmbin + host hjem.nix)
#   - Per-user dotfile writing (consuming hjemDotfiles)
#   - specialArgs (feature flags for hjmbin modules)
#
# What goes in hstjar/<host>/hjem.nix:
#   - Per-host toggle switches (hjmSettings.*)
#
# What goes in modjar/hjmbin/:
#   - The actual module implementations
#   - Options declarations (options.nix)
#   - Dotfile generation (generates derivations)
#   - Exposes generated files via hjemDotfiles
#
# How dotfiles flow:
#   hjmbin modules --> hjemDotfiles options --> hjemkey.nix --> ~/.config/...
# =-=-=[end hjemkey.nix] =-=-=

{ config, lib, pkgs, inputs, hostnm, ... }:

let
  # hjmbin modules expose generated dotfiles via the hjemDotfiles options,
  # which live inside the hjem user submodule. Read them from there.
  hjemDotfiles = config.hjem.users.${config.sysSettings.mainUser}.hjemDotfiles;
in
{
  imports = [
    inputs.hjem.nixosModules.default    # hjem: manages user home dirs
    inputs.nvf.nixosModules.default     # nvf: neovim config (NixOS module)
  ];

  config = {
    # [global hjem settings]
    hjem = {
      clobberByDefault = true;

      # [hjem modules]
      # hjmbin/ auto-imports all .nix files + subdirs.
      # The host hjem.nix contains per-host hjmSettings toggles.
      extraModules = [
        ../modjar/hjmbin
        ../hstjar/${hostnm}/hjem.nix
      ];

      # [main user dotfiles]
      # Only the mainUser gets hjem dotfile management.
      # Guest users get a Unix account via users/default.nix but no hjem config.
      users.${config.sysSettings.mainUser} = {
        enable = true;
        directory = "/home/${config.sysSettings.mainUser}";

        # [base profile]
        files = {
          ".profile" = {
            executable = true;
            text = ''
              ${lib.optionalString (hjemDotfiles.dirSetup != null) hjemDotfiles.dirSetup}
              source ${config.hjem.users.${config.sysSettings.mainUser}.environment.loadEnv}
            '';
          };
        }
        # [shell dotfiles]
        // lib.optionalAttrs (hjemDotfiles.zshrc != null) {
          ".zshrc".source = hjemDotfiles.zshrc;
          ".fzfrc".source = hjemDotfiles.fzfrc;
        }
        # [git config]
        // lib.optionalAttrs (hjemDotfiles.gitconfig != null) {
          ".gitconfig".source = hjemDotfiles.gitconfig;
        }
        # [inputmethods config]
        // lib.optionalAttrs (hjemDotfiles.mozcConfig1Db != null) {
          ".config/mozc/config1.db".source = hjemDotfiles.mozcConfig1Db;
        }
        // lib.optionalAttrs (hjemDotfiles.fcitx5Files != null) {
          ".config/fcitx5".source = hjemDotfiles.fcitx5Files;
        }
        # [yazi config]
        // lib.optionalAttrs (hjemDotfiles.yaziToml != null) {
          ".config/yazi/yazi.toml".source = hjemDotfiles.yaziToml;
          ".config/yazi/keymap.toml".source = hjemDotfiles.yaziKeymap;
          ".config/yazi/theme.toml".source = hjemDotfiles.yaziTheme;
        }
        # [media config]
        // lib.optionalAttrs (hjemDotfiles.mpvConf != null) {
          ".config/mpv/mpv.conf".source = hjemDotfiles.mpvConf;
        }
        // lib.optionalAttrs (hjemDotfiles.mimeApps != null) {
          ".config/mimeapps.list".source = hjemDotfiles.mimeApps;
        }
        # [niri config]
        // lib.optionalAttrs (hjemDotfiles.niriFiles != null) {
          ".config/niri/config.kdl".source = hjemDotfiles.niriFiles.config;
          ".config/niri/base.kdl".source = hjemDotfiles.niriFiles.base;
          ".config/niri/bindings.kdl".source = hjemDotfiles.niriFiles.bindings;
          ".config/niri/rules.kdl".source = hjemDotfiles.niriFiles.rules;
          ".config/niri/startups.kdl".source = hjemDotfiles.niriFiles.startups;
          ".config/niri/host-inputs.kdl".source = hjemDotfiles.niriFiles.hostInputs;
        }
        # [resource symlinks]
        // lib.optionalAttrs (hjemDotfiles.resYoink != null) (
          lib.optionalAttrs (hjemDotfiles.resYoink ? wallpapers) {
            "resjar/wall-jar".source = hjemDotfiles.resYoink.wallpapers;
          }
          // lib.optionalAttrs (hjemDotfiles.resYoink ? icons) {
            "resjar/icon-jar".source = hjemDotfiles.resYoink.icons;
          }
          // lib.optionalAttrs (hjemDotfiles.resYoink ? profilePictures) {
            "resjar/pfp-jar".source = hjemDotfiles.resYoink.profilePictures;
          }
        ); # end of resource symlinks
      };
    }; # end of hjem

    # [feature flags for hjmbin modules]
    hjem.specialArgs = {
      inherit hostnm;
      inherit inputs;
      gnomeEnable = config.sysSettings.gnome.enable or false;
      hyprlandEnable = config.sysSettings.hyprland.enable or false;
      niriEnable = config.sysSettings.niri.enable or false;
      aiEnable = config.sysSettings.ai.enable or false;
      cosmicEnable = config.sysSettings.cosmic.enable or false;
    };
  };
}
