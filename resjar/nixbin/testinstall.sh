#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  testinstall.sh — Tier 1 logic tests for install.sh
#  NOTE: these tests are run by an AI/LLM during development.
#  They are NOT part of the installer and never ship in the ISO.
#  Run with:  ./resjar/nixbin/testinstall.sh
#
#  Covers: pick_part parsing (IFS regression), dedup, manual +
#  "None (skip)" paths, device placeholders, gen_vm_hardware_config
#  output parsing, and full stubbed iso_install() runs through
#  every step (format -> mount -> clone -> install -> passwords).
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

PASS=0
FAIL=0

pass() { PASS=$((PASS + 1)); printf '  PASS  %s\n' "$1"; }
fail() { FAIL=$((FAIL + 1)); printf '  FAIL  %s\n' "$1"; }
assert_eq() { # expected actual label
    if [ "$2" = "$1" ]; then
        pass "$3"
    else
        fail "$3 (expected '$1' got '$2')"
    fi
}
assert_contains() { # needle file label
    if grep -qF -- "$1" "$2" 2>/dev/null; then
        pass "$3"
    else
        fail "$3 (missing '$1' in $2)"
    fi
}

# ──[build stub binaries]
STUB_BIN="$TEST_DIR/bin"
STUB_DIR="$TEST_DIR/stubs"
mkdir -p "$STUB_BIN" "$STUB_DIR"

cat > "$STUB_BIN/gum" <<'GUM'
#!/usr/bin/env bash
read_consume() { [ -s "$1" ] && { head -n1 "$1"; sed -i "1d" "$1"; }; }
case "$1" in
    choose)
        shift
        cat > "$STUB_DIR/last_options" 2>/dev/null || true
        read_consume "$STUB_DIR/choose"
        ;;
    confirm)
        ans=$(read_consume "$STUB_DIR/confirms")
        [ "$ans" = "1" ]
        ;;
    input)
        printf 'input %s\n' "$*" >> "$STUB_DIR/input_args"
        read_consume "$STUB_DIR/inputs"
        ;;
    spin)
        shift
        while [ "$1" != "--" ] && [ $# -gt 0 ]; do shift; done
        shift
        "$@" 2>&1
        exit $?
        ;;
    log)
        shift; shift
        printf 'LOG %s\n' "$*" >&2
        exit 0
        ;;
    *)
        exit 0
        ;;
esac
GUM
chmod +x "$STUB_BIN/gum"

cat > "$STUB_BIN/lsblk" <<'LSBLK'
#!/usr/bin/env bash
case "$*" in
    *-rno*) cat "$STUB_DIR/lsblk_parts" ;;
    *-ndo*) cat "$STUB_DIR/lsblk_disks" ;;
    *)      cat "$STUB_DIR/lsblk_display" ;;
esac
LSBLK
chmod +x "$STUB_BIN/lsblk"

cat > "$STUB_BIN/fzf" <<'FZF'
#!/usr/bin/env bash
read_consume() { [ -s "$1" ] && { head -n1 "$1"; sed -i "1d" "$1"; }; }
cat > "$STUB_DIR/last_fzf" 2>/dev/null || true
read_consume "$STUB_DIR/fzf"
FZF
chmod +x "$STUB_BIN/fzf"

cat > "$STUB_BIN/git" <<'GIT'
#!/usr/bin/env bash
# Handle git subcommands: only `clone` is meaningful; `add`/etc are no-ops
case "$1" in
  clone)
    url="$2"; dir="$3"
    mkdir -p "$dir/hstjar/vmhost" "$dir/hstjar/0_TEMPLATE"
