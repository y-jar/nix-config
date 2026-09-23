# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host whale: bootloader settings (grub).
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }: {
  # boot
  sysset.boot.grubDevice = "/dev/sda";
  boot = {
    loader = {
      grub = {
        enable = true;
        useOSProber = true;
        fsIdentifier = "provided";
      }; # end of grub
    }; # end of loader
    supportedFilesystems = [
      "fuse"
      "ntfs"
    ];
  }; # end of boot
}
