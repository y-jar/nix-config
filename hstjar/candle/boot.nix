# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host candle: bootloader settings (systemd-boot).
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }: {
  # boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    }; # end of loader
    supportedFilesystems = [
      "fuse"
      "ntfs"
    ];
  }; # end of boot
}
