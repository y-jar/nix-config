#!/usr/bin/env bash
# testvm.sh — Tier 2: drive the real resjar/nixbin/install.sh inside a
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
# Driver scripts + logs are written under $TEST_ROOT; the install is driven
# via SSH using install.sh's INSTALLJAR_AUTO env-var mode (no serial pty).
set -euo pipefail

TEST_ROOT="/tmp/opencode/tier2"
ISO="${ISO:-$HOME/downloads/nixos-minimal-26.05.20260719.fd14620-x86_64-linux.iso}"
REPO="${REPO:-/home/jar/nix-config}"
NIXBIN="$REPO/resjar/nixbin"
VMPTY="$NIXBIN/vmpty.py"
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
VERIFY_HOME=""
VERIFY_SWAP=""
VERIFY_SUBVOL=""

COMBOS="ext4-home ext4-flat ext4-home-swap btrfs-home btrfs-subvol btrfs-subvol-flat xfs-home"

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
      DISK_LAYOUT=$'label: dos\n,18G,L\n,,L\n'
      AUTO_FS=xfs;      AUTO_HOME=1; AUTO_SWAP=0; AUTO_SUBVOL=0
      AUTO_ROOT_PART=/dev/vda1; AUTO_HOME_PART=/dev/vda2; AUTO_SWAP_PART=""
      VERIFY_HOME=1; VERIFY_SWAP=0; VERIFY_SUBVOL=0
      ;;
    *) die "unknown combo: $COMBO (available: $COMBOS)" ;;
  esac
}

safety_check() {
  [ "$(id -u)" -eq 0 ] && die "refuse to run as root"
  case "$TEST_ROOT" in /tmp/opencode/tier2) : ;; *) die "TEST_ROOT must be /tmp/opencode/tier2" ;; esac
  [ -f "$ISO" ] || die "ISO not found: $ISO"
  command -v qemu-system-x86_64 >/dev/null || die "qemu-system-x86_64 not found"
  [ -e /dev/kvm ] || die "/dev/kvm missing (no KVM)"
  [ -r "$VMPTY" ] || die "vmpty.py not found: $VMPTY"
}

ensure_kernel() {
  if [ -f "$KERNEL" ] && [ -f "$INITRD" ]; then return 0; fi
  echo "== extracting kernel/initrd from ISO =="
  nix shell 'nixpkgs#xorriso' -c xorriso -osirrox on -indev "$ISO" \
    -extract /EFI/BOOT/grub.cfg "$GRUB_CFG" 2>/dev/null
  local linux_line kernel_path initrd_path
  linux_line=$(grep -m1 '^  linux ' "$GRUB_CFG")
  kernel_path=$(printf '%s' "$linux_line" | awk '{print $2}' | sed 's#//*#/#g')
  initrd_path=$(grep -m1 '^  initrd ' "$GRUB_CFG" | awk '{print $2}' | sed 's#//*#/#g')
  [ -n "$kernel_path" ] && [ -n "$initrd_path" ] || die "could not parse grub.cfg"
  nix shell 'nixpkgs#xorriso' -c xorriso -osirrox on -indev "$ISO" \
    -extract "$kernel_path" "$KERNEL" 2>/dev/null
  nix shell 'nixpkgs#xorriso' -c xorriso -osirrox on -indev "$ISO" \
    -extract "$initrd_path" "$INITRD" 2>/dev/null
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
  echo "== creating + pre-partitioning $DISK (combo: $COMBO) =="
  rm -f "$DISK"
  truncate -s 20G "$DISK"
  printf '%s' "$DISK_LAYOUT" | sfdisk "$DISK" >/dev/null 2>&1
}

gen_key() {
  [ -f "$KEY" ] || ssh-keygen -t ed25519 -f "$KEY" -N '' -C tier2-test -q
  PUBKEY=$(cat "$KEY.pub")
}

