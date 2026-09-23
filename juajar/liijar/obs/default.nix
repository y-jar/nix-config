# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: obs: obs-studio + the six plugins.
# -=-=-=-=-=-=-=-=-=-=-=
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
    packages = [
      pkgs.obs-studio
    ]
    ++ [
      pkgs.obs-studio-plugins.wlrobs # Obs-studio plugin that allows you to screen capture on wlroots based wayland compositors
      pkgs.obs-studio-plugins.obs-backgroundremoval # OBS plugin to replace the background in portrait images and video
      pkgs.obs-studio-plugins.obs-pipewire-audio-capture # Audio device and application capture for OBS Studio using PipeWire
      pkgs.obs-studio-plugins.obs-vaapi # optional AMD hardware acceleration
      pkgs.obs-studio-plugins.obs-gstreamer # OBS Studio source, encoder and video filter plugin to use GStreamer elements/pipelines in OBS Studio
      pkgs.obs-studio-plugins.obs-vkcapture # OBS Linux Vulkan/OpenGL game capture
    ]; # end of plugins
  }; # end of config
}
