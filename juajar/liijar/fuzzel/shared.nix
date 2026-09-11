# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Fuzzel shared data (ini settings + helper scripts + package bucket).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/fuzzel/shared.nix] =-=-=
# Pure data shared by both backends:
#   - settings: the fuzzel.ini values (HM serializes them via programs.fuzzel,
#     hjem via pkgs.formats.ini same values, same file)
#   - packages: the fuzzel binary + the jarScripts helpers (jsearch/jpower/
#     jemoji from liijar/wmconfigs/bin), gated on the unified
#     niri || hyprland || launcher gate used by both backends.
# =-=-=[end liijar/fuzzel/shared.nix] =-=-=
{
  cfg,
  pkgs,
  lib,
  ...
}:

let
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
in
{
  # fuzzel.ini values full glass, colorless, no outline: a very subtle
  # neutral tint over the compositor blur (frosted), solid dark-gray
  # selection for readability.
  settings = {
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
  }; # end of settings

  # fuzzel binary + launcher helper scripts, same unified gate
  packages = lib.optionals enabled (jarScripts ++ [ pkgs.fuzzel ]);
}
