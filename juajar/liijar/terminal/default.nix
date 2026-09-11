# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: terminal: foot.ini generation + foot/kitty/alacritty packages.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.terminal;

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

  terminalPackages = with pkgs; [
    foot
    kitty # incase foot doesnt work for root
    alacritty # terminal emulator
  ]; # end of terminalPackages

  terminalFiles = {
    ".config/foot/foot.ini" = footIni;
  }; # end of terminalFiles
in
{
  config = lib.mkIf cfg.enable {
    packages = terminalPackages;
    files = lib.mapAttrs (_: v: { source = v; }) terminalFiles;
  }; # end of config
}
