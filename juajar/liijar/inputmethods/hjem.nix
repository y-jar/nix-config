# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: fcitx5/mozc input methods (hjem side).
# =-=-=[inputmethods] =-=-=
# Japanese/Korean input for hjem hosts: fcitx5 + mozc/hangul. The addon set
# + fcitx5 package live in ./shared.nix; this side keeps the direct dotfile
# writes (fcitx5 profile/config/conf files + mozc config1.db) and the IME
# environment variables.
# =-=-=[end inputmethods] =-=-=
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.usrset.inputmethods;
  shared = import ./shared.nix { inherit cfg pkgs lib; };

  fcitx5Package = shared.fcitx5Package;

  iniFormat = pkgs.formats.ini { };
  iniGlobalFormat = pkgs.formats.iniWithGlobalSection { };

  normalize =
    value:
    if lib.isAttrs value then
      lib.mapAttrs (_: normalize) value
    else if builtins.isList value then
      map normalize value
    else if builtins.isBool value then
      if value then "True" else "False"
    else
      value;

  mozcConfig1Db = import ./config1-db.nix { inherit pkgs; };

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
      quickphrase = {
        globalSection = {
          TriggerKey = "Super+Alt+u";
        }; # End of globalSection
      }; # End of quickphrase
    }; # End of addons
  }; # End of settings

  fcitx5Files = pkgs.linkFarm "fcitx5-config" [
    {
      name = "config";
      path = iniFormat.generate "fcitx5-config" (normalize settings.globalOptions);
    }
    {
      name = "profile";
      path = iniFormat.generate "fcitx5-profile" (normalize settings.inputMethod);
    }
    {
      name = "conf/classicui.conf";
      path = iniGlobalFormat.generate "fcitx5-classicui.conf" (normalize settings.addons.classicui);
    }
    {
      name = "conf/quickphrase.conf";
      path = iniGlobalFormat.generate "fcitx5-quickphrase.conf" (normalize settings.addons.quickphrase);
    }
  ];
in
{
  config = lib.mkIf (cfg.japanese.enable || cfg.korean.enable) {
    packages = shared.packages;

    files = {
      ".config/mozc/config1.db".source = mozcConfig1Db;
      ".config/fcitx5".source = fcitx5Files;
    };

    # IME environment (lands in hjem's user environment -> .profile via loadEnv)
    environment.sessionVariables = {
      GLFW_IM_MODULE = "ibus"; # IME support in kitty
      SDL_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      GTK_IM_MODULE = ""; # fcitx5-gtk handles GTK apps natively
      QT_IM_MODULE = "fcitx";
      QT_PLUGIN_PATH = [ "${fcitx5Package}/${pkgs.qt6.qtbase.qtPluginPrefix}" ];
    };

    # NOTE: the old system-level systemd.services.fcitx5-daemon here was a
    # silent no-op (hjem's user submodule swallows system-scope options), so
    # it was dropped. fcitx5 is started per-session (see the `rfc5` alias).
  };
}
