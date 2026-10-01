# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: terminal: foot + kitty + alacritty config generation (gruvbox).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.terminal;
  p = config.usrset.theming.colors; # gruvbox palette
  strip = c: builtins.substring 1 6 c; # "#rrggbb" -> "rrggbb"

  # shared gruvbox ansi palette (normal / bright)
  normal = {
    black = p.bg0;
    red = p.red;
    green = p.green;
    yellow = p.yellow;
    blue = p.blue;
    magenta = p.purple;
    cyan = p.aqua;
    white = p.fg1;
  };
  bright = {
    black = p.grey;
    red = p.redBright;
    green = p.greenBright;
    yellow = p.yellowBright;
    blue = p.blueBright;
    magenta = p.purpleBright;
    cyan = p.aquaBright;
    white = p.fg0;
  };
  ansiNums = [
    "0"
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
  ];
  normalList = [
    normal.black
    normal.red
    normal.green
    normal.yellow
    normal.blue
    normal.magenta
    normal.cyan
    normal.white
  ];
  brightList = [
    bright.black
    bright.red
    bright.green
    bright.yellow
    bright.blue
    bright.magenta
    bright.cyan
    bright.white
  ];

  # =-=-=[foot.ini] =-=-=
  footIni = pkgs.writeText "foot.ini" ''
    [main]
    # font from usrset.terminal + pad for breathing room inside the window
    font=${cfg.font}:size=${toString cfg.fontSize}
    pad=5x5

    [colors-dark]
    # gruvbox palette + transparency
    alpha=0.7
    foreground=${strip p.fg0}
    background=${strip p.bg1}
    regular0=${strip normal.black}
    regular1=${strip normal.red}
    regular2=${strip normal.green}
    regular3=${strip normal.yellow}
    regular4=${strip normal.blue}
    regular5=${strip normal.magenta}
    regular6=${strip normal.cyan}
    regular7=${strip normal.white}
    bright0=${strip bright.black}
    bright1=${strip bright.red}
    bright2=${strip bright.green}
    bright3=${strip bright.yellow}
    bright4=${strip bright.blue}
    bright5=${strip bright.magenta}
    bright6=${strip bright.cyan}
    bright7=${strip bright.white}
    selection-foreground=${strip p.bg1}
    selection-background=${strip p.accent}
    urls=${strip p.accent}
    cursor=${strip p.bg1} ${strip p.accent}

    [cursor]
    style=beam
    blink=yes

    [tweak]
    # suppress false monospace warning
    font-monospace-warn=no
  '';

  # =-=-=[kitty.conf] =-=-=
  kittyLines = lib.concatMapStringsSep "\n" (
    n: "color${n} ${lib.elemAt normalList (lib.toInt n)}"
  ) ansiNums;
  kittyBright = lib.concatMapStringsSep "\n" (
    n: "color${toString (lib.toInt n + 8)} ${lib.elemAt brightList (lib.toInt n)}"
  ) ansiNums;
  kittyConf = pkgs.writeText "kitty.conf" ''
    font_family ${cfg.font}
    font_size ${toString cfg.fontSize}
    background ${p.bg1}
    foreground ${p.fg0}
    cursor ${p.accent}
    cursor_text_color ${p.bg1}
    selection_background ${p.bg3}
    selection_foreground ${p.fg0}
    url_color ${p.accent}
    active_border_color ${p.accent}
    inactive_border_color ${p.bg4}
    ${kittyLines}
    ${kittyBright}
  '';

  # =-=-=[alacritty.toml] =-=-=
  alacrittyToml = pkgs.writeText "alacritty.toml" ''
    [font]
    size = ${toString cfg.fontSize}

    [font.normal]
    family = "${cfg.font}"

    [colors.primary]
    background = "${p.bg1}"
    foreground = "${p.fg0}"

    [colors.cursor]
    text = "${p.bg1}"
    cursor = "${p.accent}"

    [colors.selection]
    text = "${p.fg0}"
    background = "${p.bg3}"

    [colors.normal]
    black = "${normal.black}"
    red = "${normal.red}"
    green = "${normal.green}"
    yellow = "${normal.yellow}"
    blue = "${normal.blue}"
    magenta = "${normal.magenta}"
    cyan = "${normal.cyan}"
    white = "${normal.white}"

    [colors.bright]
    black = "${bright.black}"
    red = "${bright.red}"
    green = "${bright.green}"
    yellow = "${bright.yellow}"
    blue = "${bright.blue}"
    magenta = "${bright.magenta}"
    cyan = "${bright.cyan}"
    white = "${bright.white}"
  '';

  terminalPackages = [
    pkgs.foot
    pkgs.kitty # incase foot doesnt work for root
    pkgs.alacritty # terminal emulator
  ]; # end of terminalPackages

  terminalFiles = {
    ".config/foot/foot.ini" = footIni;
    ".config/kitty/kitty.conf" = kittyConf;
    ".config/alacritty/alacritty.toml" = alacrittyToml;
  }; # end of terminalFiles
in
{
  config = lib.mkIf cfg.enable {
    packages = terminalPackages;
    files = lib.mapAttrs (_: v: { source = v; }) terminalFiles;
  }; # end of config
}
