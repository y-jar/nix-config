{
  inputs,
  hostnm,
  config,
  ...
}:

{
  imports = [
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

      # args passed to home-manager
      extraSpecialArgs = {
        inherit inputs;
        inherit hostnm;
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
