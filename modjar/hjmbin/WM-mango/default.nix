# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem: mango (mangowm) config generation.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[mango] =-=-=
# Copies the category config.conf dotfiles + per-host host-inputs file.
# Category configs live in resjar/wmconfigs/mango (shared with usrbin).
# nix-startups.conf is generated from hjemSettings (shelljar) + system autostart.
# =-=-=[end mango] =-=-=

{
  config,
  lib,
  pkgs,
  hostnm,
  osConfig,
  ...
}:
let
  hjm = config.hjmSettings;
  wmc = ../../../resjar/wmconfigs/mango; # shared mango wm configs (resjar)
  bin = ../../../resjar/wmconfigs/bin; # shared wm tool scripts

  hostSpecificFile = wmc + "/host-inputs/${hostnm}.conf";
  targetConfSource =
    if builtins.pathExists hostSpecificFile then
      hostSpecificFile
    else
      wmc + "/host-inputs/0-unknown.conf";

  shelljarEnabled = hjm.shelljar.enable or false;
  generatedStartups = ''
    # mango (mangowm) — nix-generated startups
    # Contents injected by hjmbin/WM-mango/default.nix.
    # Don't hand-edit: rebuild to regenerate.
  ''
  + lib.optionalString shelljarEnabled ''
    # desktop shell (quickshell island shell)
    exec-once=shelljar
  ''
  + lib.concatMapStringsSep "" (c: "exec-once=${c}\n") (
    osConfig.sysSettings.autostart.commands or [ ]
  );

  jshot = pkgs.writeShellScriptBin "jshot" (builtins.readFile (bin + "/jshot.sh"));
  jclip = pkgs.writeShellScriptBin "jclip" (builtins.readFile (bin + "/jclip.sh"));
in
{
  options = {
    hjmSettings.mango.enable = lib.mkEnableOption "mango (mangowm) compositor for hjem";
  }; # end of options

  config = lib.mkIf hjm.mango.enable {
    packages = with pkgs; [
      jshot # wayland screenshot tool (region/screen/window) via grim+slurp+swappy
      jclip # clipboard history menu (cliphist + fuzzel)
      grim # wayland screenshot capture
      slurp # wayland region select for grim
      swappy # wayland screenshot annotation
      hyprpicker # color picker (SUPER+C)
      cliphist # clipboard history storage (jclip)
      xwayland-satellite # Xwayland outside the compositor
    ];
    hjemDotfiles.mangowm = {
      config = wmc + "/config.conf"; # linker
      env = wmc + "/env.conf";
      looks = wmc + "/looks.conf";
      animation = wmc + "/animation.conf";
      layouts = wmc + "/layouts.conf";
      input = wmc + "/input.conf";
      rule = wmc + "/rule.conf";
      binds = wmc + "/binds.conf";
      startups = wmc + "/startups.conf";
      nixStartups = pkgs.writeText "mango-nix-startups.conf" generatedStartups;
      hostInputs = targetConfSource;
      jshot = jshot;
      jclip = jclip;
    };
  }; # end of config
}
