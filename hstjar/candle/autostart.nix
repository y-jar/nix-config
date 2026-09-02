# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host candle: apps to autostart at Window Manager session start.
# -=-=-=-=-=-=-=-=-=-=-=
# Note (IMPORTANT): this only applies to Window Managers (niri / hyprland).
# Full desktop environments (GNOME/Cinnamon/...) do NOT read this.
# -=-=-=-=-=-=-=-=-=-=-=
# List programs to run on startup, e.g. `commands = [ "voxtype" "pavucontrol" ];`
# Empty = start nothing. Heavy GUI tools stay opt-in to keep idle RAM low.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  ...
}: {
  config.sysSettings.autostart.commands = [
    # put programs to autostart here
  ];
}