gen_overlay() {
  echo "== generating guest overlay (tier2test host) =="
  local d="$TEST_ROOT/overlay/hstjar/tier2test"
  mkdir -p "$d"
  cat > "$d/default.nix" <<'EOF'
{ ... }: { imports = [ ./system.nix ./hardware-configuration.nix ]; }
EOF
  cat > "$d/system.nix" <<EOF
{ config, lib, pkgs, ... }:
{
  options.isInVM = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Set true when this host runs in a VM (installjar uses the portable hardware config).";
  };
  config = {
    isInVM = true;
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/vda";
    boot.loader.grub.useOSProber = false;
    networking.hostName = "tier2test";
    networking.networkmanager.enable = true;
    systemd.services."serial-getty@ttyS0".enable = true;
    services.getty.autologinUser = "test";
    users.users.test = {
      isNormalUser = true;
      password = "installjar-test";
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = [ "$PUBKEY" ];
    };
    users.users.root.openssh.authorizedKeys.keys = [ "$PUBKEY" ];
    services.openssh.enable = true;
    services.openssh.settings.PasswordAuthentication = true;
    services.openssh.settings.PermitRootLogin = "yes";
    environment.systemPackages = with pkgs; [ vim ];
    system.stateVersion = "26.05";
  };
}
EOF
  cat > "$d/hardware-configuration.nix" <<'EOF'
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_blk" "virtio_net" "ahci" "ata_piix" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  fileSystems."/" = { device = "/dev/vda1"; fsType = "ext4"; };
  fileSystems."/home" = { device = "/dev/vda2"; fsType = "ext4"; };
  swapDevices = [ ];
}
EOF
  cp "$REPO/flake.nix" "$TEST_ROOT/flake.patched.nix"
  sed -i '/vmjar = mkJar "vmjar";/a\        tier2test = nixpkgs.lib.nixosSystem { system = "x86_64-linux"; modules = [ ./hstjar/tier2test ]; };' "$TEST_ROOT/flake.patched.nix"
}

gen_provision_drv() {
  cat > "$TEST_ROOT/provision.drv" <<EOF
# auto-generated: provision the live VM (root password + ssh pubkey)
wait recovery:~\]\\\$ 
send export TERM=xterm-256color; stty rows 50 cols 160\r
wait recovery:~\]\\\$ 
send echo 'root:installjar-test' | sudo chpasswd; echo P1=\$?\r
wait P1=[01]
send sudo mkdir -p /root/.ssh && echo '$PUBKEY' | sudo tee -a /root/.ssh/authorized_keys >/dev/null && sudo chmod 700 /root/.ssh && sudo chmod 600 /root/.ssh/authorized_keys; echo P2=\$?\r
wait P2=[01]
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
  echo "== phase 1: provision ssh =="
  "$PYTHON" "$VMPTY" --socket "$SOCK" --script "$TEST_ROOT/provision.drv" \
    --log "$TEST_ROOT/provision.log" --timeout 120
  grep -q 'P1=0' "$TEST_ROOT/provision.log" && grep -q 'P2=0' "$TEST_ROOT/provision.log" \
    || die "provision failed (see $TEST_ROOT/provision.log)"
}

push_tree() {
  echo "== pushing working tree + overlay into guest =="
  set +e
  tar cz -C "$REPO" --exclude=./.git --exclude=./.rotjar . | \
    timeout 120 ssh "${SSH_OPTS[@]}" root@127.0.0.1 \
      'rm -rf /tmp/tree && mkdir -p /tmp/tree && tar xz -C /tmp/tree && echo TREE_DONE'
  [ "${PIPESTATUS[1]:-$?}" = 0 ] || { set -e; die "tree push failed"; }
  tar cz -C "$TEST_ROOT/overlay" hstjar | \
    timeout 60 ssh "${SSH_OPTS[@]}" root@127.0.0.1 'tar xz -C /tmp/tree && echo OVERLAY_DONE'
  [ "${PIPESTATUS[1]:-$?}" = 0 ] || { set -e; die "overlay push failed"; }
  timeout 60 scp -i "$KEY" -P "$GUEST_PORT" -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null -o PasswordAuthentication=no \
    "$TEST_ROOT/flake.patched.nix" root@127.0.0.1:/tmp/tree/flake.nix 2>/dev/null
  [ $? = 0 ] || { set -e; die "flake scp failed"; }
  set -e
  local v
  v=$(timeout 30 ssh "${SSH_OPTS[@]}" root@127.0.0.1 \
    'test -f /tmp/tree/flake.nix && test -f /tmp/tree/flake.lock && test -d /tmp/tree/hstjar/tier2test && grep -q tier2test /tmp/tree/flake.nix && echo PUSH_OK' 2>/dev/null) \
    || die "push_tree verify cmd failed"
  printf '%s\n' "$v" | grep -q PUSH_OK || die "push_tree verification failed (flake/overlay not in place)"
}

