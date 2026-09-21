#!/usr/bin/env bash
# testvm.sh Tier 2: drive the real nixinstall (Iso Install) inside a
# disposable, headless, hypervisor-isolated VM.
#
# Safety model:
#   * Everything lives under /tmp/opencode/tier2/ ; refuse to run as root.
#   * The guest disk is a regular sparse FILE (disk.img) under that dir —
#     not a block device.  The host NVMe is never passed to the guest.
#   * User-mode SLIRP networking only (no tap/bridge); the only forwarded
#     port is 127.0.0.1:22722 -> guest:22.  No host /dev/* is exposed.
#   * If anything goes wrong the whole $TEST_ROOT can be deleted.
#
# NOTE: requires an ISO built AFTER the nixinstall rename (buildiso.sh) —
# the installer is driven via the `nixinstall` command baked into the ISO.
#
# The install is driven via SSH using nixinstall's NIXINSTALL_AUTO env-var
# mode (no serial pty). It performs the full base install: partition ->
# format -> mount -> core NixOS (user + ssh key) -> clone of
# y-jar/nix-config into /home/test/nix-config (NO flake switch).
# Phase 3 boots the installed disk and verifies over SSH as the created
# user (key auth via NIXINSTALL_AUTO_SSH_KEY).
set -euo pipefail

TEST_ROOT="/tmp/opencode/tier2"
ISO="${ISO:-}" # resolved lazily in safety_check so --help works without one
VMPTY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/vmpty.py"
GUEST_PORT=22722
DISK="$TEST_ROOT/disk.img"
SOCK="$TEST_ROOT/console.sock"
KEY="$TEST_ROOT/tier2key"
KERNEL="$TEST_ROOT/kernel"
INITRD="$TEST_ROOT/initrd"
GRUB_CFG="$TEST_ROOT/grub.cfg"
PYTHON="${PYTHON:-python3}"
DRY_RUN=0
SMOKE=0
COMBO="ext4-home"
VMRAM="${VMRAM:-8192}"
SSH_OPTS=(-i "$KEY" -p "$GUEST_PORT" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o PasswordAuthentication=no -o ConnectTimeout=10)

GUEST_USER="test"          # created by nixinstall from NIXINSTALL_AUTO_USERNAME
GUEST_HOSTNAME="tier2test" # from NIXINSTALL_AUTO_HOSTNAME
GUEST_REPO_URL="https://github.com/y-jar/nix-config.git"

# Combo vars (set by load_combo)
DISK_LAYOUT=""
AUTO_FS=""
AUTO_HOME=""
AUTO_SWAP=""
AUTO_SWAP_SIZE=""
AUTO_SUBVOL=""
AUTO_ROOT_PART=""
AUTO_HOME_PART=""
AUTO_SWAP_PART=""
AUTO_BOOT_PART=""
AUTO_PARTITION=""
AUTO_LABEL=""
AUTO_ROOT_SIZE=""
VERIFY_HOME=""
VERIFY_SWAP=""
VERIFY_SUBVOL=""
VERIFY_BOOT=""

COMBOS="ext4-home ext4-flat ext4-home-swap btrfs-home btrfs-subvol btrfs-subvol-flat xfs-home gpt-btrfs-bios-home gpt-auto-btrfs-subvol-bios-home"

die() { echo "FAIL: $*" >&2; exit 1; }

