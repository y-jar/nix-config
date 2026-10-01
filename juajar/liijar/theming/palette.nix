# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: pseudo-gruvbox palette (warm + dark) single source of truth.
# -=-=-=-=-=-=-=-=-=-=-=
# Pure function: { accent, variant, blackness } -> { colors, helpers }.
# `colors` is a flat attrset of `#rrggbb` strings (safe for an attrsOf str
# option). The helpers turn those into the shapes each app needs:
#   mkRgba -> "rgba(RRGGBBAA)"  (hyprland / CSS)
#   mkArgb -> "0xAARRGGBB"      (mango)
#   strip  -> "RRGGBB"          (foot / fuzzel / alacritty)
{
  accent ? "orange",
  variant ? "dark",
  blackness ? true,
}:
let
  # accent -> gruvbox normal / bright pair. All map onto the nixpkgs
  # gruvbox-gtk-theme `themeVariants` names so the GTK theme matches.
  accents = {
    orange = {
      normal = "#d65d0e";
      bright = "#fe8019";
    };
    red = {
      normal = "#cc241d";
      bright = "#fb4934";
    };
    yellow = {
      normal = "#d79921";
      bright = "#fabd2f";
    };
    green = {
      normal = "#98971a";
      bright = "#b8bb26";
    };
    teal = {
      normal = "#689d6a";
      bright = "#8ec07c";
    };
    purple = {
      normal = "#b16286";
      bright = "#d3869b";
    };
    pink = {
      normal = "#b16286";
      bright = "#d3869b";
    };
    grey = {
      normal = "#928374";
      bright = "#a89984";
    };
    default = {
      normal = "#d65d0e";
      bright = "#fe8019";
    };
  };
  a = accents.${accent} or accents.orange;

  dark = variant == "dark";

  # warm blacks; the `blackness` knob pushes them a touch deeper.
  darkSurfaces = {
    bg0 = if blackness then "#14110f" else "#1d2021";
    bg1 = if blackness then "#1a1714" else "#282828";
    bg2 = if blackness then "#221e1a" else "#32302f";
    bg3 = if blackness then "#2b2622" else "#3c3836";
    bg4 = if blackness then "#3a332c" else "#504945";
    fg0 = "#ebdbb2";
    fg1 = "#d5c4a1";
    fg2 = "#a89984";
    grey = "#928374";
  };

  lightSurfaces = {
    bg0 = "#fbf1c7";
    bg1 = "#f2e5bc";
    bg2 = "#ebdbb2";
    bg3 = "#d5c4a1";
    bg4 = "#bdae93";
    fg0 = "#3c3836";
    fg1 = "#504945";
    fg2 = "#665c54";
    grey = "#7c6f64";
  };

  s = if dark then darkSurfaces else lightSurfaces;

  strip = c: builtins.substring 1 6 c; # "#rrggbb" -> "rrggbb"
in
{
  colors = {
    inherit (s)
      bg0
      bg1
      bg2
      bg3
      bg4
      fg0
      fg1
      fg2
      grey
      ;
    accent = a.normal;
    accentBright = a.bright;

    red = "#cc241d";
    redBright = "#fb4934";
    yellow = "#d79921";
    yellowBright = "#fabd2f";
    green = "#98971a";
    greenBright = "#b8bb26";
    aqua = "#689d6a";
    aquaBright = "#8ec07c";
    blue = "#458588";
    blueBright = "#83a598";
    purple = "#b16286";
    purpleBright = "#d3869b";
  };

  inherit strip;
  mkRgba = c: alpha: "rgba(${strip c}${alpha})";
  mkArgb = c: alpha: "0x${alpha}${strip c}";
}
