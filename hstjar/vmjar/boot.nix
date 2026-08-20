# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host vmjar: bootloader settings (systemd-boot).
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }: {
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
  }; # end of boot
}