phase_install() {
  echo "== phase 2: run install.sh (auto-mode via SSH, combo: $COMBO) =="

  local proceed="1"
  [ "$SMOKE" -eq 1 ] && proceed="0"

  local auto_env="INSTALLJAR_AUTO=1"
  auto_env+=" INSTALLJAR_AUTO_DISK=vda"
  auto_env+=" INSTALLJAR_AUTO_BOOT=BIOS"
  auto_env+=" INSTALLJAR_AUTO_FS=$AUTO_FS"
  auto_env+=" INSTALLJAR_AUTO_HOME=$AUTO_HOME"
  auto_env+=" INSTALLJAR_AUTO_SWAP=$AUTO_SWAP"
  [ -n "$AUTO_SWAP_SIZE" ] && auto_env+=" INSTALLJAR_AUTO_SWAP_SIZE=$AUTO_SWAP_SIZE"
  auto_env+=" INSTALLJAR_AUTO_SUBVOL=$AUTO_SUBVOL"
  auto_env+=" INSTALLJAR_AUTO_CFDISK=0"
  auto_env+=" INSTALLJAR_AUTO_READY=1"
  auto_env+=" INSTALLJAR_AUTO_ROOT_PART=$AUTO_ROOT_PART"
  [ -n "$AUTO_HOME_PART" ] && auto_env+=" INSTALLJAR_AUTO_HOME_PART=$AUTO_HOME_PART"
  [ -n "$AUTO_SWAP_PART" ] && auto_env+=" INSTALLJAR_AUTO_SWAP_PART=$AUTO_SWAP_PART"
  auto_env+=" INSTALLJAR_AUTO_FORMAT=1"
  auto_env+=" INSTALLJAR_AUTO_ERASE=1"
  auto_env+=" INSTALLJAR_AUTO_UNMOUNT=1"
  auto_env+=" INSTALLJAR_AUTO_NETWORK_CONTINUE=1"
  auto_env+=" INSTALLJAR_AUTO_REPO="
  auto_env+=" INSTALLJAR_AUTO_HOST=tier2test"
  auto_env+=" INSTALLJAR_AUTO_PROCEED=$proceed"
  auto_env+=" INSTALLJAR_AUTO_ROOT_PASS="
  auto_env+=" INSTALLJAR_AUTO_REBOOT=0"

  set +e
  timeout $([ "$SMOKE" -eq 1 ] && echo 120 || echo 5400) \
    ssh "${SSH_OPTS[@]}" root@127.0.0.1 \
    "cd /tmp/tree && sudo env $auto_env CLONE_DIR=/tmp/tree TERM=xterm-256color bash ./resjar/nixbin/install.sh" \
    2>&1 | tee "$TEST_ROOT/install.log"
  local rc=${PIPESTATUS[0]}
  set -e
  echo "install.sh rc=$rc"

  if [ "$SMOKE" -eq 1 ]; then
    grep -q 'Cancelled' "$TEST_ROOT/install.log" || \
      die "smoke: install.sh did not cancel cleanly (see $TEST_ROOT/install.log)"
    echo "== SMOKE OK: auto-mode validated, no nixos-install run =="
    return 0
  fi

  grep -q 'NixOS installed successfully' "$TEST_ROOT/install.log" || \
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
    if out=$(ssh "${SSH_OPTS[@]}" root@127.0.0.1 \
        'hostname; lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT /dev/vda; df -h / /home /nix 2>/dev/null; swapon --show 2>/dev/null; systemctl is-system-running 2>/dev/null' 2>/dev/null); then
      echo "$out"
      printf '%s\n' "$out" | grep -q tier2test || die "hostname mismatch"
      printf '%s\n' "$out" | grep -q '/dev/vda1' || die "vda1 not mounted"
      if [ "$VERIFY_HOME" = 1 ] && [ "$VERIFY_SUBVOL" = 0 ]; then
        printf '%s\n' "$out" | grep -q '/dev/vda2' || die "vda2 (home) not mounted"
      fi
      if [ "$VERIFY_SUBVOL" = 1 ]; then
        printf '%s\n' "$out" | grep -q '/nix' || die "/nix subvol not mounted"
      fi
      if [ "$VERIFY_SWAP" = 1 ]; then
        printf '%s\n' "$out" | grep -q 'swap' || die "swap not active"
      fi
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
  safety_check
  ensure_kernel
  gen_key
  gen_overlay
  gen_provision_drv
  make_disk
  [ "$DRY_RUN" -eq 1 ] && { dry_run; exit 0; }
  launch_qemu_live
  trap kill_vm EXIT
  phase_provision
  push_tree
  phase_install
  if [ "$SMOKE" -eq 1 ]; then kill_vm; trap - EXIT; exit 0; fi
  kill_vm; trap - EXIT
  phase3_boot_verify
  kill_vm; trap - EXIT
  rm -rf "$TEST_ROOT/overlay"
}

main "$@"