#!/usr/bin/env bash

# Grab the current hostname
CURRENT_HOST=$(hostname)

echo "Starting Update for host: $CURRENT_HOST"

# Update the lock file
echo "Updating flake inputs..."
cd ~/nix-config && sudo nix --extra-experimental-features 'nix-command flakes' flake update

# Apply the update
echo "Rebuilding system configuration..."
nixos-rebuild switch --sudo --flake ".#$CURRENT_HOST" --show-trace

# Clean up old generations (Keep last 7)
echo "Optimizing generations..."
sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +7

# Garbage Collect
echo "Dumping garbage..."
sudo nix-collect-garbage -d

echo "|"
echo "|"
echo "DONE: $CURRENT_HOST is up to date!"