cat > "$dir/flake.nix" <<'FLAKE'
{
  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
        # TEMPLATE = mkJar "TEMPLATE";
        # ===[INSTALLER: append new hosts on the line below]===
        vmhost = nixpkgs.lib.nixosSystem { system = "x86_64-linux"; modules = [ ./hstjar/vmhost ]; };
    };
  };
}
FLAKE
printf 'sysSettings.virt.isInVM = true;\nmainUser = "mainuser";\n' > "$dir/hstjar/vmhost/system.nix"
printf '{}\n' > "$dir/hstjar/vmhost/home.nix"
printf '{}\n' > "$dir/hstjar/vmhost/boot.nix"
printf '{}\n' > "$dir/hstjar/0_TEMPLATE/default.nix"
cat > "$dir/hstjar/0_TEMPLATE/system.nix" <<'TPL'
{ config, lib, ... }: {
  config = {
    system.stateVersion = "VersionNumber";
    sysSettings = {
      mainUser = "PLEASECHANGEME_USERNAME";
      users = [ "PLEASECHANGEME_USERNAME" ];
    };
  };
}
TPL
printf 'git clone %s %s\n' "$url" "$dir" > "$STUB_DIR/git.log"
    ;;
  add|commit|status|diff|log|push|pull)
    exit 0
    ;;
  *)
    exit 0
    ;;
esac
GIT
chmod +x "$STUB_BIN/git"

cat > "$STUB_BIN/nixos-install" <<'NI'
#!/usr/bin/env bash
printf 'nixos-install %s\n' "$*" > "$STUB_DIR/nixos_install.log"
exit 0
NI
chmod +x "$STUB_BIN/nixos-install"

cat > "$STUB_BIN/nixos-enter" <<'NE'
#!/usr/bin/env bash
cat >> "$STUB_DIR/chpasswd.log"
exit 0
NE
chmod +x "$STUB_BIN/nixos-enter"

cat > "$STUB_BIN/sudo" <<'SUDO'
#!/usr/bin/env bash
# Deny-list: these MUST never run on the host during a test, even if a
# flow reaches them. Everything else is passed through ONLY because it is
# already shadowed by a no-op/fixture stub earlier in the test PATH.
deny=' reboot poweroff shutdown halt cfdisk fdisk sfdisk parted dd rm mv rmdir '
first="$1"
[ -z "$first" ] && exit 0
if case "$deny" in *" $first "*) true ;; *) false ;; esac; then
    printf 'BLOCKED: sudo %s\n' "$*" >> "$STUB_DIR/sudo.log"
    printf 'BLOCKED: sudo %s\n' "$*" >&2
    exit 1
fi
"$@"
SUDO
chmod +x "$STUB_BIN/sudo"

for c in mkfs.fat mkfs.ext4 mkfs.btrfs mkfs.xfs mkswap mount umount btrfs swapon ping \
         reboot poweroff shutdown halt cfdisk fdisk sfdisk parted dd; do
    printf '#!/usr/bin/env bash\nexit 0\n' > "$STUB_BIN/$c"
    chmod +x "$STUB_BIN/$c"
done
printf '#!/usr/bin/env bash\nexit 1\n' > "$STUB_BIN/mountpoint"
chmod +x "$STUB_BIN/mountpoint"

# nixos-version stub (so do_new_host stateVersion detection doesn't crash)
printf '#!/usr/bin/env bash\necho "26.05"\n' > "$STUB_BIN/nixos-version"
chmod +x "$STUB_BIN/nixos-version"

export PATH="$STUB_BIN:$PATH"
export STUB_DIR
export INSTALLJAR_SKIP_DEV_CHECK=1

: > "$STUB_DIR/sudo.log"

# ──[loud safety banner]
echo "──────────────────────────────────────────────────────────"
echo " TEST MODE: destructive commands are stubbed/no-ops."
echo " sudo deny-list blocks: reboot, poweroff, shutdown, halt,"
echo "   cfdisk, fdisk, sfdisk, parted, dd, rm, mv."
echo " If any BLOCKED command is attempted, the suite FAILS."
echo "──────────────────────────────────────────────────────────"

# ──[load install.sh (guard prevents main() from running)]
source "$SCRIPT_DIR/install.sh"

# ═══════════════════════════════════════════════════════════════
echo "== pick_part: parsing (IFS regression) =="
printf 'vda    40G\nvda1   512M\nvda2   39.5G\nvda3   2G\n' > "$STUB_DIR/lsblk_parts"
printf '/dev/vda2 | 39.5G\n' > "$STUB_DIR/choose"
assert_eq "/dev/vda2" "$(pick_part /dev/vda "Root partition" "required" "")" "unformatted 3-col line -> clean /dev/vda2"

