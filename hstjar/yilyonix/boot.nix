# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host yilyonix: bootloader settings (systemd-boot).
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }: {
  # boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    }; # end of loader
  }; # end of boot
}
