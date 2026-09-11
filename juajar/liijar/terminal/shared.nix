# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Terminal shared data: foot.ini generation + foot/kitty/alacritty packages.
# -=-=-=-=-=-=-=-=-=-=-=
{
  cfg,
  pkgs,
  lib,
  ...
}:
let
  footIni = pkgs.writeText "foot.ini" ''
    [main]
    # font from usrset.terminal + pad for breathing room inside the window
    font=${cfg.font}:size=${toString cfg.fontSize}
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
  packages = with pkgs; [
    foot
    kitty # incase foot doesnt work for root
    alacritty # terminal emulator
  ]; # end of packages

  files = {
    ".config/foot/foot.ini" = footIni;
  }; # end of files
}