printf 'vda    40G\nvda1   512M vfat\nvda2   39.5G linux\n' > "$STUB_DIR/lsblk_parts"
printf '/dev/vda2 | 39.5G | linux\n' > "$STUB_DIR/choose"
assert_eq "/dev/vda2" "$(pick_part /dev/vda "Root partition" "required" "")" "formatted 3-col line (fstype) -> /dev/vda2"

# ═══════════════════════════════════════════════════════════════
echo "== pick_part: chosen-part dedup =="
printf 'vda    40G\nvda1   512M\nvda2   39.5G\n' > "$STUB_DIR/lsblk_parts"
printf '/dev/vda2 | 39.5G\n' > "$STUB_DIR/choose"
pick_part /dev/vda "Root partition" "required" $'/dev/vda1' >/dev/null
if grep -qF '/dev/vda1' "$STUB_DIR/last_options"; then
    fail "chosen /dev/vda1 still offered in dropdown"
else
    pass "chosen /dev/vda1 excluded from dropdown options"
fi

# ═══════════════════════════════════════════════════════════════
echo "== pick_part: manual entry =="
printf 'vda    40G\nvda1   512M\n' > "$STUB_DIR/lsblk_parts"
printf 'Type manually...\n' > "$STUB_DIR/choose"
printf '/dev/vda2\n' > "$STUB_DIR/inputs"
assert_eq "/dev/vda2" "$(pick_part /dev/vda "Root partition" "required" "")" "manual entry /dev/vda2"

# ═══════════════════════════════════════════════════════════════
echo "== pick_part: None (skip) for optional =="
printf 'vda    40G\nvda1   512M\n' > "$STUB_DIR/lsblk_parts"
printf 'None (skip)\n' > "$STUB_DIR/choose"
assert_eq "" "$(pick_part /dev/vda "Swap partition (or skip)" "optional" "")" "None (skip) -> empty"

# ═══════════════════════════════════════════════════════════════
echo "== pick_part: device placeholders =="
printf 'nvme0n1    1T\nnvme0n1p1  512M\n' > "$STUB_DIR/lsblk_parts"
printf 'Type manually...\n' > "$STUB_DIR/choose"
printf '\n' > "$STUB_DIR/inputs"
: > "$STUB_DIR/input_args"
pick_part /dev/nvme0n1 "EFI boot partition" "required" "" >/dev/null
assert_contains "nvme0n1p1" "$STUB_DIR/input_args" "nvme p-suffix placeholder (/dev/nvme0n1p1)"
printf 'vda    40G\nvda1   512M\n' > "$STUB_DIR/lsblk_parts"
printf 'Type manually...\n' > "$STUB_DIR/choose"
printf '\n' > "$STUB_DIR/inputs"
pick_part /dev/vda "EFI boot partition" "required" "" >/dev/null
assert_contains "/dev/vda1" "$STUB_DIR/input_args" "vda placeholder (/dev/vda1)"
printf 'nvme0n1    1T\nnvme0n1p1  512M\n' > "$STUB_DIR/lsblk_parts"
printf 'Type manually...\n' > "$STUB_DIR/choose"
printf '/dev/nvme0n1p1\n' > "$STUB_DIR/inputs"
assert_eq "/dev/nvme0n1p1" "$(pick_part /dev/nvme0n1 "EFI boot partition" "required" "")" "manual nvme entry"

# ═══════════════════════════════════════════════════════════════
echo "== gen_vm_hardware_config: parses as Nix =="
if command -v nix-instantiate &>/dev/null; then
    for combo in "btrfs true false" "btrfs true true" "ext4 false true"; do
        set -- $combo
        gen_vm_hardware_config "$1" "$2" "$3" /dev/vda1 /dev/vda2 /dev/vda3 /dev/vda4 > "$TEST_DIR/hw.nix"
        if nix-instantiate --parse "$TEST_DIR/hw.nix" >/dev/null 2>&1; then
            pass "hardware config parses ($1 subvols=$2 sepHome=$3)"
        else
            fail "hardware config parse FAILED ($1 subvols=$2 sepHome=$3)"
        fi
    done
else
    echo "  SKIP  nix-instantiate not found"
fi

# ═══════════════════════════════════════════════════════════════
echo "== iso_install: full stubbed run =="

export CLONE_DIR="$TEST_DIR/clone"

# fixture: host is UEFI or BIOS?
if [ -d /sys/firmware/efi ]; then BOOT_MODE=UEFI; else BOOT_MODE=BIOS; fi

