**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Mounts & Drives

How host mounts are declared and how to touch them without losing data.

## Whale drive identity

Always confirm with `lsblk -f` before acting; device names can change.

| Device | Filesystem | UUID | Mount |
| --- | --- | --- | --- |
| `nvme0n1p1` | vfat (EFI) | `324E-57DC` | `/boot` |
| `nvme0n1p2` | swap | `f2d1d3ac-6d26-4f2c-9706-9438807e5170` | swap |
| `nvme0n1p3` | btrfs (`@`, `@nix`) | `d0948979-4aba-496c-bba6-39bd5b0f947b` | `/`, `/nix` |
| `nvme0n1p4` | btrfs | `be212f94-d77a-4916-9879-3b02f37a81ee` | `/home` |
| `nvme1n1p1` | btrfs (label `xtramda`) | `cb808d57-7f86-40a3-8c1f-624f3c3334f0` | `/mnt/xtramda` |

`/mnt/YilyoSeal` (`f21a0f71-4f93-4fac-89d8-41af9e95e958`) exists on
calender and yil01 only. It is not present on whale.

## Rules

- Address drives by UUID or label (`/dev/disk/by-uuid/...`,
  `/dev/disk/by-label/xtramda`). Never use raw `nvmeXnY` names, and never
  treat `nvme0n1p1` as data: it is the EFI `/boot` partition.
- Access `/mnt/xtramda` through its automount, or run
  `systemctl start mnt-xtramda.mount`. Do not run `mount /dev/... /mnt/xtramda`
  over an `x-systemd.automount` point; that creates stacked mounts and
  `EBUSY`/`umount` failures.
- Before copying, confirm the drive is mounted with
  `findmnt -M /mnt/xtramda`. Data copied into an unmounted mountpoint lands on
  the root filesystem and is hidden once the drive mounts.
- Before unmounting, `cd /` and check `sudo fuser -vm /mnt/xtramda`.
- Never run `wipefs`, `mkfs`, or `btrfs check --repair` against an existing
  drive to "fix" a mount problem. Check `btrfs device stats` and scrub first.

## Host entries

Mounts live in `hstjar/<host>/mnt.nix`. Keep entries per host; do not copy them
between hosts without verifying the UUID and filesystem type on the target.
