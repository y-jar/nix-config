{ config, pkgs, ... }:
{
  programs.obs-studio = {
    enable = true;

    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs # Obs-studio plugin that allows you to screen capture on wlroots based wayland compositors
      obs-backgroundremoval # OBS plugin to replace the background in portrait images and video
      obs-pipewire-audio-capture # Audio device and application capture for OBS Studio using PipeWire
      obs-vaapi # optional AMD hardware acceleration
      obs-gstreamer # OBS Studio source, encoder and video filter plugin to use GStreamer elements/pipelines in OBS Studio
      obs-vkcapture # OBS Linux Vulkan/OpenGL game capture
    ];
  };
}
