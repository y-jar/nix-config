# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: OBS Studio + plugins.
# -=-=-=-=-=-=-=-=-=-=-=
# The base obs-studio package lives in ./shared.nix (hjem side); the
# home-manager side installs it (plus the plugins below) via
# programs.obs-studio, so shared.packages is not re-added here.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.obs;
in
{

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;

      # optional Nvidia hardware acceleration
      # package = (
      #   pkgs.obs-studio.override {
      #     cudaSupport = true;
      #   }
      # ); # end of package

      # enableVirtualCamera = true; # enables the virtual camera

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs # Obs-studio plugin that allows you to screen capture on wlroots based wayland compositors
        obs-backgroundremoval # OBS plugin to replace the background in portrait images and video
        obs-pipewire-audio-capture # Audio device and application capture for OBS Studio using PipeWire
        obs-vaapi # optional AMD hardware acceleration
        obs-gstreamer # OBS Studio source, encoder and video filter plugin to use GStreamer elements/pipelines in OBS Studio
        obs-vkcapture # OBS Linux Vulkan/OpenGL game capture
      ]; # end of plugins
    }; # end of obs-studio
  }; # end of config
}
