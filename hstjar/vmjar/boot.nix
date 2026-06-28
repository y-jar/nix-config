{ ... }: {
  # boot
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/vda";
        useOSProber = "true";
        fsIdentifier = "Provided";
      };
    }; # end of loader
    supportedFilesystems = [
      "fuse"
      "ntfs"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
  }; # end of boot
}
