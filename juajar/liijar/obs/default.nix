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
    ++ (with pkgs.obs-studio-plugins; [
      wlrobs # Obs-studio plugin that allows you to screen capture on wlroots based wayland compositors
      obs-backgroundremoval # OBS plugin to replace the background in portrait images and video
      obs-pipewire-audio-capture # Audio device and application capture for OBS Studio using PipeWire
      obs-vaapi # optional AMD hardware acceleration
      obs-gstreamer # OBS Studio source, encoder and video filter plugin to use GStreamer elements/pipelines in OBS Studio
      obs-vkcapture # OBS Linux Vulkan/OpenGL game capture
    ]); # end of plugins
  }; # end of config
}