seed_iso() { # home_choice home_inputs
    printf 'vda 40G disk\n' > "$STUB_DIR/lsblk_disks"
    printf 'vda    40G\nvda1   512M\nvda2   39.5G\nvda3   2G\n' > "$STUB_DIR/lsblk_parts"
    printf 'NAME   SIZE FSTYPE MOUNTPOINT\nvda    40G\nvda1   512M\nvda2   39.5G\nvda3   2G\n' > "$STUB_DIR/lsblk_display"

    {
        printf 'Use detected (%s)\n' "$BOOT_MODE"
        printf 'ext4\n'
        if [ "$BOOT_MODE" = "UEFI" ]; then
            printf '/dev/vda1 | 512M\n'
            printf '/dev/vda2 | 39.5G\n'
        else
            printf '/dev/vda1 | 512M\n'
        fi
        printf '%s\n' "$1"
    } > "$STUB_DIR/choose"

    {
        printf '1\n'   # This will ERASE data on $target_disk. Continue? -> yes
        printf '1\n'   # Separate /home partition? -> yes
        printf '0\n'   # Swap partition? -> no
        printf '0\n'   # Run cfdisk now? -> no
        printf '1\n'   # Ready to continue after partitioning? -> yes
        printf '1\n'   # Format these partitions? -> yes
        printf '1\n'   # Proceed with installation? -> yes
        printf '0\n'   # Unmount and reboot now? -> no
    } > "$STUB_DIR/confirms"

    printf 'https://github.com/y-jar/nix-config.git\n' > "$STUB_DIR/inputs"
    printf '%s\n' "$2" >> "$STUB_DIR/inputs"

    printf '/dev/vda | 40G\n' > "$STUB_DIR/fzf"
    printf 'vmhost\n' >> "$STUB_DIR/fzf"

    : > "$STUB_DIR/chpasswd.log"
    : > "$STUB_DIR/nixos_install.log"
    rm -rf "$CLONE_DIR"
}

# seed_auto: sets up all INSTALLJAR_AUTO_* env vars for a non-interactive run.
# Uses UEFI+ext4+separate-home (matching the lsblk_parts fixture vda1/vda2/vda3).
# Caller must `unset Auto` before re-running to avoid env leakage.
seed_auto() {
    export INSTALLJAR_AUTO=1
    export INSTALLJAR_AUTO_DISK=vda
    export INSTALLJAR_AUTO_ERASE=1
    export INSTALLJAR_AUTO_BOOT="$BOOT_MODE"
    export INSTALLJAR_AUTO_FS=ext4
    export INSTALLJAR_AUTO_HOME=1
    export INSTALLJAR_AUTO_SWAP=0
    export INSTALLJAR_AUTO_CFDISK=0
    export INSTALLJAR_AUTO_READY=1
    export INSTALLJAR_AUTO_FORMAT=1
    export INSTALLJAR_AUTO_PROCEED=1
    export INSTALLJAR_AUTO_REBOOT=0
    export INSTALLJAR_AUTO_ROOT_PASS=rootpass123
    export INSTALLJAR_AUTO_REPO=https://github.com/y-jar/nix-config.git
    export INSTALLJAR_AUTO_BOOT_PART=/dev/vda1
    export INSTALLJAR_AUTO_ROOT_PART=/dev/vda2
    export INSTALLJAR_AUTO_HOME_PART=/dev/vda3
    printf 'vda 40G disk\n' > "$STUB_DIR/lsblk_disks"
    printf 'vda    40G\nvda1   512M\nvda2   39.5G\nvda3   2G\n' > "$STUB_DIR/lsblk_parts"
    printf 'NAME   SIZE FSTYPE MOUNTPOINT\nvda    40G\nvda1   512M\nvda2   39.5G\nvda3   2G\n' > "$STUB_DIR/lsblk_display"
    : > "$STUB_DIR/chpasswd.log"
    : > "$STUB_DIR/nixos_install.log"
    rm -rf "$CLONE_DIR"
}

