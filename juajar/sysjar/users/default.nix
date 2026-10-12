# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Define main/guest/admin users (accounts + groups + sanity assertions).
# -=-=-=-=-=-=-=-=-=-=-=
{ config, lib, ... }:

let
  cfg = config.sysset;

  # groups every user gets; only groups the host actually has (no dangling names)
  baseGroups = [
    "input"
    "dialout"
    "video"
    "render"
    "audio"
  ]
  ++ lib.optional cfg.networking.networkManager.enable "networkmanager";

  # admins: sudo + kvm; libvirtd exists only on a virt host
  adminGroups = [
    "wheel"
    "kvm"
  ]
  ++ lib.optional (cfg.virt.role == "host") "libvirtd";
in
{
  options = {
    sysset = {
      mainUser = lib.mkOption {
        description = "Primary desktop user (gets hjem + full config)";
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
    # [guards] typos here would otherwise surface as a missing home or a missing sudo
    assertions = [
      {
        assertion = builtins.elem cfg.mainUser cfg.users;
        message = "sysset.mainUser (${cfg.mainUser}) must also be listed in sysset.users.";
      }
      {
        assertion = lib.all (u: builtins.elem u cfg.users) cfg.adminUsers;
        message = "sysset.adminUsers has users missing from sysset.users: ${
          toString (lib.filter (u: !builtins.elem u cfg.users) cfg.adminUsers)
        }";
      }
      {
        assertion = lib.all (u: builtins.elem u cfg.users) (builtins.attrNames cfg.userDescriptions);
        message = "sysset.userDescriptions describes users missing from sysset.users: ${
          toString (lib.filter (u: !builtins.elem u cfg.users) (builtins.attrNames cfg.userDescriptions))
        }";
      }
    ];

    users.users = builtins.listToAttrs (
      map (user: {
        name = user;
        value = {
          isNormalUser = true;
          description = cfg.userDescriptions.${user} or user;
          extraGroups = baseGroups ++ lib.optionals (builtins.elem user cfg.adminUsers) adminGroups;
          createHome = true;
        };
      }) cfg.users
    );
  };
}