load_combo() {
  case "$COMBO" in
    ext4-home)
      DISK_LAYOUT=$'label: dos\n,18G,L\n,,L\n'
      AUTO_FS=ext4;     AUTO_HOME=1; AUTO_SWAP=0; AUTO_SUBVOL=0
      AUTO_ROOT_PART=/dev/vda1; AUTO_HOME_PART=/dev/vda2; AUTO_SWAP_PART=""
      VERIFY_HOME=1; VERIFY_SWAP=0; VERIFY_SUBVOL=0
      ;;
    ext4-flat)
      DISK_LAYOUT=$'label: dos\n,,L\n'
      AUTO_FS=ext4;     AUTO_HOME=0; AUTO_SWAP=0; AUTO_SUBVOL=0
      AUTO_ROOT_PART=/dev/vda1; AUTO_HOME_PART="";    AUTO_SWAP_PART=""
      VERIFY_HOME=0; VERIFY_SWAP=0; VERIFY_SUBVOL=0
      ;;
    ext4-home-swap)
      DISK_LAYOUT=$'label: dos\n,16G,L\n,2G,L\n,,L\n'
      AUTO_FS=ext4;     AUTO_HOME=1; AUTO_SWAP=1; AUTO_SWAP_SIZE=2G; AUTO_SUBVOL=0
      AUTO_ROOT_PART=/dev/vda1; AUTO_HOME_PART=/dev/vda2; AUTO_SWAP_PART=/dev/vda3
      VERIFY_HOME=1; VERIFY_SWAP=1; VERIFY_SUBVOL=0
      ;;
    btrfs-home)
      DISK_LAYOUT=$'label: dos\n,18G,L\n,,L\n'
      AUTO_FS=btrfs;    AUTO_HOME=1; AUTO_SWAP=0; AUTO_SUBVOL=0
      AUTO_ROOT_PART=/dev/vda1; AUTO_HOME_PART=/dev/vda2; AUTO_SWAP_PART=""
      VERIFY_HOME=1; VERIFY_SWAP=0; VERIFY_SUBVOL=0
      ;;
    btrfs-subvol)
      DISK_LAYOUT=$'label: dos\n,18G,L\n,,L\n'
      AUTO_FS=btrfs;    AUTO_HOME=1; AUTO_SWAP=0; AUTO_SUBVOL=1
      AUTO_ROOT_PART=/dev/vda1; AUTO_HOME_PART=/dev/vda2; AUTO_SWAP_PART=""
      VERIFY_HOME=1; VERIFY_SWAP=0; VERIFY_SUBVOL=1
      ;;
    btrfs-subvol-flat)
      DISK_LAYOUT=$'label: dos\n,,L\n'
      AUTO_FS=btrfs;    AUTO_HOME=0; AUTO_SWAP=0; AUTO_SUBVOL=1
      AUTO_ROOT_PART=/dev/vda1; AUTO_HOME_PART="";    AUTO_SWAP_PART=""
      VERIFY_HOME=0; VERIFY_SWAP=0; VERIFY_SUBVOL=1
      ;;
    xfs-home)
      # MBR: 1G ext4 /boot + 16G xfs root + rest xfs home
      # BIOS+XFS requires separate ext4 /boot (GRUB can't read modern XFS)
      DISK_LAYOUT=$'label: dos\n,1G,L\n,16G,L\n,,L\n'
      AUTO_FS=xfs;      AUTO_HOME=1; AUTO_SWAP=0; AUTO_SUBVOL=0
      AUTO_BOOT_PART=/dev/vda1; AUTO_ROOT_PART=/dev/vda2; AUTO_HOME_PART=/dev/vda3; AUTO_SWAP_PART=""
      VERIFY_HOME=1; VERIFY_SWAP=0; VERIFY_SUBVOL=0; VERIFY_BOOT=1
      ;;
    gpt-btrfs-bios-home)
      # GPT + 1M BIOS boot + 18G btrfs root + rest btrfs home (BIOS, no subvols)
      # Reproduces user's bootloader bug, but with proper BIOS boot part.
      DISK_LAYOUT=$'label: gpt\n,1M,21686148-6449-6E6F-744E-656564454649\n,18G,L\n,,L\n'
      AUTO_FS=btrfs;    AUTO_HOME=1; AUTO_SWAP=0; AUTO_SUBVOL=0
      AUTO_ROOT_PART=/dev/vda2; AUTO_HOME_PART=/dev/vda3; AUTO_SWAP_PART=""
      VERIFY_HOME=1; VERIFY_SWAP=0; VERIFY_SUBVOL=0
      ;;
    gpt-auto-btrfs-subvol-bios-home)
      # Blank disk nixinstall's auto_partition creates:
      #   GPT + 1M BIOS boot + 12G btrfs root (subvol @/@nix) + rest btrfs home
      # Tests the NIXINSTALL_AUTO_PARTITION=1 code path (20G disk).
      DISK_LAYOUT=""
      AUTO_FS=btrfs;    AUTO_HOME=1; AUTO_SWAP=0; AUTO_SUBVOL=1
      AUTO_PARTITION=1; AUTO_LABEL=gpt; AUTO_ROOT_SIZE=12G
      # partition paths are auto-set by auto_partition (exported)
      VERIFY_HOME=1; VERIFY_SWAP=0; VERIFY_SUBVOL=1
      ;;
    *) die "unknown combo: $COMBO (available: $COMBOS)" ;;
  esac
}

