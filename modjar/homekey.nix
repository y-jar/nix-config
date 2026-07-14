{ config, lib, inputs, hostnm, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";

      extraSpecialArgs = {
        inherit inputs;
        inherit hostnm;
        gnomeEnable = config.sysSettings.gnome.enable or false;
        hyprlandEnable = config.sysSettings.hyprland.enable;
        niriEnable = config.sysSettings.niri.enable;
        aiEnable = config.sysSettings.ai.enable;
      };
    };

    home-manager.users = builtins.listToAttrs (
      map (user: {
        name = user;
        value = {
          imports = [
            ./hstjar/${hostnm}/user.nix
            ./modjar/usrbin
          ];
        };
      }) config.sysSettings.users
    );
  };
}
