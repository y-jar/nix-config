# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem: fcitx5/mozc dotfiles.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[inputmethods] =-=-=
# Japanese/Korean input for hjem hosts: fcitx5 + mozc/hangul.
# Mirrors modjar/usrbin/inputmethods/.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hjmSettings.inputmethods;

  fcitx5Package = pkgs.qt6Packages.fcitx5-with-addons.override {
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
  };

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

  mozcConfig1Db = import ../../usrbin/inputmethods/config1-db.nix { inherit pkgs; };

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
    packages = [ fcitx5Package ];

    hjemDotfiles = {
      inherit mozcConfig1Db fcitx5Files;
    };

    environment.sessionVariables = {
      GLFW_IM_MODULE = "ibus"; # IME support in kitty
      SDL_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      GTK_IM_MODULE = ""; # fcitx5-gtk handles GTK apps natively
      QT_IM_MODULE = "fcitx";
      QT_PLUGIN_PATH = [ "${fcitx5Package}/${pkgs.qt6.qtbase.qtPluginPrefix}" ];
    };

    systemd.services.fcitx5-daemon = {
      description = "Fcitx5 input method editor";
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${fcitx5Package}/bin/fcitx5";
      };
      wantedBy = [ "graphical-session.target" ];
    };
  };
}