# unset_auto: clears all AUTO env vars so subsequent tests run in interactive mode.
unset_auto() {
    unset INSTALLJAR_AUTO \
          INSTALLJAR_AUTO_DISK INSTALLJAR_AUTO_ERASE INSTALLJAR_AUTO_BOOT \
          INSTALLJAR_AUTO_FS INSTALLJAR_AUTO_HOME INSTALLJAR_AUTO_SWAP \
          INSTALLJAR_AUTO_CFDISK INSTALLJAR_AUTO_READY INSTALLJAR_AUTO_FORMAT \
          INSTALLJAR_AUTO_PROCEED INSTALLJAR_AUTO_REBOOT INSTALLJAR_AUTO_ROOT_PASS \
          INSTALLJAR_AUTO_REPO INSTALLJAR_AUTO_BOOT_PART INSTALLJAR_AUTO_ROOT_PART \
          INSTALLJAR_AUTO_HOME_PART INSTALLJAR_AUTO_SWAP_PART \
          INSTALLJAR_AUTO_HOST_ACTION INSTALLJAR_AUTO_NEW_HOST \
          INSTALLJAR_AUTO_MAIN_USER INSTALLJAR_AUTO_HOST \
          INSTALLJAR_AUTO_SUBVOL INSTALLJAR_AUTO_SWAP_SIZE
}

# ---- run A: separate /home on vda3, empty user password -> fallback to root's
seed_iso "/dev/vda3 | 2G" $'rootpass123\n'
if out=$(iso_install 2>&1); then rc=0; else rc=$?; fi
assert_eq "0" "$rc" "iso_install exits 0 (run A)"
if [ "$rc" != "0" ]; then printf '%s\n' "--- iso_install output (run A) ---" "$out"; fi

assert_contains 'device = "/dev/vda2"' "$CLONE_DIR/hstjar/vmhost/hardware-configuration.nix" "VM hardware config uses /dev/vda2"
assert_contains 'fileSystems."/home"' "$CLONE_DIR/hstjar/vmhost/hardware-configuration.nix" "separate /home entry emitted"
assert_contains '"/dev/vda3"' "$CLONE_DIR/hstjar/vmhost/hardware-configuration.nix" "/home points at /dev/vda3"
assert_contains "--show-trace" "$STUB_DIR/nixos_install.log" "nixos-install called with --show-trace"
assert_contains 'mainuser:rootpass123' "$STUB_DIR/chpasswd.log" "empty user pass falls back to root's password"
assert_contains 'root:rootpass123' "$STUB_DIR/chpasswd.log" "root password passed to chpasswd"

# ---- run B: home = None (skip) -> fallback to shared root; user sets own password
seed_iso "None (skip)" $'otherpass\nmyuserpass\n'
if out=$(iso_install 2>&1); then rc=0; else rc=$?; fi
assert_eq "0" "$rc" "iso_install exits 0 (run B)"
if [ "$rc" != "0" ]; then printf '%s\n' "--- iso_install output (run B) ---" "$out"; fi

if grep -qF 'fileSystems."/home"' "$CLONE_DIR/hstjar/vmhost/hardware-configuration.nix"; then
    fail "no /home entry expected after None (skip)"
else
    pass "no /home entry after None (skip) fallback"
fi
assert_contains 'mainuser:myuserpass' "$STUB_DIR/chpasswd.log" "explicit user password used when given"

# ═══════════════════════════════════════════════════════════════
echo "== new host action: scaffold + register flake =="
(
    seed_auto
    export INSTALLJAR_AUTO_HOST_ACTION=new
    export INSTALLJAR_AUTO_NEW_HOST=newtest
    export INSTALLJAR_AUTO_MAIN_USER=newuser
    iso_install 2>&1
)

# Test 1: scaffolding created new host dir from template
if [ -d "$CLONE_DIR/hstjar/newtest" ]; then
    pass "do_new_host: hstjar/newtest/ scaffolded from 0_TEMPLATE"
else
    fail "do_new_host: hstjar/newtest/ missing (scaffold failed)"
fi
assert_contains 'mainUser = "newuser"' "$CLONE_DIR/hstjar/newtest/system.nix" "do_new_host: PLEASECHANGEME_USERNAME replaced with newuser"
assert_contains 'system.stateVersion = "26.05"' "$CLONE_DIR/hstjar/newtest/system.nix" "do_new_host: stateVersion replaced (VersionNumber -> 26.05)"
assert_contains 'newtest = mkJar "newtest"' "$CLONE_DIR/flake.nix" "do_new_host: host registered in flake.nix after marker line"
assert_contains '--show-trace' "$STUB_DIR/nixos_install.log" "do_new_host: nixos-install runs (auto-proceed past Step 11)"

