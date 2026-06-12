{ pkgs, ... }:
{
  # boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    }; # end of loader
    initrd.kernelModules = [ "amdgpu" ];
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [
      "fuse"
      "ntfs"
    ];
  }; # end of boot
}
