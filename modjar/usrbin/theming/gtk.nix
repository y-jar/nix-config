# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: GTK theme application.
# -=-=-=-=-=-=-=-=-=-=-=
{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.usrSettings.theming;
in
{
  config = lib.mkIf cfg.enable {
    # [pkgs]
    home.packages = [ pkgs.papirus-folders ];

    # [cursor settings]
    home.pointerCursor =
      let
        jcsr = pkgs.runCommand "jcsr" { } ''
          mkdir -p $out/share/icons/jcsr
          cp -r ${./cursors/jcsr}/* $out/share/icons/jcsr/
        '';
      in
      {
        name = "jcsr";
        package = jcsr;
        gtk.enable = true;
        size = cfg.cursorSize;
      }; # end of home.pointerCursor

    # [gtk settings]
    gtk = {
      enable = true;

      # [theme settings]
      theme = {
        name = "catppuccin-${cfg.flavor}-${cfg.accent}-standard";
        package = pkgs.catppuccin-gtk.override {
          accents = [ cfg.accent ];
          size = "standard";
          variant = cfg.flavor;
        }; # end of package
      }; # end of theme

      # [icon theme settings]
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = cfg.flavor;
          accent = cfg.accent;
        }; # end of package
      }; # end of iconTheme

      # [linking!]
      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      # GTK hardcodes Ctrl+. / Ctrl+; to its emoji picker ("insert-emoji").
      # Those clash with mozc's Ctrl+. = full katakana and Ctrl+; = full
      # alphanumeric, so unbind them and move the picker to Super+Alt+Space
      # (which is already jemoji at the compositor level).
      gtk3.extraCss = ''
        @binding-set EmojiSelectRemap {
          unbind "<Control>period";
          unbind "<Control>semicolon";
          bind "<Super><Alt>space" { "insert-emoji" () };
        }
        entry, textview {
          -gtk-key-bindings: EmojiSelectRemap;
        }
      '';
      # mirrors the gtk3 theme into gtk4/libadwaita apps instead of leaving
      # them on stock Adwaita (this was the actual bug before)
      gtk4.theme = config.gtk.theme;
    }; # end of gtk

    # [dconf settings]
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      }; # end of "org/gnome/desktop/interface"
    }; # end of dconf.settings
  }; # end of config
}
