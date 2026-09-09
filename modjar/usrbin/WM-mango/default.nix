# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: mango (mangowm) user config entry + host inputs.
# Category configs live in resjar/wmconfigs/mango (single source of truth, so
# you can drop the folder into your own repo). nix-startups.conf is generated
# (shelljar spawn + autostart.commands), mirroring the niri startups.kdl flow.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  hostnm,
  osConfig,
  ...
}:
let
  cfg = config.usrSettings.mango; # mango settings
  wmc = ../../../resjar/wmconfigs/mango; # shared mango wm configs (resjar)
  bin = ../../../resjar/wmconfigs/bin; # shared wm tool scripts

  hostSpecificFile = wmc + "/host-inputs/${hostnm}.conf"; # host-specific input
  targetConfSource =
    if builtins.pathExists hostSpecificFile then
      hostSpecificFile
    else
      wmc + "/host-inputs/0-unknown.conf";

  # nix-injected startups (shelljar spawn + system autostart commands).
  shelljarEnabled = config.usrSettings.shelljar.enable or false;
  generatedStartups = ''
    # mango (mangowm) — nix-generated startups
    # Contents injected by WM-mango/default.nix from system autostart + shelljar toggle.
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
  jlayout = pkgs.writeShellScriptBin "jlayout" (builtins.readFile (bin + "/jlayout.sh"));
  jbinds = pkgs.writeShellScriptBin "jbinds" (builtins.readFile (bin + "/jbinds.sh"));
in
{
  options = {
    usrSettings.mango.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable mango window manager";
    }; # end of usrSettings.mango.enable
  }; # end of options

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      # [category configs (sourced by config.conf linker)]
      "mango/config.conf".source = wmc + "/config.conf"; # linker
      "mango/env.conf".source = wmc + "/env.conf";
      "mango/looks.conf".source = wmc + "/looks.conf";
      "mango/animation.conf".source = wmc + "/animation.conf";
      "mango/layouts.conf".source = wmc + "/layouts.conf";
      "mango/input.conf".source = wmc + "/input.conf";
      "mango/rule.conf".source = wmc + "/rule.conf";
      "mango/binds.conf".source = wmc + "/binds.conf";
      "mango/startups.conf".source = wmc + "/startups.conf";
      # [nix-generated startups]
      "mango/nix-startups.conf".text = generatedStartups;
      # [host specific inputs]
      "mango/host-inputs.conf".source = targetConfSource;
    }; # end of xdg.configFile
    home.packages = with pkgs; [
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
    ]; # end of home.packages
  }; # end of config
}
