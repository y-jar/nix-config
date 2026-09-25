# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Virtualization role (host = libvirtd, guest = VM tuning) + options.
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  ...
}:
{
  imports = [
    ./host.nix # libvirtd/QEMU (role = "host")
    ./guest.nix # qemu-guest-agent + virtio (role = "guest")
  ];

  options.sysset.virt = {
    role = lib.mkOption {
      type = lib.types.enum [
        "none"
        "host"
        "guest"
      ];
      default = "none";
      description = "Virtualization role: host (libvirtd/QEMU), guest (tuned as a VM), or none.";
    }; # end of role

    gui = lib.mkEnableOption "virtualization GUI tools (virt-manager + gnome-boxes); host role only";
  }; # end of options
}
