# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host whale: bootloader settings (systemd-boot).
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }: {
  # boot
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda"; # Changed from /dev/vda to /dev/sda
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
