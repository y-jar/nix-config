{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysSettings.gaming.drivers;
in
{
  options = {
    sysSettings.gaming.drivers = {
      enable = lib.mkEnableOption "gaming drivers base configuration";
      amd.enable = lib.mkEnableOption "AMD specific graphics drivers and compute runtimes";
      intel.enable = lib.mkEnableOption "Intel integrated graphics drivers and runtimes";
      nvidia.enable = lib.mkEnableOption "NVIDIA graphics drivers and compute runtimes";
    };
  }; # end of options

  config = lib.mkIf cfg.enable {
    # Support for controllers
    hardware.xpadneo.enable = true; # for Xbox controllers
    services.udev.packages = [ pkgs.game-devices-udev-rules ];

    # graphics + 32bit support for Steam
    hardware.graphics = {
      enable = true; # enables graphics support
      enable32Bit = true; # enables 32bit graphics support for Steam

      # 64bit packages
      extraPackages =
        with pkgs;
        [
          vulkan-loader # Vulkan ICD loader
          libvdpau-va-gl # VDPAU OpenGL fallback
          libva-vdpau-driver # VDPAU via VA-API bridge [helps Nvidia/AMD too]
        ]
        ++ lib.optionals cfg.amd.enable [
          rocmPackages.clr # ROCm OpenCL for AMD
        ]
        ++ lib.optionals cfg.intel.enable [
          intel-media-driver # iHD Broadwell+ [my N100 on yilyonix]
          intel-vaapi-driver # i965 older Intel fallback
          intel-compute-runtime # OpenCL for Intel [useful for Blender, Darktable etc]
          intel-ocl # older Intel OpenCL fallback
        ]; # end of extraPackages (˘ε˘)

      # 32 bit libs for:
      # wine, proton, and any other compatability layer the reqs graphics
      #   and 32 bit libs
      extraPackages32 = [
        pkgs.pkgsi686Linux.vulkan-loader # Vulkan ICD loader
        pkgs.pkgsi686Linux.libvdpau-va-gl # VDPAU OpenGL fallback
        pkgs.pkgsi686Linux.libva-vdpau-driver # VDPAU via VA-API bridge [helps Nvidia/AMD too]
      ]
      ++ lib.optionals cfg.intel.enable [
        pkgs.pkgsi686Linux.intel-vaapi-driver # i965 older Intel fallback
      ]; # end of extraPackages32
    }; # end of hardware.graphics

    # system packages for debugging :(
    environment.systemPackages = with pkgs; [
      libva-utils # provides 'vainfo' for debugging hardware acceleration
      vulkan-tools # provides 'vulkaninfo'
      libvdpau # base VDPAU library

      # GStreamer codecs for game videos/audio
      gst_all_1.gstreamer # base GStreamer
      gst_all_1.gst-plugins-base # base GStreamer plugins
      gst_all_1.gst-plugins-good # good GStreamer plugins
      gst_all_1.gst-plugins-bad # bad GStreamer plugins
      gst_all_1.gst-plugins-ugly # ugly GStreamer plugins
      gst_all_1.gst-libav # libav GStreamer plugin
    ]; # end of environment.systemPackages
  }; # end of config
}
