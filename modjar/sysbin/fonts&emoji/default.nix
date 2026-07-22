{ pkgs, ... }:
{
  fonts = {
      packages = with pkgs; [
      # ADD FONTS HERE, then add Return Name After
      # [ltn]
      nerd-fonts.intone-mono # RN: IntoneMono Nerd Font
      comfortaa # Clean and modern font suitable for headings and logos
      cascadia-code # Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal
      excalifont # Font based on the original handwritten Virgil font carefully curated to improve legibility while preserving its hand-drawn nature
      noto-fonts-emoji-blob-bin # Emoji font based on the Noto Emoji blob [ref:whisper]

      # [jp]
      ipaexfont # japanese font
      rounded-mgenplus # Japanese font based on Rounded M+ and Noto Sans Japanese
      koruri # Japanese TrueType font obtained by mixing M+ FONTS and Open Sans
      #nerd-fonts.m+ # Nerd Fonts: Multiple styles and weights, many glyph sets (e.g. Kana glyphs)
    ]; # end of packages

    # emoji
    fontconfig = {
      enable = true;
      defaultFonts.emoji = [ "Blobmoji" ];
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
}
