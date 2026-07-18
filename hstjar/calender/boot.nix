{ ... }:
{
  # boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    }; # end of loader
    # initrd.kernelModules = [ "amdgpu" ];
    supportedFilesystems = [
      "fuse"
      "ntfs"
    ];
  }; # end of boot
}
