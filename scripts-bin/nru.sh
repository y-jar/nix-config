#!/usr/bin/env bash

# Grab the current hostname
CURRENT_HOST=$(hostname)

echo "Starting Stonepoem Update for host: $CURRENT_HOST"

# Update the lock file
echo "Updating flake inputs..."
cd ~/nix-config && nix flake update --sudo

# Apply the update using the dynamic hostname
echo "Rebuilding system configuration..."
sudo nixos-rebuild switch --sudo --flake ".#$CURRENT_HOST" --show-trace

# Clean up old generations (Keep last 7)
echo "Optimizing generations..."
sudo nix-env --sudo --profile /nix/var/nix/profiles/system --delete-generations +7

# Garbage Collect
echo "Dumping garbage..."
sudo nix-collect-garbage -d --sudo

echo "|"
echo "|"
echo "DONE: $CURRENT_HOST is up to date!"