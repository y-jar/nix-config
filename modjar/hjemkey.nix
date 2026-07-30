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
              ${lib.optionalString (config.hjemDotfiles.dirSetup != null) config.hjemDotfiles.dirSetup}
              source ${config.hjem.users.${config.sysSettings.mainUser}.environment.loadEnv}
            '';
          };
        }
        # [shell dotfiles]
        // lib.optionalAttrs (config.hjemDotfiles.zshrc != null) {
          ".zshrc".source = config.hjemDotfiles.zshrc;
          ".fzfrc".source = config.hjemDotfiles.fzfrc;
        }
        # [git config]
        // lib.optionalAttrs (config.hjemDotfiles.gitconfig != null) {
          ".gitconfig".source = config.hjemDotfiles.gitconfig;
        }
        # [yazi config]
        // lib.optionalAttrs (config.hjemDotfiles.yaziToml != null) {
          ".config/yazi/yazi.toml".source = config.hjemDotfiles.yaziToml;
          ".config/yazi/keymap.toml".source = config.hjemDotfiles.yaziKeymap;
          ".config/yazi/theme.toml".source = config.hjemDotfiles.yaziTheme;
        }
        # [media config]
        // lib.optionalAttrs (config.hjemDotfiles.mpvConf != null) {
          ".config/mpv/mpv.conf".source = config.hjemDotfiles.mpvConf;
        }
        // lib.optionalAttrs (config.hjemDotfiles.mimeApps != null) {
          ".config/mimeapps.list".source = config.hjemDotfiles.mimeApps;
        }
        # [niri config]
        // lib.optionalAttrs (config.hjemDotfiles.niriFiles != null) {
          ".config/niri/config.kdl".source = config.hjemDotfiles.niriFiles.config;
          ".config/niri/base.kdl".source = config.hjemDotfiles.niriFiles.base;
          ".config/niri/bindings.kdl".source = config.hjemDotfiles.niriFiles.bindings;
          ".config/niri/rules.kdl".source = config.hjemDotfiles.niriFiles.rules;
          ".config/niri/startups.kdl".source = config.hjemDotfiles.niriFiles.startups;
          ".config/niri/host-inputs.kdl".source = config.hjemDotfiles.niriFiles.hostInputs;
        }
        # [resource symlinks]
        // lib.optionalAttrs (config.hjemDotfiles.resYoink != null) (
          lib.optionalAttrs (config.hjemDotfiles.resYoink ? wallpapers) {
            "resjar/wall-jar".source = config.hjemDotfiles.resYoink.wallpapers;
          }
          // lib.optionalAttrs (config.hjemDotfiles.resYoink ? icons) {
            "resjar/icon-jar".source = config.hjemDotfiles.resYoink.icons;
          }
          // lib.optionalAttrs (config.hjemDotfiles.resYoink ? profilePictures) {
            "resjar/pfp-jar".source = config.hjemDotfiles.resYoink.profilePictures;
          }
        ); # end of resource symlinks
      };
    }; # end of hjem

    # [feature flags for hjmbin modules]
    hjem.specialArgs = {
      inherit hostnm;
      inherit inputs;
      gnomeEnable = config.sysSettings.gnome.enable or false;
      hyprlandEnable = config.sysSettings.hyprland.enable;
      niriEnable = config.sysSettings.niri.enable;
      aiEnable = config.sysSettings.ai.enable;
      cosmicEnable = config.sysSettings.cosmic.enable;
    };
  };
}