# ═══════════════════════════════════════════════════════════════
echo "== refresh action: regen hardware-config, skip nixos-install =="
(
    seed_auto
    export INSTALLJAR_AUTO_HOST_ACTION=refresh
    export INSTALLJAR_AUTO_HOST=vmhost
    # Stale hardware config to be overwritten
    printf '# STALE\n{ ... }: { }\n' > "$CLONE_DIR/hstjar/vmhost/hardware-configuration.nix"
    out=$(iso_install 2>&1) || true
    printf '%s' "$out" > "$STUB_DIR/refresh_out.log"
)
assert_contains 'device = "/dev/vda2"' "$CLONE_DIR/hstjar/vmhost/hardware-configuration.nix" "do_refresh_hw: refreshed hardware config has new root device"

# Test 1: hardware-config refreshed (should NOT contain "# STALE")
if grep -q 'STALE' "$CLONE_DIR/hstjar/vmhost/hardware-configuration.nix" 2>/dev/null; then
    fail "do_refresh_hw: hardware-configuration.nix still contains STALE marker"
else
    pass "do_refresh_hw: hardware-configuration.nix overwritten with fresh content"
fi

# Test 2: nixos-install was NOT called (refresh-only path aborts before Step 11)
if [ -s "$STUB_DIR/nixos_install.log" ]; then
    fail "do_refresh_hw: nixos-install was called (should abort before Step 11)"
else
    pass "do_refresh_hw: nixos-install NOT called (refresh-only aborts before Step 11)"
fi
assert_contains 'Hardware config refreshed for vmhost' "$STUB_DIR/refresh_out.log" "do_refresh_hw: prints refresh-complete summary"

# ═══════════════════════════════════════════════════════════════
echo "== new_host_action: validates bad host names =="
(
    seed_auto
    export INSTALLJAR_AUTO_HOST_ACTION=new
    export INSTALLJAR_AUTO_NEW_HOST=BadName
    export INSTALLJAR_AUTO_MAIN_USER=user
    out=$(iso_install 2>&1) || true
    printf '%s' "$out" > "$STUB_DIR/badhost_out.log"
)
assert_contains 'Invalid host name' "$STUB_DIR/badhost_out.log" "do_new_host: rejects uppercase with Invalid host name error"

# ═══════════════════════════════════════════════════════════════
echo "== existing action (auto): picks existing host via INSTALLJAR_AUTO_HOST =="
(
    seed_auto
    export INSTALLJAR_AUTO_HOST_ACTION=existing
    export INSTALLJAR_AUTO_HOST=vmhost
    iso_install 2>&1
)
assert_contains '--show-trace' "$STUB_DIR/nixos_install.log" "existing-action still runs nixos-install"

# ═══════════════════════════════════════════════════════════════
echo "== install.sh TEST-MODE guard: run_privileged =="
: > "$STUB_DIR/sudo.log"
INSTALLJAR_TEST_MODE=1 run_privileged reboot poweroff cfdisk
if grep -qF 'BLOCKED:' "$STUB_DIR/sudo.log" 2>/dev/null; then
    fail "run_privileged skipped under TEST_MODE but sudo.log flagged it"
else
    pass "run_privileged is a no-op under INSTALLJAR_TEST_MODE=1"
fi
INSTALLJAR_TEST_MODE=1 run_privileged mkfs.ext4 -F /dev/vda2
if grep -qF 'BLOCKED:' "$STUB_DIR/sudo.log" 2>/dev/null; then
    fail "run_privileged skip wrote to sudo.log"
else
    pass "run_privileged skip never reaches sudo stub"
fi

# ═══════════════════════════════════════════════════════════════
echo "== safety: no dangerous command was attempted =="
if grep -qF 'BLOCKED:' "$STUB_DIR/sudo.log" 2>/dev/null; then
    fail "sudo deny-list triggered:"
    sed 's/^/    /' "$STUB_DIR/sudo.log"
else
    pass "sudo deny-list never triggered"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1
echo "ALL TESTS PASSED"