safety_check() {
  [ "$(id -u)" -eq 0 ] && die "refuse to run as root"
  case "$TEST_ROOT" in /tmp/opencode/tier2) : ;; *) die "TEST_ROOT must be /tmp/opencode/tier2" ;; esac
  if [ -z "$ISO" ]; then
    ISO=$(ls -t "$HOME"/downloads/nixinjarISO-minimal-*.iso 2>/dev/null | head -1 || true)
  fi
  [ -f "$ISO" ] || die "ISO not found: $ISO (rebuild it with resjar/nixbin/buildiso.sh)"
  command -v qemu-system-x86_64 >/dev/null || die "qemu-system-x86_64 not found"
  [ -e /dev/kvm ] || die "/dev/kvm missing (no KVM)"
  [ -r "$VMPTY" ] || die "vmpty.py not found: $VMPTY"
}

ensure_kernel() {
  if [ -f "$KERNEL" ] && [ -f "$INITRD" ]; then return 0; fi
  echo "== extracting kernel/initrd from ISO =="
  # NOTE: TEST_ROOT must already exist (mkdir -p in main) if xorriso has to
  # create it, it inherits the ISO's read-only dir perms and later extracts fail.
  nix shell 'nixpkgs#xorriso' -c xorriso -osirrox on -indev "$ISO" \
    -extract /EFI/BOOT/grub.cfg "$GRUB_CFG" \
    || die "xorriso: could not extract grub.cfg from $ISO"
  local linux_line kernel_path initrd_path
  linux_line=$(grep -m1 '^  linux ' "$GRUB_CFG")
  kernel_path=$(printf '%s' "$linux_line" | awk '{print $2}' | sed 's#//*#/#g')
  initrd_path=$(grep -m1 '^  initrd ' "$GRUB_CFG" | awk '{print $2}' | sed 's#//*#/#g')
  [ -n "$kernel_path" ] && [ -n "$initrd_path" ] || die "could not parse grub.cfg"
  nix shell 'nixpkgs#xorriso' -c xorriso -osirrox on -indev "$ISO" \
    -extract "$kernel_path" "$KERNEL" \
    || die "xorriso: could not extract kernel from $ISO"
  nix shell 'nixpkgs#xorriso' -c xorriso -osirrox on -indev "$ISO" \
    -extract "$initrd_path" "$INITRD" \
    || die "xorriso: could not extract initrd from $ISO"
  chmod u+w "$KERNEL" "$INITRD" "$GRUB_CFG"
}

append_cmdline() {
  # Build the kernel cmdline from the ISO's grub.cfg: strip the kernel path and
  # ${isoboot}, then append our serial console.
  local line rest
  line=$(grep -m1 '^  linux ' "$GRUB_CFG")
  rest=$(printf '%s' "$line" | sed -E 's/^  linux \S+ //; s/\$\{isoboot\}//')
  printf '%s console=ttyS0,115200n8' "$rest"
}

