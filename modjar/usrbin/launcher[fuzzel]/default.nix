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
        # full glass, colorless, no outline: a very subtle neutral tint over the
        # compositor blur (frosted), solid dark-gray selection for readability.
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
    }; # end of fuzzel
  }; # end of config
}
