{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    # ADD FONTS HERE, then add Return Name After
    # [ltn]
    nerd-fonts.intone-mono # RN: IntoneMono Nerd Font
    comfortaa # Clean and modern font suitable for headings and logos
    cascadia-code # Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal

    # [jp]
    ipaexfont # japanese font
    rounded-mgenplus # Japanese font based on Rounded M+ and Noto Sans Japanese
    koruri # Japanese TrueType font obtained by mixing M+ FONTS and Open Sans
    #nerd-fonts.m+ # Nerd Fonts: Multiple styles and weights, many glyph sets (e.g. Kana glyphs)
  ];
}