make_disk() {
  echo "== creating disk $DISK (combo: $COMBO) =="
  rm -f "$DISK"
  truncate -s 20G "$DISK"
  if [ -n "$DISK_LAYOUT" ]; then
    echo "== pre-partitioning $DISK =="
    printf '%s' "$DISK_LAYOUT" | sfdisk "$DISK" >/dev/null 2>&1
  else
    echo "== leaving $DISK blank (auto_partition will partition it) =="
  fi
}

gen_key() {
  [ -f "$KEY" ] || ssh-keygen -t ed25519 -f "$KEY" -N '' -C tier2-test -q
  PUBKEY=$(cat "$KEY.pub")
}

gen_provision_drv() {
  cat > "$TEST_ROOT/provision.drv" <<EOF
# auto-generated: provision the live VM (ssh pubkey for nixos user)
wait recovery:~\]\\\$
send export TERM=xterm-256color; stty rows 50 cols 160\r
wait recovery:~\]\\\$
send mkdir -p ~/.ssh && echo '$PUBKEY' >> ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys; echo P1=\$?\r
wait P1=[01]
EOF
}

kill_vm() {
  local p
  p=$(cat "$TEST_ROOT/qemu.pid" 2>/dev/null || true)
  [ -n "$p" ] && kill "$p" 2>/dev/null || true
  wait "$p" 2>/dev/null || true
  rm -f "$SOCK" "$TEST_ROOT/qemu.pid"
}

launch_qemu_live() {
  local append
  append=$(append_cmdline)
  echo "== launching qemu (live ISO, $VMRAM MiB) =="
  qemu-system-x86_64 -machine pc -enable-kvm -cpu host -smp 4 -m "$VMRAM" \
    -kernel "$KERNEL" -initrd "$INITRD" -append "$append" \
    -drive file="$DISK",format=raw,if=virtio -cdrom "$ISO" \
    -netdev user,id=n0,hostfwd=tcp:127.0.0.1:$GUEST_PORT-:22 -device virtio-net-pci,netdev=n0 \
    -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0 \
    -chardev socket,id=chr0,path="$SOCK",server=on,wait=on -serial chardev:chr0 \
    -monitor none -display none -no-reboot -pidfile "$TEST_ROOT/qemu.pid" \
    2>"$TEST_ROOT/qemu.err" &
}

phase_provision() {
  echo "== phase 1: provision ssh (nixos user) =="
  "$PYTHON" "$VMPTY" --socket "$SOCK" --script "$TEST_ROOT/provision.drv" \
    --log "$TEST_ROOT/provision.log" --timeout 120
  grep -q 'P1=0' "$TEST_ROOT/provision.log" \
    || die "provision failed (see $TEST_ROOT/provision.log)"
}

