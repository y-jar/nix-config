# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Virt guest role: qemu-guest-agent + spice + virtio drivers.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  ...
}:
let
  cfg = config.sysset.virt;
in
{
  config = lib.mkIf (cfg.role == "guest") {
    services.qemuGuest.enable = true; # guest agent (host <-> guest)
    services.spice-vdagentd.enable = true; # clipboard sharing + dynamic scaling

    # virtio drivers (equivalent to nixpkgs profiles/qemu-guest.nix, kept in-module
    # so guest hosts don't rely on the generated hardware-configuration.nix).
    boot.initrd.availableKernelModules = [
      "virtio_net"
      "virtio_pci"
      "virtio_mmio"
      "virtio_blk"
      "virtio_scsi"
      "9p"
      "9pnet_virtio"
      "virtiofs"
    ];
    boot.initrd.kernelModules = [
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
      "virtio_gpu"
    ];
  }; # end of config
}
