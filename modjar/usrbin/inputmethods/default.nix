{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.inputmethods;
in
{
  options = {
    usrSettings.inputmethods = {
      japanese.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Japanese input (fcitx5 + mozc)";
      }; # end of japanese
      korean.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Korean input (fcitx5 + hangul)";
      }; # end of korean
    }; # end of usrSettings.inputmethods
  }; # end of options

  config = lib.mkIf (cfg.japanese.enable || cfg.korean.enable) {
    # remove error
    home.sessionVariables = {
      GTK_IM_MODULE = lib.mkForce "";
    }; # End of home.sessionVariables

    # mozc keymap (built from keymap.tsv into config1.db)
    xdg.configFile."mozc/config1.db" = lib.mkIf cfg.japanese.enable {
      source = import ./config1-db.nix { inherit pkgs; };
    }; # End of mozc config1.db
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      # fcitx
      fcitx5 = {
        addons =
          with pkgs;
          [
            fcitx5-gtk # GTK IM module for fcitx5
            fcitx5-nord # Nord theme for fcitx5
          ]
          ++ (lib.optionals cfg.japanese.enable [
            fcitx5-mozc # Mozc input method for fcitx5
          ])
          ++ (lib.optionals cfg.korean.enable [
            fcitx5-hangul # Hangul input method for fcitx5
          ]);

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
          }
          // lib.optionalAttrs cfg.japanese.enable {
            # Item 1 is what i toggle into when want Japanese
            "Groups/0/Items/1".Name = "mozc";
          }
          // lib.optionalAttrs cfg.korean.enable {
            # Item 2 is what i toggle into when want Korean
            # Layout=us is required for hangul (libhangul maps by key value)
            "Groups/0/Items/2" = {
              Name = "hangul";
              Layout = "us";
            };
          }; # End of inputMethod

          # [global hotkeys]
          globalOptions = {
            "Hotkey/TriggerKeys" = {
              "0" = "Super+space"; # Toggle input method on and off
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
            quickphrase = {
              globalSection = {
                TriggerKey = "Super+Alt+u";
              }; # End of globalSection
            }; # End of quickphrase
          }; # End of addons
        }; # End of Settings
      }; # End of fcitx5
    }; # End of i18n
  }; # End of config
} # end
