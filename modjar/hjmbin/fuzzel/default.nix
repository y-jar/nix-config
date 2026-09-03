# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem: fuzzel launcher look (translucent colorless glass).
# -=-=-=-=-=-=-=-=-=-=-=
# Mirror of modjar/usrbin/launcher[fuzzel]/ (home-manager programs.fuzzel).
# Generates ~/.config/fuzzel/fuzzel.ini so hjem hosts get the same glassy,
# transparent, colorless launcher. Gated on the niri/hyprland compositor or
# the launcher toggle being enabled.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  hjm = config.hjmSettings;

  ini = pkgs.formats.ini { };
  fuzzelIni = ini.generate "fuzzel.ini" {
    main = {
      font = "IntoneMono Nerd Font:size=12"; # the font to use
      terminal = "foot"; # the terminal to use
      prompt = "糸 >"; # the prompt to use
      width = 30; # the width of the fuzzel window
      horizontal-pad = 20; # the horizontal padding of the fuzzel window
      exit-on-keyboard-focus-loss = true; # close if clicked away
    };
    border = {
      width = 1; # border width in pixels
      radius = 8; # border radius in pixels
    };
    colors = {
      background = "1b1b1b66"; # translucent smoke (colorless glass)
      text = "d8dee9ff"; # neutral light gray
      match = "9aa0b4ff"; # neutral slate
      selection = "33ffffff"; # translucent white
      selection-text = "ffffffff";
      border = "66ffffff"; # faint white
    };
  };
in
{
  config = lib.mkIf (hjm.niri.enable || hjm.hyprland.enable || hjm.launcher.enable) {
    hjemDotfiles.fuzzelIni = fuzzelIni;
  }; # end of config
}