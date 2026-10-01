# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: mango (mangowm) config generation.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[mango] =-=-=
# Copies the category config.conf dotfiles + per-host host-inputs file.
# Category configs live in liijar/wmconfigs/mango (shared with the
# old home-manager side). nix-startups.conf is generated from the shell toggles
# (shelljar) + system autostart. Im gay
# =-=-=[end mango] =-=-=

{
  config,
  lib,
  pkgs,
  inputs,
  hostnm,
  osConfig,
  ...
}:
let
  hjm = config.usrset;
  p = config.usrset.theming.colors; # gruvbox palette
  mkArgb = c: a: "0x${builtins.substring 1 6 c}${a}"; # Mango wants RRGGBBAA
  wmc = ../wmconfigs/mango; # shared mango wm configs (liijar)
  bin = ../wmconfigs/bin; # shared wm tool scripts

  # looks.conf with the appearance hexes swapped for the palette. Mango only
  # manages windows: borders are 0px, so these stay muted on purpose.
  looksConf = pkgs.writeText "mango-looks.conf" (
    lib.replaceStrings
      [
        "0x201b14ff"
        "0x444444ff"
        "0x8FBA7C55"
        "0xEB441EFF"
        "0xc9b890ff"
        "0x89aa61ff"
        "0xad401fff"
        "0x516c93ff"
        "0xb153a7ff"
        "0x14a57cff"
      ]
      [
        (mkArgb p.bg0 "ff")
        (mkArgb p.bg4 "ff")
        (mkArgb p.accent "55")
        (mkArgb p.accent "ff")
        (mkArgb p.fg1 "ff")
        (mkArgb p.green "ff")
        (mkArgb p.red "ff")
        (mkArgb p.blue "ff")
        (mkArgb p.purple "ff")
        (mkArgb p.aqua "ff")
      ]
      (builtins.readFile (wmc + "/looks.conf"))
  );

  hostSpecificFile = wmc + "/host-inputs/${hostnm}.conf";
  targetConfSource =
    if builtins.pathExists hostSpecificFile then
      hostSpecificFile
    else
      wmc + "/host-inputs/0-unknown.conf";

  shelljarEnabled = hjm.mango.shelljar.enable or false;
  noctaliaEnabled = hjm.mango.noctalia.enable or false;
  generatedStartups = ''
    # mango (mangowm) nix-generated startups
    # Contents injected by liijar/WM-mango/hjem.nix.
    # Don't hand-edit: rebuild to regenerate.
  ''
  + lib.optionalString shelljarEnabled ''
    # desktop shell (quickshell island shell)
    exec-once=shelljar
  ''
  + lib.optionalString (noctaliaEnabled && !shelljarEnabled) ''
    # desktop shell (noctalia)
    exec-once=noctalia-shell
  ''
  + lib.concatMapStringsSep "" (c: "exec-once=${c}\n") (osConfig.sysset.autostart.commands or [ ]);

  jshot = pkgs.writeShellScriptBin "jshot" (builtins.readFile (bin + "/jshot.sh"));
  jclip = pkgs.writeShellScriptBin "jclip" (builtins.readFile (bin + "/jclip.sh"));
  jlayout = pkgs.writeShellScriptBin "jlayout" (builtins.readFile (bin + "/jlayout.sh"));
  jbinds = pkgs.writeShellScriptBin "jbinds" (builtins.readFile (bin + "/jbinds.sh"));
in
{

  config = lib.mkIf hjm.mango.enable {
    packages = [
      jshot # wayland screenshot tool (region/screen/window) via grim+slurp+swappy
      jclip # clipboard history menu (cliphist + fuzzel)
      jlayout # toggle current tag between scroller and vertical_scroller (SUPER+CTRL+Slash)
      jbinds # keybind cheat sheet overlay in foot (SUPER+SHIFT+Slash)
      pkgs.grim # wayland screenshot capture
      pkgs.slurp # wayland region select for grim
      pkgs.swappy # wayland screenshot annotation
      pkgs.hyprpicker # color picker (SUPER+C)
      pkgs.cliphist # clipboard history storage (jclip)
      pkgs.xwayland-satellite # Xwayland outside the compositor
    ]
    ++ lib.optionals shelljarEnabled [
      # desktop shell (binds.conf + generated startups use shjctl)
      inputs.shelljar.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
    ++ lib.optionals (noctaliaEnabled && !shelljarEnabled) [
      pkgs.noctalia-shell # noctalia desktop shell (quickshell based)
    ];
    files = {
      ".config/mango/config.conf".source = wmc + "/config.conf"; # linker
      ".config/mango/env.conf".source = wmc + "/env.conf";
      ".config/mango/looks.conf".source = looksConf;
      ".config/mango/animation.conf".source = wmc + "/animation.conf";
      ".config/mango/layouts.conf".source = wmc + "/layouts.conf";
      ".config/mango/input.conf".source = wmc + "/input.conf";
      ".config/mango/rule.conf".source = wmc + "/rule.conf";
      ".config/mango/binds.conf".source = wmc + "/binds.conf";
      ".config/mango/startups.conf".source = wmc + "/startups.conf";
      ".config/mango/nix-startups.conf".source =
        pkgs.writeText "mango-nix-startups.conf" generatedStartups;
      ".config/mango/host-inputs.conf".source = targetConfSource;
    };
  }; # end of config
}
