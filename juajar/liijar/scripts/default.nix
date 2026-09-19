# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: installs user helper scripts (bldjar, jwall, etc.).
# -=-=-=-=-=-=-=-=-=-=-=
# The script sources live in ./scriptsbin/ (the single copy).
# bldjar/fixzsh/ytdl/gb/gu are installed always; the wallpaper pickers
# (jwall/random-wall) plus chafa (their fzf preview) are gated on a
# Wayland compositor, matching awww's gate.
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

  # =-=-=[Awww Env]
  # Compositor-spawned runs (foot -e jwall keybind, startup random-wall)
  # source no shell profile, so the AWWW_* transition vars must travel
  # inside the script. Single-sourced from liijar/awww's sessionVariables.
  awwwEnv = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (k: v: "export ${k}=\"${toString v}\"") (
      lib.filterAttrs (n: _: lib.hasPrefix "AWWW_" n) config.environment.sessionVariables
    )
  );
  mkWallScript = name: path: pkgs.writeShellScriptBin name (awwwEnv + "\n" + builtins.readFile path);

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
    {
      name = "gb";
      path = ./scriptsbin/gb.sh;
    }
    {
      name = "gu";
      path = ./scriptsbin/gu.sh;
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
    ++ lib.optionals (hjm.niri.enable || hjm.hyprland.enable) (
      (map (s: mkWallScript s.name s.path) wall) ++ [ pkgs.chafa ]
    );
}
