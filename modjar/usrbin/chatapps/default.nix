# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Discord client (home-level enable).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  ...
}:
let
  cfg = config.usrSettings.chatApps;
in
{
  options = {
    usrSettings = {
      chatApps = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable chat apps";
        }; # end of usrSettings.chatApps.enable
        discord.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Discord (~300MiB)";
        }; # end of usrSettings.chatApps.discord.enable
        halloy.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Halloy (~?MiB)";
        }; # end of usrSettings.chatApps.halloy.enable
      }; # end of usrSettings.chatApps
    }; # end of usrSettings
  }; # end of options

  config = lib.mkIf cfg.enable {
    programs.discord = {
      enable = cfg.discord.enable;
    }; # end of programs.discord
    programs.halloy = {
      enable = cfg.halloy.enable;
    }; # end of programs.halloy
  }; # end of config
}
