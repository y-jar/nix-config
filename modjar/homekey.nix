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
        hyprlandEnable = config.sysSettings.hyprland.enable;
        niriEnable = config.sysSettings.niri.enable;
        aiEnable = config.sysSettings.ai.enable;
        komgaEnable = config.sysSettings.server.komga.enable or false;
      };
    };

    # [per-user config]
    # for each user in sysSettings.users, load:
    #   1. host-specific home.nix (toggles)
    #   2. shared usrbin modules (implementations)
    home-manager.users = builtins.listToAttrs (
      map (user: {
        name = user;
        value = {
          imports = [
            ../hstjar/${hostnm}/home.nix   # host toggles
            ../modjar/usrbin                # shared modules
          ];
        };
      }) config.sysSettings.users
    );
  };
}
