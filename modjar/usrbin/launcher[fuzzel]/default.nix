# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Fuzzel app launcher + scripts.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  ...
}:
let
  cfg = config.usrSettings.launcher;
in
{
  imports = [
    ./addScripts.nix
  ];
  options = {
    usrSettings.launcher.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  }; # end of options

  config = lib.mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "IntoneMono Nerd Font:size=12"; # the font to use
          terminal = "foot"; # the terminal to use
          prompt = "糸 >"; # the prompt to use
          width = 30; # the width of the fuzzel window
          horizontal-pad = 20; # the horizontal padding of the fuzzel window
          exit-on-keyboard-focus-loss = true; # close if clicked away
        }; # end of main
        # translucent colorless "glass": no hue, alpha background so the desktop
        # shows through, faint white border/selection for a clean glassy look.
        border = {
          width = 1; # border width in pixels
          radius = 8; # border radius in pixels
        }; # end of border
        colors = {
          background = "1b1b1b66"; # the background color (translucent smoke)
          text = "d8dee9ff"; # the text color (neutral light gray)
          match = "9aa0b4ff"; # the match color (neutral slate)
          selection = "33ffffff"; # the selection color (translucent white)
          selection-text = "ffffffff"; # the selection text color
          border = "66ffffff"; # the border color (faint white)
        }; # end of colors
      }; # end of settings
    }; # end of fuzzel
  }; # end of config
}
