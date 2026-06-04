{ pkgs, ... }:
{
  # STEAM DERIVED FIXES
  # Support for controllers
  hardware.xpadneo.enable = true; # for Xbox controllers
  services.udev.packages = [ pkgs.game-devices-udev-rules ];
  # It installs the 'udev rules' so controllers are recognized
  hardware.steam-hardware.enable = true;
  # graphics + 32bit support for Steam[TM]
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # libs
    extraPackages = with pkgs; [
      # [intel]
      intel-media-driver # iHD — Broadwell+ [my N100 on yilyonix]
      intel-vaapi-driver # i965 — older Intel fallback
      intel-compute-runtime # OpenCL for Intel [useful for Blender, Darktable etc]
      intel-ocl # older Intel OpenCL fallback

      # [amd]
      #amdvlk # AMD's official Vulkan driver [depricated]
      rocmPackages.clr # ROCm OpenCL for AMD

      # [global / fallback]
      libva-vdpau-driver # VDPAU via VA-API bridge (helps Nvidia/AMD too)
      libvdpau-va-gl # VDPAU OpenGL fallback
      mesa # amd and intel open sourse drivers
      libva-utils # vainfo command. good for debugging VA-API
      libvdpau # base VDPAU library
      vulkan-loader # Vulkan ICD loader
      vulkan-tools # vulkaninfo etc, good for debugging
      vulkan-validation-layers # catches Vulkan errors, helpful for gaming

      # [codecs]
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav # ffmpeg bridge for gstreamer
    ];
    # 32 bit libs for:
    # wine, proton, and any other compatability layer the reqs graphics
    #   and 32 bit libs
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-vaapi-driver # 32bit Intel for Steam
      mesa # 32bit mesa for Steam/Wine/Proton
      vulkan-loader # Vulkan ICD loader
      libvdpau-va-gl # VDPAU OpenGL fallback
      libva-vdpau-driver # VDPAU via VA-API bridge (helps Nvidia/AMD too)
    ];
  };
}
