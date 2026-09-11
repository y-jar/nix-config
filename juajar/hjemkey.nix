# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem entry: imports hjem/nvf + host user.nix + liijar hjem entry, sets specialArgs.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[hjemkey.nix] =-=-=
# Hjem entry point. Sets up Hjem (alternative to HM)
# for the main user. This file ONLY holds the overarching settings:
#
#   - Hjem + NixOS module imports
#   - Global hjem settings (clobberByDefault)
#   - extraModules loading (liijar options + liijar hjem entry + host user.nix)
#   - The .profile (dirSetup bootstrap + hjem environment loadEnv)
#   - specialArgs (feature flags for liijar hjem modules)
#   - The nvf bridge (usrset.editors.nvf -> sysset.nvf)
#
# What goes in hstjar/<host>/user.nix:
#   - Per-host toggle switches (usrset.*) — shared with the home-manager backend
#
# What goes in juajar/liijar/:
#   - The actual app modules. Every liijar/<app>/hjem.nix is auto-imported by
#     juajar/liijar/hjem.nix (below), along with the .profile dirSetup bus.
#     Modules are evaluated INSIDE the hjem user submodule, so they write
#     dotfiles directly:
#       files."~/.config/app/config".source = <generated>;
#       packages = [ ... ];
#     New app = drop a dir in liijar/<app>/ with an hm.nix and/or hjem.nix.
#     No central wiring needed.
#   - liijar/options.nix declares the usrset sheet (shared backend-agnostic).
# =-=-=[end hjemkey.nix] =-=-=

{
  config,
  lib,
  pkgs,
  inputs,
  hostnm,
  ...
}:

{
  imports = [
    inputs.hjem.nixosModules.default # hjem: manages user home dirs
    inputs.nvf.nixosModules.default # nvf: neovim config (NixOS module)
  ];

  config = {
    # [global hjem settings]
    hjem = {
      clobberByDefault = true;

      # [hjem modules]
      # liijar/hjem.nix auto-imports every liijar/<app>/hjem.nix + the
      # .profile dirSetup bus. liijar/options.nix declares the shared usrset
      # sheet; the host user.nix (same file the home-manager backend reads)
      # sets the per-host toggles.
      extraModules = [
        ../juajar/liijar/options.nix
        ../juajar/liijar/hjem.nix
        ../hstjar/${hostnm}/user.nix
      ];

      # [main user dotfiles]
      # Only the mainUser gets hjem dotfile management.
      # Guest users get a Unix account via users/default.nix but no hjem config.
      users.${config.sysset.mainUser} = {
        enable = true;
        directory = "/home/${config.sysset.mainUser}";

        # [base profile]
        # dirSetup lines (mkdir / systemctl --user enable) merged from liijar
        # modules, then the hjem environment (packages, sessionVariables).
        files.".profile" = {
          executable = true;
          text = ''
            ${
              let
                dirSetup = config.hjem.users.${config.sysset.mainUser}.hjemDotfiles.dirSetup;
              in
              lib.optionalString (dirSetup != null) dirSetup
            }
            source ${config.hjem.users.${config.sysset.mainUser}.environment.loadEnv}
          '';
        };
      };
    }; # end of hjem

    # [feature flags for liijar hjem modules]
    hjem.specialArgs = {
      inherit hostnm;
      inherit inputs;
      hasDesktop =
        (config.sysset.niri.enable or false)
        || (config.sysset.hyprland.enable or false)
        || (config.sysset.mango.enable or false)
        || (config.sysset.gnome.enable or false)
        || (config.sysset.cinnamon.enable or false)
        || (config.sysset.cosmic.enable or false);
      gnomeEnable = config.sysset.gnome.enable or false;
      hyprlandEnable = config.sysset.hyprland.enable or false;
      niriEnable = config.sysset.niri.enable or false;
      mangoEnable = config.sysset.mango.enable or false;
      aiEnable = config.sysset.ai.enable or false;
      cosmicEnable = config.sysset.cosmic.enable or false;
      webapps = config.sysset.webapps; # browser-apps-as-desktop-apps (webapps.nix)
    };

    # [nvf bridge]
    # usrset.editors.nvf.enable lives inside the hjem user submodule;
    # surface it to the system-level nvf gate (juajar/sysjar/nvf) so the
    # host's user.nix toggle sheet stays the source of truth.
    sysset.nvf.enable = config.hjem.users.${config.sysset.mainUser}.usrset.editors.nvf.enable or false;
  };
}
