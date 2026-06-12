{
  inputs,
  hostnm,
  config,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager # home-manager module
    ./system.nix # system configuration
    ./hardware-configuration.nix # hardware configuration
    ./boot.nix # sets boot settings
  ];

  # config for home-manager and user entry and user system settings
  config = {
    # pass important args
    home-manager = {
      useGlobalPkgs = true; # use global pkgs instead of user pkgs
      useUserPackages = true; # use user pkgs instead of global pkgs
      backupFileExtension = "backup"; # file extension for backups

      # args passed to home-manager
      extraSpecialArgs = {
        inherit inputs;
        inherit hostnm;
        gnomeEnable = config.sysSettings.gnome.enable;
        hyprlandEnable = config.sysSettings.hyprland.enable;
        niriEnable = config.sysSettings.niri.enable;
      }; # end of home-manager extraSpecialArgs
    }; # end of home-manager base config

    home-manager.users = builtins.listToAttrs (
      map (user: {
        name = user;
        value = {
          imports = [
            ./user.nix # loads user information settings
            ../../modjar/usrbin # knowing user settings, loads user system configuration
          ];
        };
      }) config.sysSettings.users
    ); # end of home-manager users
  }; # end of config
}
