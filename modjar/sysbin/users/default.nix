{ config, lib, ... }:

{
  # ==========================[User-Options]============================
  # declares the list of users using the sysSettings.users and sysSettings.adminUsers options.
  #-this declaration references the spot in /hstjar/HOST/system.nix for where the users are defined.
  # -users: list of desktop users to create on the system
  # -adminUsers: list of users to grant admin (sudo) access on the system
  options = {
    sysSettings = {
      users = lib.mkOption {
        description = "List of desktop users to create on the system";
        type = lib.types.listOf lib.types.str;
      };
      adminUsers = lib.mkOption {
        description = "List of desktop users to grant admin (sudo) access on the system";
        type = lib.types.listOf lib.types.str;
      }; # end of adminUsers
    }; # end of sysSettings
  }; # end of options

  # creates a nixos user entry, for every user in sysSettings.users.
  # each user within the option adminUsers is granted wheel[sudo] and virualization access.
  config = {
    users.users = builtins.listToAttrs (
      map (user: {
        name = user;
        value = {
          isNormalUser = true; # makes them super kool and epic
          # add user to extraGroups
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
          ]); # end of extraGroups
          createHome = true; # May be redundant if host default.nix already sets these via imports
        };
      }) config.sysSettings.users
    ); # end of users.users

    # Sets home.username and home.homeDirectory for each user in home-manager.
    home-manager.users = builtins.listToAttrs (
      map (user: {
        name = user;
        value = {
          home.username = user;
          home.homeDirectory = "/home/" + user;
        };
      }) config.sysSettings.users
    ); # end of home-manager.users
  };
}
