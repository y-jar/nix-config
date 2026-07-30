{ config, lib, ... }:

let
  cfg = config.sysSettings;
in
{
  options = {
    sysSettings = {
      mainUser = lib.mkOption {
        description = "Primary desktop user (gets home-manager + full config)";
        type = lib.types.str;
      };
      users = lib.mkOption {
        description = "List of all desktop users (main + guests) to create on the system";
        type = lib.types.listOf lib.types.str;
      };
      adminUsers = lib.mkOption {
        description = "List of users to grant admin (sudo) access on the system";
        type = lib.types.listOf lib.types.str;
      };
      userDescriptions = lib.mkOption {
        description = "Attrset mapping usernames to full names for users.users.*.description";
        type = lib.types.attrsOf lib.types.str;
        default = { };
      };
    };
  };

  config = {
    users.users = builtins.listToAttrs (
      map (user: {
        name = user;
        value = {
          isNormalUser = true;
          description = cfg.userDescriptions.${user} or user;
          extraGroups = [
            "networkmanager"
            "input"
            "dialout"
            "video"
            "render"
            "audio"
            "realtime"
          ]
          ++ (lib.optionals (lib.any (x: x == user) cfg.adminUsers) [
            "wheel"
            "libvirtd"
            "kvm"
          ]);
          createHome = true;
        };
      }) cfg.users
    );

    home-manager.users = {
      ${cfg.mainUser} = {
        home.username = cfg.mainUser;
        home.homeDirectory = "/home/${cfg.mainUser}";
      };
    };
  };
}
