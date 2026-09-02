# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Per-host autostart apps (which programs launch at compositor session start).
# -=-=-=-=-=-=-=-=-=-=-=
# Note: this only applies to Window Managers (niri / hyprland) via their spawn-at-startup /
# exec-once lines. It is NOT used by full desktop environments (GNOME/Cinnamon/...).
# -=-=-=-=-=-=-=-=-=-=-=
# Each host declares the apps it wants auto-started in hstjar/<host>/autostart.nix
# by setting `sysSettings.autostart.commands`. Left empty to start nothing.
# The heavy audio GUI tools (easyeffects/pavucontrol/qpwgraph) are intentionally
# NOT autostarted by default to keep idle RAM low; launch them on demand instead.
# -=-=-=-=-=-=-=-=-=-=-=
{ lib, ... }:

{
  options.sysSettings.autostart = {
    commands = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "voxtype" "i3status-rust" ];
      description = ''
        Programs to launch automatically when a Window Manager session starts.
        Each entry becomes a `spawn-at-startup "<cmd>"` (niri) / `exec-once` (hyprland) line.
      '';
    }; # end of commands
  }; # end of options
}