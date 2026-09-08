# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem: foot terminal config generation.
# -=-=-=-=-=-=-=-=-=-=-=
# Mirror of modjar/usrbin/terminal (home-manager): consumes
# hjmSettings.terminal.{font,fontSize} and writes ~/.config/foot/foot.ini
# via the hjemDotfiles mechanism (wired in modjar/hjemkey.nix).
# Fonts themselves are system-level (modjar/sysbin/fonts&emoji).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:

let
  hjm = config.hjmSettings.terminal;

  footIni = pkgs.writeText "foot.ini" ''
    [main]
    # font from hjmSettings.terminal + pad for breathing room inside the window
    font=${hjm.font}:size=${toString hjm.fontSize}
    pad=5x5

    [colors-dark]
    # transparency
    alpha=0.7

    [cursor]
    style=beam
    blink=yes

    [tweak]
    # suppress false monospace warning
    font-monospace-warn=no
  '';
in
{
  config = lib.mkIf hjm.enable {
    hjemDotfiles.footIni = footIni;
  }; # end of config
}
