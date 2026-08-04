#!/usr/bin/env bash

# Build the recovery ISO from the flake and drop it in ~/downloads
# Usage:
#   buildiso.sh          -> minimal ISO (default)
#   buildiso.sh minimal  -> minimal ISO
#   buildiso.sh gnome    -> graphical GNOME ISO

cd ~/nix-config || exit 1

VARIANT="${1:-minimal}"
case "$VARIANT" in
  minimal|gnome) ;;
  *)
    echo "Usage: $0 [minimal|gnome]"
    exit 1
    ;;
esac

ATTR="iso"
LABEL="minimal"
if [ "$VARIANT" = "gnome" ]; then
  ATTR="iso-gnome"
  LABEL="gnome"
fi

OUT=$(nix build --no-link --print-out-paths --accept-flake-config \
  .#nixosConfigurations.${ATTR}.config.system.build.isoImage) || exit 1

ISO=$(ls "$OUT"/iso/*.iso 2>/dev/null | head -1)
[ -n "$ISO" ] || {
    echo "ERROR: no .iso found in $OUT/iso/"
    exit 1
}

mkdir -p ~/downloads
rm -f ~/downloads/nixinjarISO-${LABEL}-*.iso
cp "$ISO" ~/downloads/
TS=$(date +%y%m%d-%H%M)
mv ~/downloads/$(basename "$ISO") ~/downloads/nixinjarISO-${LABEL}-${TS}.iso
FINAL="$HOME/downloads/nixinjarISO-${LABEL}-${TS}.iso"
echo "Built: $ISO"
echo "Copied to: $FINAL"
echo "Write it: sudo dd if=$FINAL of=/dev/sdX bs=4M status=progress conv=fsync"
