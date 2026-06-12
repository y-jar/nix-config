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
  }; # end of options
  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "IntoneMono Nerd Font\:size=11";
          pad = "15x15"; # Adds some breathing room inside the window
        };

        colors-dark = {
          # background = "1a1b26";
          # foreground = "cfc9c2";
          alpha = 0.7; # trans parency
        };

        cursor = {
          style = "beam";
          blink = "yes";
        }; # end of cursor
      }; # end of settings

      # extra backups
      extraPackages = with pkgs; [
        kitty # incase foot doesnt work for root
        alacritty # terminal emulator
      ];
    }; # end of programs.foot
  }; # end of config
}
