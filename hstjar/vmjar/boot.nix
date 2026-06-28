{ pkgs, ... }: {
  # boot
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/vda";
        useOSProber = true;
        fsIdentifier = "provided";
      }; # end of grub
    }; # end of loader
    supportedFilesystems = [
      "fuse"
      "ntfs"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
  }; # end of boot
}