phase_install() {
  echo "== phase 2: run nixinstall Iso Install (auto-mode via SSH, combo: $COMBO) =="
  local proceed="1"
  [ "$SMOKE" -eq 1 ] && proceed="0"

  local auto_env="NIXINSTALL_AUTO=1"
  auto_env+=" NIXINSTALL_AUTO_DISK=vda"
  auto_env+=" NIXINSTALL_AUTO_BOOT=BIOS"
  auto_env+=" NIXINSTALL_AUTO_FS=$AUTO_FS"
  auto_env+=" NIXINSTALL_AUTO_HOME=$AUTO_HOME"
  auto_env+=" NIXINSTALL_AUTO_SWAP=$AUTO_SWAP"
  [ -n "$AUTO_SWAP_SIZE" ] && auto_env+=" NIXINSTALL_AUTO_SWAP_SIZE=$AUTO_SWAP_SIZE"
  auto_env+=" NIXINSTALL_AUTO_SUBVOL=$AUTO_SUBVOL"
  [ -n "$AUTO_PARTITION" ] && auto_env+=" NIXINSTALL_AUTO_PARTITION=$AUTO_PARTITION"
  [ -n "$AUTO_LABEL" ] && auto_env+=" NIXINSTALL_AUTO_LABEL=$AUTO_LABEL"
  [ -n "$AUTO_ROOT_SIZE" ] && auto_env+=" NIXINSTALL_AUTO_ROOT_SIZE=$AUTO_ROOT_SIZE"
  [ -n "$AUTO_ROOT_PART" ] && auto_env+=" NIXINSTALL_AUTO_ROOT_PART=$AUTO_ROOT_PART"
  [ -n "$AUTO_HOME_PART" ] && auto_env+=" NIXINSTALL_AUTO_HOME_PART=$AUTO_HOME_PART"
  [ -n "$AUTO_SWAP_PART" ] && auto_env+=" NIXINSTALL_AUTO_SWAP_PART=$AUTO_SWAP_PART"
  [ -n "$AUTO_BOOT_PART" ] && auto_env+=" NIXINSTALL_AUTO_BOOT_PART=$AUTO_BOOT_PART"
  auto_env+=" NIXINSTALL_AUTO_CFDISK=0"
  auto_env+=" NIXINSTALL_AUTO_READY=1"
  auto_env+=" NIXINSTALL_AUTO_FORMAT=1"
  auto_env+=" NIXINSTALL_AUTO_ERASE=1"
  auto_env+=" NIXINSTALL_AUTO_UNMOUNT=1"
  auto_env+=" NIXINSTALL_AUTO_NETWORK_CONTINUE=1"
  auto_env+=" NIXINSTALL_AUTO_HOSTNAME=$GUEST_HOSTNAME"
  auto_env+=" NIXINSTALL_AUTO_TIMEZONE=Etc/UTC"
  auto_env+=" NIXINSTALL_AUTO_USERNAME=$GUEST_USER"
  auto_env+=" NIXINSTALL_AUTO_PASSWORD=nixinstall-test"
  auto_env+=" NIXINSTALL_AUTO_WHEEL=1"
  auto_env+=" NIXINSTALL_AUTO_SSH=1"
  auto_env+=" NIXINSTALL_AUTO_SSH_KEY='$PUBKEY'"
  auto_env+=" NIXINSTALL_AUTO_REPO=$GUEST_REPO_URL"
  auto_env+=" NIXINSTALL_AUTO_PROCEED=$proceed"
  auto_env+=" NIXINSTALL_AUTO_REBOOT=0"

  set +e
  timeout $([ "$SMOKE" -eq 1 ] && echo 120 || echo 3600) \
    ssh "${SSH_OPTS[@]}" nixos@127.0.0.1 \
    "env $auto_env TERM=xterm-256color nixinstall" \
    2>&1 | tee "$TEST_ROOT/install.log"
  local rc=${PIPESTATUS[0]}
  set -e
  echo "nixinstall rc=$rc"

  if [ "$SMOKE" -eq 1 ]; then
    grep -q 'Cancelled' "$TEST_ROOT/install.log" || \
      die "smoke: nixinstall did not cancel cleanly (see $TEST_ROOT/install.log)"
    echo "== SMOKE OK: auto-mode validated, no nixos-install run =="
    return 0
  fi

  grep -q 'Core NixOS installed successfully' "$TEST_ROOT/install.log" || \
    die "install did not report success (see $TEST_ROOT/install.log)"
}

