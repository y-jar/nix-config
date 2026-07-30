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

{ config, lib, inputs, hostnm, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
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
        gnomeEnable = config.sysSettings.gnome.enable or false;
        hyprlandEnable = config.sysSettings.hyprland.enable or false;
        niriEnable = config.sysSettings.niri.enable or false;
        aiEnable = config.sysSettings.ai.enable or false;
        komgaEnable = config.sysSettings.server.komga.enable or false;
        cosmicEnable = config.sysSettings.cosmic.enable or false;
      };
    };

    # [main user config]
    # Only the mainUser gets home-manager (shared usrbin + host-specific toggles).
    # Guest users get a Unix account via users/default.nix but no HM config.
    home-manager.users.${config.sysSettings.mainUser} = {
      imports = [
        ../hstjar/${hostnm}/home.nix   # host toggles
        ../modjar/usrbin                # shared modules
      ];
    };
  };
}
