# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: fuzzel: app launcher + helper scripts.
# -=-=-=-=-=-=-=-=-=-=-=
# Generates ~/.config/fuzzel/fuzzel.ini (translucent colorless glass) from
# the settings below. Unified gate: any wayland compositor (niri/hyprland)
# or the launcher toggle.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset;

  # unified gate: any wayland compositor or the launcher toggle
  enabled = cfg.niri.enable || cfg.hyprland.enable || cfg.launcher.enable;

  # =-=-=[Script Loader]
  # shared WM tool scripts live in liijar/wmconfigs/bin.
  scriptDir = ../wmconfigs/bin;
  mkScript = name: path: pkgs.writeShellScriptBin name (builtins.readFile path);

  # =-=-=[Scripts]
  jarScripts = [
    (mkScript "jsearch" (scriptDir + "/jsearch.sh"))
    (mkScript "jpower" (scriptDir + "/jpower.sh"))
    (mkScript "jemoji" (scriptDir + "/jemoji.sh"))
  ];

  # fuzzel.ini values full glass, colorless, no outline: a very subtle
  # neutral tint over the compositor blur (frosted), solid dark-gray
  # selection for readability.
  fuzzelSettings = {
    main = {
      font = "IntoneMono Nerd Font:size=12"; # the font to use
      terminal = "foot"; # the terminal to use
      prompt = "糸 >"; # the prompt to use
      width = 30; # the width of the fuzzel window
      horizontal-pad = 20; # the horizontal padding of the fuzzel window
      exit-on-keyboard-focus-loss = true; # close if clicked away
    }; # end of main
    border = {
      width = 0; # border width in pixels (0 = no outline)
      radius = 0; # border radius in pixels
    }; # end of border
    colors = {
      background = "0d0d0d38"; # the background color (subtle frosted tint)
      text = "d8dee9ff"; # the text color (neutral light gray)
      match = "a6adb8ff"; # the match color (neutral gray)
      selection = "2e3440ff"; # the selection color (dark slate gray)
      selection-text = "d8dee9ff"; # the selection text color
      border = "00000000"; # the border color (unused: width is 0)
    }; # end of colors
  }; # end of fuzzelSettings

  # fuzzel binary + launcher helper scripts, same unified gate
  fuzzelPackages = lib.optionals enabled (jarScripts ++ [ pkgs.fuzzel ]); # end of fuzzelPackages

  ini = pkgs.formats.ini { };
in
{
  config = lib.mkIf (cfg.niri.enable || cfg.hyprland.enable || cfg.launcher.enable) {
    packages = fuzzelPackages;
    files.".config/fuzzel/fuzzel.ini".source = ini.generate "fuzzel.ini" fuzzelSettings;
  }; # end of config
}
