# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Niri user config entry + host inputs.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  hostnm,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.niri;
  hostSpecificFile = ./host-inputs + "/${hostnm}.kdl"; # host-specific input
  targetKdlSource =
    if builtins.pathExists hostSpecificFile then hostSpecificFile else ./host-inputs/0-unknown.kdl;

  # Which desktop shell is running? Drives the spawn line + settings bind.
  # (Mod+D launcher is now always nwg-drawer, so it's no longer gated here.)
  shelljarEnabled = config.usrSettings.shelljar.enable or false;
  noctaliaEnabled = config.usrSettings.noctalia.enable or false;

  # exact settings bind line in the static file that gets swapped per shell
  sLine = "    Mod+S hotkey-overlay-title=\"Toggle Noctalia [S]ettings\" { spawn \"qs\" \"ipc\" \"-c\" \"noctalia-shell\" \"call\" \"settings\" \"toggle\"; }";

  shellBindS =
    if shelljarEnabled then
      "    Mod+S hotkey-overlay-title=\"Toggle [S]helljar Control Center\" { spawn-sh \"shjctl toggleControlCenter\"; }"
    else if noctaliaEnabled then
      sLine
    else
      "    // Mod+S: no desktop shell enabled";
in
{
  options = {
    usrSettings.niri.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Niri window manager";
    }; # end of usrSettings.niri.enable
  }; # end of options

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "niri/config.kdl".source = ./config.kdl; # base linker
      # [global]
      "niri/bindings.kdl".text = lib.replaceStrings [ sLine ] [ shellBindS ] (
        builtins.readFile ./bindings.kdl
      );
      "niri/base.kdl".source = ./base.kdl;
      "niri/rules.kdl".source = ./rules.kdl;
      "niri/startups.kdl".text =
        builtins.readFile ./startups.kdl
        + lib.optionalString (config.usrSettings.shelljar.enable or false) ''
          spawn-at-startup "shelljar"
          // desktop shell (quickshell island shell) spawned by Bar[shelljar]
        ''
        +
          lib.optionalString
            ((config.usrSettings.noctalia.enable or false) && !(config.usrSettings.shelljar.enable or false))
            ''
              spawn-at-startup "noctalia-shell"
              // desktop shell spawned by Bar[noctalia]
            '';
      # [channel pinning (jar-cap/mic-out) that only exists with the addon.]
      "niri/startups-audio.kdl".text =
        lib.optionalString (osConfig.sysSettings.audio.addon.enable or false)
          ''
            spawn-at-startup "qpwgraph"
            // Pin the jar-audio hub as default sink/source so "Desktop audio" streams
            // (discord, obs) always capture jar-cap.monitor = the full mix. Retries until
            // pipewire is up, so it survives reboots and sink re-plugs. Weird stuff
            spawn-sh-at-startup "until pactl info | grep -q 'Default Sink: jar-cap'; do pactl set-default-sink jar-cap; sleep 1; done"
            spawn-sh-at-startup "until pactl info | grep -q 'Default Source: mic-out'; do pactl set-default-source mic-out; sleep 1; done"
          '';
      # [host specific]
      "niri/host-inputs.kdl".source = targetKdlSource;
      # nwg-drawer theme (translucent, matches shell palette; shared in usrbin/)
      "nwg-drawer/drawer.css".source = ../nwg-drawer.css;
      # Pin waypaper to the awww backend and to the wallpaper folder.
      "waypaper/config.ini".text = ''
        [Settings]
        backend = awww
        folder = ~/resjar/wall-jar/wall-bin
      '';
    }; # end of xdg.configFile
    home.packages = with pkgs; [
      awww # animated wallpaper daemon for Wayland
      waypaper # GUI wallpaper setter for Wayland-based window managers
      nwg-drawer # full-screen app drawer launcher (Mod+D)
    ];
  }; # end of config
}
