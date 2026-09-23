# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Graphics/gaming drivers (Vulkan, Mesa, AMD/Intel/NVIDIA).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysset.gaming.drivers;
  codecs = config.sysset.gaming.codecs;
in
{
  options = {
    sysset.gaming.drivers = {
      enable = lib.mkEnableOption "Gaming drivers (~1.5GiB, Vulkan + Mesa)";
      amd.enable = lib.mkEnableOption "AMD specific graphics drivers and compute runtimes";
      intel.enable = lib.mkEnableOption "Intel integrated graphics drivers and runtimes";
      nvidia.enable = lib.mkEnableOption "NVIDIA graphics drivers and compute runtimes";
    };
    sysset.gaming.codecs = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "GStreamer + VA-API/Vulkan debug tools (libva-utils, vulkan-tools, libvdpau). Keep off on headless/GPU-less hosts.";
      };
    };
  }; # end of options

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      # Support for controllers
      hardware.xpadneo.enable = true; # for Xbox controllers
      services.udev.packages = [ pkgs.game-devices-udev-rules ];
      services.lact.enable = true;

      # graphics + 32bit support for Steam
      hardware.graphics = {
        enable = true; # enables graphics support
        enable32Bit = true; # enables 32bit graphics support for Steam

        # 64bit packages
        extraPackages = [
          pkgs.vulkan-loader # Vulkan ICD loader
          pkgs.libvdpau-va-gl # VDPAU OpenGL fallback
          pkgs.libva-vdpau-driver # VDPAU via VA-API bridge [helps Nvidia/AMD too]
        ]
        ++ lib.optionals cfg.amd.enable [
          pkgs.rocmPackages.clr # ROCm OpenCL for AMD
        ]
        ++ lib.optionals cfg.intel.enable [
          pkgs.intel-media-driver # iHD Broadwell+ [my N100 on yilyonix]
          pkgs.intel-vaapi-driver # i965 older Intel fallback
          pkgs.intel-compute-runtime # OpenCL for Intel [useful for Blender, Darktable etc]
          pkgs.intel-ocl # older Intel OpenCL fallback
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
    })

    # codec/debug tools (kept separate from GPU drivers so GPU-less hosts can opt out)
    (lib.mkIf codecs.enable {
      environment.systemPackages = [
        pkgs.libva-utils # provides 'vainfo' for debugging hardware acceleration
        pkgs.vulkan-tools # provides 'vulkaninfo'
        pkgs.libvdpau # base VDPAU library

        # GStreamer codecs for game videos/audio
        pkgs.gst_all_1.gstreamer # base GStreamer
        pkgs.gst_all_1.gst-plugins-base # base GStreamer plugins
        pkgs.gst_all_1.gst-plugins-good # good GStreamer plugins
        pkgs.gst_all_1.gst-plugins-bad # bad GStreamer plugins
        pkgs.gst_all_1.gst-plugins-ugly # ugly GStreamer plugins
        pkgs.gst_all_1.gst-libav # libav GStreamer plugin
      ]; # end of environment.systemPackages
    })
  ]; # end of config
}
