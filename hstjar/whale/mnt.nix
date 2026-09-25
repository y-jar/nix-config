# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host calender: imports YilyoSeal drive and others
# -=-=-=-=-=-=-=-=-=-=-=
{
  ...
}:
{
  fileSystems."/mnt/YilyoSeal" = {
    device = "/dev/disk/by-uuid/f21a0f71-4f93-4fac-89d8-41af9e95e958";
    fsType = "ext4";
    options = [
      "nofail" # prevents boot failure when the drive isn't plugged in
      "noauto" # prevents the drive from being mounted automatically at boot
      "x-systemd.automount" # mounts it automatically the first time something accesses the mountpoint
    ];
  };
  fileSystems."/mnt/uijar" = {
    device = "/dev/disk/by-uuid/e40a9304-f132-4043-8d23-6853dfda19a0";
    fsType = "ext4";
    options = [
      "nofail" # prevents boot failure when the drive isn't plugged in
      "noauto" # prevents the drive from being mounted automatically at boot
      "x-systemd.automount" # mounts it automatically the first time something accesses the mountpoint
    ];
  };
}
