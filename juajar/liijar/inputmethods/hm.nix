# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: fcitx5 + mozc/hangul input methods (home-manager side).
# -=-=-=-=-=-=-=-=-=-=-=
# The fcitx5 addon set lives in ./shared.nix; this side keeps the HM-native
# bits (i18n.inputMethod settings machinery + the mozc config1.db asset).
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.inputmethods;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{

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
        addons = shared.addons;

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
