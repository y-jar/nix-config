# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Virt host role: libvirtd/QEMU (+ optional GUI managers via sysset.virt.gui).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysset.virt;
in
{
  config = lib.mkIf (cfg.role == "host") {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true; # Allows libvirtd to use swtpm to create an emulated TPM.
        vhostUserPackages = [ pkgs.virtiofsd ];
      }; # end of qemu
    }; # end of virtualisation.libvirtd
    virtualisation.spiceUSBRedirection.enable = true; # Allows USB redirection via SPICE.

    environment.systemPackages = [
      pkgs.dnsmasq # guest DNS/DHCP for libvirt networks
      pkgs.phodav # webdav file sharing with guests
    ]
    ++ lib.optionals cfg.gui [
      pkgs.gnome-boxes # Virtual machine manager
      pkgs.virt-manager # Virtual machine manager
    ]; # end of environment.systemPackages
  }; # end of config
}
