{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.japanese;
in
{
  options = {
    usrSettings.japanese.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Japanese input";
    }; # end of usrSettings.japanese
  }; # end of options

  config = lib.mkIf cfg.enable {
    # remove error
    home.sessionVariables = {
      GTK_IM_MODULE = lib.mkForce "";
    }; # End of home.sessionVariables
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      # fcitx
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mozc # Mozc input method for fcitx5
          fcitx5-gtk # GTK IM module for fcitx5
          fcitx5-nord # Nord theme for fcitx5
        ];

        # [settings]
        settings = {
          # [layouts]
          inputMethod = {
            GroupOrder."0" = "Default";
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us"; # Sets the underlying base system layout
            };
            # Item 0 is my absolute boot default
            "Groups/0/Items/0".Name = "keyboard-us";

            # Item 1 is what i toggle into when want Japanese
            "Groups/0/Items/1".Name = "mozc";
          }; # End of inputMethod

          # [global hotkeys]
          globalOptions = {
            "Hotkey/TriggerKeys" = {
              "0" = "Super+space"; # Toggle Japanese input on and off
              "1" = ""; # Clears default Zenkaku_Hankaku toggle
              "2" = ""; # Clears default Hangul toggle [later]
            }; # End of Hotkey/Trigger
            "Hotkey/AltTriggerKeys" = {
              "0" = ""; # Clears default Alt-trigger key
            };
          }; # End of globalOptions / hotkeys

          # [addons]
          addons = {
            classicui = {
              globalSection = {
                Theme = "Nord-Dark";
              }; # End of globalSection
            }; # End of classicui
          }; # End of addons
        }; # End of Settings
      }; # End of fcitx5
    }; # End of i18n
  }; # End of config
} # end
