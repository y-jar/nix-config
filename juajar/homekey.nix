# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: home-manager entry: imports HM + liijar hm entry + host user.nix, sets specialArgs.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[homekey.nix] =-=-=
# Home Manager entry point. Sets up HM for the main user.
#
# What goes here:
#   - HM module imports
#   - Global HM settings (pkgs, backups)
#   - extraSpecialArgs (feature flags)
#   - Per-user config loading (usrset options + host sheet + liijar hm entry)
#
# What goes in hstjar/<host>/user.nix:
#   - Per-host toggle switches (usrset.*) — shared with the hjem backend
#
# What goes in juajar/liijar/:
#   - The actual app modules. Every liijar/<app>/hm.nix is auto-imported by
#     juajar/liijar/hm.nix (below). shared.nix holds the single-sourced
#     package lists / generated files; hjem.nix is the hjem twin.
#   - liijar/options.nix declares the usrset sheet (shared backend-agnostic).
# =-=-=[end homekey.nix] =-=-=

{
  config,
  lib,
  inputs,
  hostnm,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nvf.nixosModules.default # provides programs.nvf at system level (matches hjemkey)
  ];

  config = {
    # [global home-manager settings]
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";

      # [feature flags for HM modules]
      extraSpecialArgs = {
        inherit inputs;
        inherit hostnm;
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
    };

    # [main user config]
    # Only the mainUser gets home-manager (liijar apps + host-specific toggles).
    # Guest users get a Unix account via users/default.nix but no HM config.
    home-manager.users.${config.sysset.mainUser} = {
      home.username = config.sysset.mainUser;
      home.homeDirectory = "/home/${config.sysset.mainUser}";
      imports = [
        ../juajar/liijar/options.nix # shared usrset option declarations
        (
          # home-manager stateVersion comes from the shared host sheet
          # (usrset.stateVersion) so both backends read one file.
          { config, ... }: {
            home.stateVersion = config.usrset.stateVersion;
          }
        )
        ../hstjar/${hostnm}/user.nix # host toggles (usrset sheet)
        ../juajar/liijar/hm.nix # liijar: home-manager backend apps
      ];
    };
  };
}
