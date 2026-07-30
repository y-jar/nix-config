{ lib, config, ... }:
let
  cfg = config.sysSettings.nvidia;
in
{
  options.sysSettings.nvidia = {
    enable = lib.mkEnableOption "NVIDIA GPU drivers and CUDA support";
    open = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use open-source NVIDIA kernel module (Turing/RTX 2000+ only)";
    }; # end of open option
  }; # end of options

  # [Fuck Nvidia]
  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = cfg.open;
      nvidiaSettings = true;
    }; # end of hardware.nvidia
    boot.blacklistedKernelModules = [ "nouveau" ];
  }; # end of config
}
