{ config, lib, ... }:

{
  options = {
    sysSettings = {
      users = lib.mkOption {
        description = "List of desktop users to create on the system";
        type = lib.types.listOf lib.types.str;
      };
      adminUsers = lib.mkOption {
        description = "List of desktop users to grant admin (sudo) access on the system";
        type = lib.types.listOf lib.types.str;
      };
    };
  };
  config = {
    users.users = builtins.listToAttrs (
      map (user: {
        name = user;
        value = {
          isNormalUser = true;
          extraGroups = [
            "networkmanager" # network manager access
            "input" # input access for serial devices
            "dialout" # dialout access for serial devices
            "video" # video access
            "render" # render access
          ]
          # if user is in adminUsers, grant wheel and libvirtd access
          ++ (lib.optionals (lib.any (x: x == user) config.sysSettings.adminUsers) [
            "wheel" # wheel access [sudo]
            "libvirtd" # virt manager access
            "kvm" # kvm access
          ]);
          createHome = true;
        };
      }) config.sysSettings.users
    );

    home-manager.users = builtins.listToAttrs (
      map (user: {
        name = user;
        value = {
          home.username = user;
          home.homeDirectory = "/home/" + user;
        };
      }) config.sysSettings.users
    );
  };
}