phase3_boot_verify() {
  echo "== phase 3: boot installed disk + verify (combo: $COMBO) =="
  rm -f "$SOCK" "$TEST_ROOT/qemu.pid"
  qemu-system-x86_64 -machine pc -enable-kvm -cpu host -smp 4 -m "$VMRAM" \
    -drive file="$DISK",format=raw,if=virtio \
    -netdev user,id=n0,hostfwd=tcp:127.0.0.1:$GUEST_PORT-:22 -device virtio-net-pci,netdev=n0 \
    -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0 \
    -serial file:"$TEST_ROOT/serial3.log" \
    -monitor none -display none -no-reboot -pidfile "$TEST_ROOT/qemu.pid" \
    2>"$TEST_ROOT/qemu3.err" &
  trap kill_vm EXIT
  local out
  for _ in $(seq 1 60); do
    if out=$(ssh "${SSH_OPTS[@]}" "$GUEST_USER"@127.0.0.1 \
        'hostname; lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT /dev/vda; df -h / /boot /home /nix 2>/dev/null; swapon --show 2>/dev/null; systemctl is-system-running 2>/dev/null; test -f ~/nix-config/flake.nix && echo HCFG_OK' 2>/dev/null); then
      echo "$out"
      printf '%s\n' "$out" | grep -q "$GUEST_HOSTNAME" || die "hostname mismatch (expected $GUEST_HOSTNAME)"
      # Check root is mounted on some /dev/vd* partition (don't assume vda1 —
      # GPT combos put BIOS boot or ESP on vda1 and root on vda2).
      printf '%s\n' "$out" | grep -qE '^/dev/vd[a-z0-9]+ +[0-9]+.* +[0-9]+% +/$' || die "root / not mounted"
      if [ "$VERIFY_HOME" = 1 ]; then
        printf '%s\n' "$out" | grep -qE '^/dev/vd[a-z0-9]+ +[0-9]+.* +[0-9]+% +/home$' || die "/home not mounted"
      fi
      if [ "$VERIFY_SUBVOL" = 1 ]; then
        printf '%s\n' "$out" | grep -q '/nix' || die "/nix subvol not mounted"
      fi
      if [ "$VERIFY_SWAP" = 1 ]; then
        printf '%s\n' "$out" | grep -q 'swap' || die "swap not active"
      fi
      if [ "$VERIFY_BOOT" = 1 ]; then
        printf '%s\n' "$out" | grep -qE '^/dev/vd[a-z0-9]+ +[0-9]+.* +[0-9]+% +/boot$' || die "/boot not mounted"
      fi
      printf '%s\n' "$out" | grep -q HCFG_OK || die "~/nix-config/flake.nix missing (Step 11 clone failed)"
      echo "TIER2 PASS ($COMBO)"
      return 0
    fi
    sleep 5
  done
  die "phase 3: guest did not answer ssh in time"
}

dry_run() {
  echo "== DRY RUN: qemu would be launched with =="
  echo "  combo:  $COMBO"
  echo "  disk:   $DISK (regular file: $([ -f "$DISK" ] && echo yes || echo no), block: $([ -b "$DISK" ] && echo yes || echo no))"
  echo "  iso:    $ISO"
  echo "  kernel: $KERNEL"
  echo "  initrd: $INITRD"
  echo "  append: $(append_cmdline)"
  echo "  ram:    ${VMRAM}MiB  port: 127.0.0.1:$GUEST_PORT -> guest:22"
  echo "  key:    $KEY"
  echo "  gate checks: uid=$(id -u) TEST_ROOT=$TEST_ROOT kvm=$([ -e /dev/kvm ] && echo yes || echo no)"
  echo "== DRY RUN OK =="
}

main() {
  local parse=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --dry-run) DRY_RUN=1 ;;
      --smoke) SMOKE=1 ;;
      --combo) COMBO="$2"; shift ;;
      -h|--help)
        echo "usage: $0 [--dry-run] [--smoke] [--combo NAME]"
        echo ""
        echo "available combos: $COMBOS"
        exit 0 ;;
      *) die "unknown arg: $1" ;;
    esac
    shift
  done
  load_combo
  mkdir -p "$TEST_ROOT"
  safety_check
  ensure_kernel
  gen_key
  gen_provision_drv
  make_disk
  [ "$DRY_RUN" -eq 1 ] && { dry_run; exit 0; }
  launch_qemu_live
  trap kill_vm EXIT
  phase_provision
  phase_install
  if [ "$SMOKE" -eq 1 ]; then kill_vm; trap - EXIT; exit 0; fi
  kill_vm; trap - EXIT
  phase3_boot_verify
  kill_vm; trap - EXIT
}

main "$@"
