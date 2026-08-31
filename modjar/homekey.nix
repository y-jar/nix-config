# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: home-manager entry: imports HM + host home.nix + shared usrbin, sets specialArgs.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[homekey.nix] =-=-=
# Home Manager entry point. Sets up HM for all users.
# Imports the host-specific home.nix and shared usrbin
# modules for each user defined in sysSettings.users.
#
# What goes here:
#   - HM module imports
#   - Global HM settings (pkgs, backups)
#   - extraSpecialArgs (feature flags)
#   - Per-user config loading
#
# What goes in hstjar/<host>/home.nix:
#   - Per-host toggle switches (usrSettings.*)
#
# What goes in modjar/usrbin/:
#   - The actual module implementations
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
          (config.sysSettings.niri.enable or false)
          || (config.sysSettings.hyprland.enable or false)
          || (config.sysSettings.gnome.enable or false)
          || (config.sysSettings.cinnamon.enable or false)
          || (config.sysSettings.cosmic.enable or false);
        gnomeEnable = config.sysSettings.gnome.enable or false;
        hyprlandEnable = config.sysSettings.hyprland.enable or false;
        niriEnable = config.sysSettings.niri.enable or false;
        aiEnable = config.sysSettings.ai.enable or false;
        cosmicEnable = config.sysSettings.cosmic.enable or false;
      };
    };

    # [main user config]
    # Only the mainUser gets home-manager (shared usrbin + host-specific toggles).
    # Guest users get a Unix account via users/default.nix but no HM config.
    home-manager.users.${config.sysSettings.mainUser} = {
      home.username = config.sysSettings.mainUser;
      home.homeDirectory = "/home/${config.sysSettings.mainUser}";
      imports = [
        ../hstjar/${hostnm}/home.nix # host toggles
        ../modjar/usrbin # shared modules
      ];
    };
  };
}
