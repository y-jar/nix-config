#!/usr/bin/env bash

# Build the recovery ISO from the flake and drop it in ~/downloads
cd ~/nix-config || exit 1

OUT=$(nix build --no-link --print-out-paths --accept-flake-config \
  .#nixosConfigurations.iso.config.system.build.isoImage) || exit 1

ISO=$(ls "$OUT"/iso/*.iso 2>/dev/null | head -1)
[ -n "$ISO" ] || {
    echo "ERROR: no .iso found in $OUT/iso/"
    exit 1
}

mkdir -p ~/downloads
rm -f ~/downloads/$(basename "$ISO")
cp "$ISO" ~/downloads/
echo "Built: $ISO"
echo "Copied to: ~/downloads/$(basename "$ISO")"
echo "Write it: sudo dd if=~/downloads/$(basename "$ISO") of=/dev/sdX bs=4M status=progress conv=fsync"
