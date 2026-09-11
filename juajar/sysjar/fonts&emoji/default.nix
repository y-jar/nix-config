# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Fonts and emoji packages for the system.
# sysset.fonts.enable (master, default true) + fonts.minimal (default false)
# lets lean hosts install only the terminal font + a handful, dropping the heavy
# JP/emoji packs (e.g. rounded-mgenplus ~700MiB) to save space.
# -=-=-=-=-=-=-=-=-=-=-=
{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.sysset.fonts;

  x5y8pxNegaTape = pkgs.stdenv.mkDerivation {
    pname = "x5y8pxNegaTape";
    version = "20260610";
    src = ../../../resjar/fontbin/x5y8pxNegaTape;
    installPhase = ''
      install -Dm644 *.ttf -t $out/share/fonts/truetype/x5y8pxNegaTape
      install -Dm644 OFL.txt -t $out/share/doc/x5y8pxNegaTape
    '';
  };
in
{
  options = {
    sysset.fonts = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Install the font set (master toggle)";
      };
      minimal = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Install only the terminal font + essentials (drops heavy JP/emoji packs)";
      };
    }; # end of sysset.fonts
  }; # end of options

  config = lib.mkIf cfg.enable {
    fonts = {
      packages =
        (with pkgs; [
          nerd-fonts.intone-mono # terminal font (always)
          # [basic]
          comfortaa
          cascadia-code
        ])
        ++ (lib.optionals (!cfg.minimal) (
          with pkgs;
          [
            # [extras]
            excalifont
            monocraft
            miracode
            # [jp]
            ipaexfont
            rounded-mgenplus # ~700MiB - the heavy one
            koruri
            x5y8pxNegaTape # JP pixel font [vendored]
            # [emojis]
            noto-fonts-emoji-blob-bin # Blobmoji
          ]
        )); # end of packages

      # emoji
      fontconfig = {
        enable = true;
        defaultFonts.emoji = [ "Blobmoji" ];
        defaultFonts.monospace = [
          "IntoneMono Nerd Font"
          "ipaexgothic"
        ];
        localConf = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <match target="pattern">
              <edit name="family" mode="append" binding="weak">
                <string>Blobmoji</string>
              </edit>
            </match>
          </fontconfig>
        ''; # end of localConf
      }; # end of fontconfig
    }; # end of fonts
  }; # end of config
}
