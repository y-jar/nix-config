{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.terminal;
in
{
  options = {
    usrSettings.terminal.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable foot";
    };
    usrSettings.terminal.font = lib.mkOption {
      type = lib.types.str;
      default = "IntoneMono Nerd Font";
      description = "Monospace font for terminal (foot)";
    };
  }; # end of options
  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "${cfg.font}\\:size=14";
          pad = "5x5"; # Adds some breathing room inside the window
        }; # end of main

        colors-dark = {
          # background = "1a1b26";
          # foreground = "cfc9c2";
          alpha = 0.7; # trans parency
        }; # end of colors dark

        cursor = {
          style = "beam";
          blink = "yes";
        }; # end of cursor

        tweak = {
          font-monospace-warn = "no"; # suppress false monospace warning
        }; # end of tweak
      }; # end of settings

      # extra backups
    }; # end of programs.foot
    home.packages = with pkgs; [
      kitty # incase foot doesnt work for root
      alacritty # terminal emulator
    ]; # end of home.packages
  }; # end of config
}
