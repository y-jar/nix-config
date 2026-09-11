# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Installs user helper scripts (bldjar, jwall, etc.) — hjem side.
# -=-=-=-=-=-=-=-=-=-=-=
# The script sources live in ./scriptsbin/ (the single copy, shared with the
# home-manager backend in hm.nix). bldjar/fixzsh/ytdl are installed always;
# the wallpaper pickers (jwall/random-wall) plus chafa (their fzf preview)
# are gated on a Wayland compositor, matching awww's gate.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  hjm = config.usrset;

  # =-=-=[Script Loader]
  mkScript = name: path: pkgs.writeShellScriptBin name (builtins.readFile path);
  mkAll = list: map (s: mkScript s.name s.path) list;

  # =-=-=[Scripts]
  core = [
    {
      name = "bldjar";
      path = ./scriptsbin/bldjar.sh;
    }
    {
      name = "fixzsh";
      path = ./scriptsbin/fixzsh.sh;
    }
    {
      name = "ytdl";
      path = ./scriptsbin/ytdl.sh;
    }
  ];

  wall = [
    {
      name = "random-wall";
      path = ./scriptsbin/random-wall.sh;
    }
    {
      name = "jwall";
      path = ./scriptsbin/jwall.sh;
    }
  ];
in
{
  packages =
    (mkAll core)
    ++ lib.optionals (hjm.niri.enable || hjm.hyprland.enable) (mkAll wall ++ [ pkgs.chafa ]);
}
