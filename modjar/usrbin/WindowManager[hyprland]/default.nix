# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Hyprland user config entry + host inputs.
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  config,
  hostnm,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.hyprland; # hyprland settings
  hostSpecificFile = ./host-inputs + "/${hostnm}.lua"; # host-specific input
  targetLUASource =
    if builtins.pathExists hostSpecificFile then hostSpecificFile else ./host-inputs/0-unknown.lua;

  # Desktop shell gating (mirror of the niri module): shelljar replaces noctalia.
  shelljarEnabled = config.usrSettings.shelljar.enable or false;

  # strings to swap when shelljar is active
  autostartShell = ''hl.exec_cmd("noctalia-shell")                                    -- shell'';
  autostartShellNew = ''hl.exec_cmd("shelljar")                                        -- shell (quickshell island shell)'';
  varsSuper = ''superShell = "noctalia-shell"'';
  varsSuperNew = ''superShell = "shelljar"'';

  keybindCtrl = ''hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("noctalia-shell ipc call panel-toggle control-center"))'';
  keybindCtrlNew = ''hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("shjctl toggleControlCenter"))'';
  keybindComma = ''hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("noctalia-shell ipc call settings-toggle"))'';
  keybindCommaNew = ''hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("shjctl close"))'';

  apply =
    if shelljarEnabled then
      text:
      lib.pipe text [
        (lib.replaceStrings [ autostartShell ] [ autostartShellNew ])
        (lib.replaceStrings [ varsSuper ] [ varsSuperNew ])
        (lib.replaceStrings [ keybindCtrl ] [ keybindCtrlNew ])
        (lib.replaceStrings [ keybindComma ] [ keybindCommaNew ])
      ]
    else
      text: text;
in
{
  options = {
    usrSettings.hyprland.enable = lib.mkEnableOption {
      description = "Enable Hyprland";
    };
  };
  # imports = [ ./hyprland.nix ];

  # [config]
  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "hypr/hyprland.lua".source = ./base.lua; # base linker
      "hypr/hl/autostart.lua".text = apply (builtins.readFile ./hl/autostart.lua);
      "hypr/hl/keybinds.lua".text = apply (builtins.readFile ./hl/keybinds.lua);
      "hypr/hl/vars.lua".text = apply (builtins.readFile ./hl/vars.lua);
      "hypr/hl".source = ./hl; # main config (rest of hl)
      "hypr/host-inputs/input.lua".source = targetLUASource; # host-specific inputs
      # nwg-drawer theme (shared in usrbin/, same as niri)
      "nwg-drawer/drawer.css".source = ../nwg-drawer.css;
    }; # end of xdg.configFile
    home.packages = with pkgs; [
      waypaper # GUI wallpaper setter for Wayland-based window managers
      hyprpicker # The mouse-following color picker
      woomer # Zoomer application for Wayland inspired by tsoding's boomer
      nwg-drawer # full-screen app drawer launcher (Mod+D)
    ];
  }; # end of config
}
