# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: installs ALL shared helper scripts (single source of truth).
# -=-=-=-=-=-=-=-=-=-=-=
# The script sources live in ./scriptsbin/ (the single copy; the old
# liijar/wmconfigs/bin copies were merged in here). Buckets:
#   core    - always installed (nix/repo helpers)
#   format  - joutputs, always installed (output/EDID formatter; deps baked in)
#   wmTools - gated on any compositor/launcher (need fuzzel/grim/wl-clipboard...)
#   wall    - jwall/random-wall, awww env injected, same compositor gate
#   mango   - jlayout/jbinds (mmsg + mango binds.conf)
# Runtime deps for the compositor bucket travel together in compositorDeps.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  hjm = config.usrset;

  # =-=-=[Gate]
  # compositor/launcher union: these scripts need a wayland session + fuzzel.
  compositor = hjm.niri.enable || hjm.hyprland.enable || hjm.mango.enable || hjm.launcher.enable;
  toolsOn = hjm.tools.enable;

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

  # =-=-=[jfocus] python + opencv (needs a real interpreter with cv2)
  jfocus = pkgs.writeShellScriptBin "jfocus" ''
    exec ${pkgs.python3.withPackages (ps: [ ps.opencv4 ])}/bin/python3 ${./scriptsbin/jfocus.py} "$@"
  '';

  # =-=-=[jimg] bake the watermark default in from resjar/scriptdepbin
  watermark = ../../../resjar/scriptdepbin/watermark.png;
  jimg = pkgs.writeShellScriptBin "jimg" ''
    export JIMG_WATERMARK="''${JIMG_WATERMARK:-${watermark}}"
    ${builtins.readFile ./scriptsbin/jimg.sh}
  '';

  # =-=-=[joutputs] output/EDID formatter; bakes decoder + clipboard paths in
  # so it works even on hosts without the compositor bucket installed.
  joutputs = pkgs.writeShellScriptBin "joutputs" ''
    export JOUTPUTS_DI_EDID_DECODE="${pkgs.libdisplay-info}/bin/di-edid-decode"
    export JOUTPUTS_WL_COPY="${pkgs.wl-clipboard}/bin/wl-copy"
    ${builtins.readFile ./scriptsbin/joutputs.sh}
  '';

  # =-=-=[Buckets]
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

  wmTools = [
    # [desktop / file]
    {
      name = "jshot";
      path = ./scriptsbin/jshot.sh;
    }
    {
      name = "jclip";
      path = ./scriptsbin/jclip.sh;
    }
    {
      name = "jemoji";
      path = ./scriptsbin/jemoji.sh;
    }
    {
      name = "jpower";
      path = ./scriptsbin/jpower.sh;
    }
    {
      name = "jsearch";
      path = ./scriptsbin/jsearch.sh;
    }
    # [media / capture]
    {
      name = "jrec";
      path = ./scriptsbin/jrec.sh;
    }
    {
      name = "jmpris";
      path = ./scriptsbin/jmpris.sh;
    }
    # [utilities]
    {
      name = "jnote";
      path = ./scriptsbin/jnote.sh;
    }
    {
      name = "jdefine";
      path = ./scriptsbin/jdefine.sh;
    }
    {
      name = "jtimer";
      path = ./scriptsbin/jtimer.sh;
    }
    {
      name = "jnight";
      path = ./scriptsbin/jnight.sh;
    }
    {
      name = "jmv";
      path = ./scriptsbin/jmv.sh;
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

  mango = [
    {
      name = "jlayout";
      path = ./scriptsbin/jlayout.sh;
    }
    {
      name = "jbinds";
      path = ./scriptsbin/jbinds.sh;
    }
  ];

  # =-=-=[Runtime deps] shared by the wmTools bucket
  compositorDeps = [
    pkgs.fuzzel
    pkgs.libnotify
    pkgs.jq
    pkgs.curl
    pkgs.wl-clipboard
    pkgs.grim
    pkgs.slurp
    pkgs.swappy
    pkgs.wf-recorder
    pkgs.cliphist
    pkgs.hyprpicker
    pkgs.imagemagick
    pkgs.gammastep
    pkgs.playerctl
    pkgs.brightnessctl
  ];
in
{
  packages =
    (mkAll core)
    ++ [ joutputs ] # always installed (output/EDID formatter; deps baked in)
    ++ lib.optionals (compositor && toolsOn) (
      (mkAll wmTools)
      ++ [
        jfocus
        jimg
      ]
      ++ (map (s: mkWallScript s.name s.path) wall)
      ++ [ pkgs.chafa ]
      ++ compositorDeps
    )
    ++ lib.optionals (hjm.mango.enable && toolsOn) (mkAll mango);
}
