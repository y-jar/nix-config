# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: mango (mangowm) config generation (hjem side).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[mango] =-=-=
# Copies the category config.conf dotfiles + per-host host-inputs file.
# Category configs live in liijar/wmconfigs/mango (shared with the
# home-manager side). nix-startups.conf is generated from the shell toggles
# (shelljar) + system autostart.
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
  wmc = ../wmconfigs/mango; # shared mango wm configs (liijar)
  bin = ../wmconfigs/bin; # shared wm tool scripts

  hostSpecificFile = wmc + "/host-inputs/${hostnm}.conf";
  targetConfSource =
    if builtins.pathExists hostSpecificFile then
      hostSpecificFile
    else
      wmc + "/host-inputs/0-unknown.conf";

  shelljarEnabled = hjm.mango.shelljar.enable or false;
  noctaliaEnabled = hjm.mango.noctalia.enable or false;
  generatedStartups = ''
    # mango (mangowm) — nix-generated startups
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
    packages =
      with pkgs;
      [
        jshot # wayland screenshot tool (region/screen/window) via grim+slurp+swappy
        jclip # clipboard history menu (cliphist + fuzzel)
        jlayout # toggle current tag between scroller and vertical_scroller (SUPER+CTRL+Slash)
        jbinds # keybind cheat sheet overlay in foot (SUPER+SHIFT+Slash)
        grim # wayland screenshot capture
        slurp # wayland region select for grim
        swappy # wayland screenshot annotation
        hyprpicker # color picker (SUPER+C)
        cliphist # clipboard history storage (jclip)
        xwayland-satellite # Xwayland outside the compositor
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
      ".config/mango/looks.conf".source = wmc + "/looks.conf";
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
