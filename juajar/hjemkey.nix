# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem entry: imports hjem/nvf + liijar + host user.nix, sets specialArgs.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[hjemkey.nix] =-=-=
# Hjem entry point. Hjem is THE user backend (home-manager is gone). This
# file ONLY holds the overarching settings:
#
#   - Hjem + NixOS module imports
#   - Global hjem settings (clobberByDefault)
#   - extraModules loading (liijar auto-import + host user.nix)
#   - The .profile (dirSetup bootstrap + hjem environment loadEnv)
#   - specialArgs (host flags for liijar modules)
#   (the sysset <-> usrset bridges live in ./bridge.nix)
#
# What goes in hstjar/<host>/user.nix:
#   - Per-host toggle switches (usrset.*)
#
# What goes in juajar/liijar/:
#   - The app modules. liijar/default.nix auto-imports every app dir's
#     default.nix (plus options.nix + profile-bus.nix at the root). Modules
#     are evaluated INSIDE the hjem user submodule, so they write dotfiles
#     directly:
#       files."~/.config/app/config".source = <generated>;
#       packages = [ ... ];
#     New app = copy liijar/cowsay (the commented reference example).
#     No central wiring needed.
# =-=-=[end hjemkey.nix] =-=-=

{
  config,
  lib,
  inputs,
  hostnm,
  hostDir,
  ...
}:

{
  imports = [
    inputs.hjem.nixosModules.default # hjem: manages user home dirs
    inputs.nvf.nixosModules.default # nvf: neovim config (NixOS module)
    ./bridge.nix # sysset <-> usrset glue (the only place they meet)
  ];

  config = {
    # [global hjem settings]
    hjem = {
      clobberByDefault = true;

      # [hjem modules]
      # liijar/ auto-imports every app + the usrset option declarations;
      # the host user.nix sets the per-host toggles.
      extraModules = [
        ./liijar
        (hostDir + "/user.nix")
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

    # [feature flags for liijar modules]
    hjem.specialArgs = {
      inherit hostnm;
      inherit inputs;
      hyprlandEnable = config.sysset.hyprland.enable or false;
      niriEnable = config.sysset.niri.enable or false;
      mangoEnable = config.sysset.mango.enable or false;
      aiEnable = config.sysset.ai.enable or false;
    };
  };
}
