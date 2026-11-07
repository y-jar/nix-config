# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host whale: imports xtramda (data) + uijar (portable) drives
# -=-=-=-=-=-=-=-=-=-=-=
{
  ...
}:
{
  fileSystems."/mnt/uijar" = {
    device = "/dev/disk/by-uuid/e40a9304-f132-4043-8d23-6853dfda19a0";
    fsType = "ext4";
    options = [
      "nofail" # prevents boot failure when the drive isn't plugged in
      "noauto" # prevents the drive from being mounted automatically at boot
      "x-systemd.automount" # mounts it automatically the first time something accesses the mountpoint
      "x-systemd.device-timeout=5s" # fail fast when the portable drive is absent
    ];
  };
  fileSystems."/mnt/xtramda" = {
    device = "/dev/disk/by-uuid/cb808d57-7f86-40a3-8c1f-624f3c3334f0";
    fsType = "btrfs";
    options = [
      "nofail" # prevents boot failure when the drive isn't plugged in
      "noauto" # prevents the drive from being mounted automatically at boot
      "x-systemd.automount" # mounts it automatically the first time something accesses the mountpoint
    ];
  };
}
