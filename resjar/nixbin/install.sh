#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
#  NixOS in a Jar — Interactive Installer
#  Uses gum for TUI prompts
# ═══════════════════════════════════════════════════════
set -euo pipefail

# ──[vars]
NIX_CONFIG_DIR="$HOME/nix-config"
FLAKE_PATH="$NIX_CONFIG_DIR/flake.nix"
HOSTS_DIR="$NIX_CONFIG_DIR/hstjar"
TEMPLATE_DIR="$HOSTS_DIR/0_TEMPLATE"
DOCS_DIR="$NIX_CONFIG_DIR/resjar/docbin"

# ──[colors for fallback output]
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ──[check dependencies]
check_deps() {
    if ! command -v gum &>/dev/null; then
        echo -e "${RED}Error: 'gum' is not installed.${NC}"
        echo "Run: nix-shell -p gum"
        exit 1
    fi
}

# ──[check we're in the right directory]
check_dir() {
    if [ ! -f "$FLAKE_PATH" ]; then
        gum log --level error "flake.nix not found at $FLAKE_PATH"
        gum log "Run from the nix-config directory or set NIX_CONFIG_DIR"
        return 1
    fi
}

# ──[get list of existing hosts (excluding 0_TEMPLATE)]
get_hosts() {
    for dir in "$HOSTS_DIR"/*/; do
        local name
        name=$(basename "$dir")
        if [ "$name" != "0_TEMPLATE" ] && [ -d "$dir" ]; then
            echo "$name"
        fi
    done
}

# ──[get host description from flake.nix]
get_host_desc() {
    local host="$1"
    grep -oP "${host}\s*=\s*mkJar\s*\"${host}\";\s*#\s*\K.*" "$FLAKE_PATH" 2>/dev/null || echo ""
}

# ──[refresh hardware config for a host]
refresh_hardware() {
    local host="$1"
    local target_dir="$HOSTS_DIR/$host"

    if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
        gum spin --spinner dot --title "Copying hardware-configuration.nix..." -- \
            cp /etc/nixos/hardware-configuration.nix "$target_dir/hardware-configuration.nix"
        gum log --level info "Hardware config refreshed for $host"
    else
        gum log --level warn "/etc/nixos/hardware-configuration.nix not found"
        gum log --level warn "Are you running on a live ISO?"
    fi
}

# ──[add a new host entry to flake.nix]
add_host_to_flake() {
    local host="$1"
    local desc="$2"

    # Check if host already exists in flake.nix
    if grep -qP "^\s*${host}\s*=\s*mkJar" "$FLAKE_PATH"; then
        gum log --level warn "Host '$host' already exists in flake.nix — skipping"
        return 0
    fi

    # Find the line before the hjem hosts section
    local line_num
    line_num=$(grep -n '# ========\[hjem hosts' "$FLAKE_PATH" | head -1 | cut -d: -f1)

    if [ -z "$line_num" ]; then
        # Fallback: find the closing of nixosConfigurations base hosts
        line_num=$(grep -n '# ========\[hjem' "$FLAKE_PATH" | head -1 | cut -d: -f1)
    fi

    if [ -z "$line_num" ]; then
        gum log --level error "Could not find insertion point in flake.nix"
        return 1
    fi

    local insert_line=$((line_num - 1))
    local new_entry="        ${host} = mkJar \"${host}\"; # ${desc}"

    sed -i "${insert_line}a\\${new_entry}" "$FLAKE_PATH"
    gum log --level info "Added '$host' to flake.nix"
}

# ──[open file in editor if available]
open_editor() {
    local file="$1"
    if [ -n "${EDITOR:-}" ] && command -v "$EDITOR" &>/dev/null; then
        "$EDITOR" "$file"
    elif command -v vim &>/dev/null; then
        vim "$file"
    elif command -v nano &>/dev/null; then
        nano "$file"
    else
        gum log --level warn "No editor found — edit manually: $file"
    fi
}

# ═══════════════════════════════════════
#  Option 1: Fresh Install
# ═══════════════════════════════════════
fresh_install() {
    gum style --border double --align center --width 50 \
        --foreground 212 "Fresh Install" "Set up a new host"

    # Step 1: Get hostname
    local host
    host=$(gum input --placeholder "Enter hostname (e.g., mypc)" --width 40)
    if [ -z "$host" ]; then
        gum log --level error "Hostname cannot be empty"
        return 1
    fi

    local target_dir="$HOSTS_DIR/$host"

    # Step 2: Check if host exists
    if [ -d "$target_dir" ]; then
        gum log --level warn "Host directory '$host' already exists"
        if ! gum confirm "Refresh hardware config and reconfigure?"; then
            gum log --level info "Cancelled"
            return 0
        fi
    else
        # Copy template
        gum log --level info "Creating host directory from template..."
        cp -r "$TEMPLATE_DIR" "$target_dir"
        gum log --level info "Template copied to hstjar/$host/"
    fi

    # Step 3: Always refresh hardware config
    refresh_hardware "$host"

    # Step 4: Add to flake.nix if new
    if [ ! -d "$target_dir" ] || [ ! -f "$target_dir/default.nix" ]; then
        # This shouldn't happen, but guard anyway
        gum log --level error "Host directory missing"
        return 1
    fi

    # Check if already in flake
    if ! grep -qP "^\s*${host}\s*=\s*mkJar" "$FLAKE_PATH"; then
        local desc
        desc=$(gum input --placeholder "Short description (e.g., my laptop)" --width 40)
        add_host_to_flake "$host" "${desc:-new host}"
    else
        gum log --level info "Host '$host' already in flake.nix"
    fi

    # Step 5: Edit configs
    gum style --border normal --align center --width 50 \
        "Now edit your configs!" \
        "hstjar/$host/system.nix  — system toggles" \
        "hstjar/$host/home.nix    — user toggles"

    if gum confirm "Open system.nix in editor?"; then
        open_editor "$target_dir/system.nix"
    fi

    if gum confirm "Open home.nix in editor?"; then
        open_editor "$target_dir/home.nix"
    fi

    # Step 6: Test & Deploy
    gum style --border normal --align center --width 50 \
        "Ready to deploy?"

    if gum confirm "Test configuration first? (nht)"; then
        gum log --level info "Testing $host..."
        nh os test ~/nix-config#"$host" || {
            gum log --level error "Test failed — fix your config and try again"
            return 1
        }
        gum log --level info "Test passed!"
    fi

    if gum confirm "Deploy system now? (nhs)"; then
        gum log --level info "Deploying $host..."
        nh os switch ~/nix-config#"$host" || {
            gum log --level error "Deploy failed"
            return 1
        }
        gum log --level info "System deployed!"
    fi

    # Step 7: Home Manager
    if gum confirm "Deploy home-manager profile? (hms)"; then
        local user
        user=$(gum input --placeholder "Username (e.g., jar)" --width 30 --value "jar")
        if [ -n "$user" ]; then
            gum log --level info "Deploying home-manager for $user..."
            nh home switch ~/nix-config#"$user" || {
                gum log --level error "Home-manager deploy failed"
                return 1
            }
            gum log --level info "Home-manager deployed!"
        fi
    fi

    gum style --border double --foreground 2 "Install complete for $host!"
}

# ═══════════════════════════════════════
#  Option 2: Update Existing Host
# ═══════════════════════════════════════
update_existing() {
    gum style --border double --align center --width 50 \
        --foreground 212 "Update Existing Host" "Refresh and redeploy"

    # Step 1: Pick host
    local hosts
    hosts=$(get_hosts)
    if [ -z "$hosts" ]; then
        gum log --level error "No hosts found in hstjar/"
        return 1
    fi

    local host
    host=$(echo "$hosts" | gum choose --header "Pick a host to update")
    if [ -z "$host" ]; then
        gum log --level info "Cancelled"
        return 0
    fi

    local target_dir="$HOSTS_DIR/$host"

    # Show host info
    local desc
    desc=$(get_host_desc "$host")
    gum style --border normal --align center --width 50 \
        "Host: $host" \
        "Desc: ${desc:-none}"

    # Step 2: Refresh hardware config
    if gum confirm "Refresh hardware-configuration.nix?"; then
        refresh_hardware "$host"
    fi

    # Step 3: Pull latest changes
    if gum confirm "Pull latest changes from repo?"; then
        gum log --level info "Pulling..."
        git -C "$NIX_CONFIG_DIR" pull --rebase origin main || {
            gum log --level warn "Pull failed — continuing anyway"
        }
    fi

    # Step 4: Edit configs
    if gum confirm "Edit system.nix?"; then
        open_editor "$target_dir/system.nix"
    fi

    if gum confirm "Edit home.nix?"; then
        open_editor "$target_dir/home.nix"
    fi

    # Step 5: Test & Deploy
    if gum confirm "Test configuration first? (nht)"; then
        gum log --level info "Testing $host..."
        nh os test ~/nix-config#"$host" || {
            gum log --level error "Test failed"
            return 1
        }
        gum log --level info "Test passed!"
    fi

    if gum confirm "Deploy system now? (nhs)"; then
        gum log --level info "Deploying $host..."
        nh os switch ~/nix-config#"$host" || {
            gum log --level error "Deploy failed"
            return 1
        }
        gum log --level info "System deployed!"
    fi

    if gum confirm "Deploy home-manager profile? (hms)"; then
        local user
        user=$(gum input --placeholder "Username" --width 30 --value "jar")
        if [ -n "$user" ]; then
            gum log --level info "Deploying home-manager for $user..."
            nh home switch ~/nix-config#"$user" || {
                gum log --level error "Home-manager deploy failed"
                return 1
            }
            gum log --level info "Home-manager deployed!"
        fi
    fi

    gum style --border double --foreground 2 "Update complete for $host!"
}

# ═══════════════════════════════════════
#  Option 3: Manual Install
# ═══════════════════════════════════════
manual_install() {
    gum style --border double --align center --width 50 \
        --foreground 212 "Manual Install" "Step-by-step guide"

    # Step 1
    gum style --border normal --width 50 \
        "Step 1: Clone the repo"
    gum format -t code 'git clone https://github.com/y-jar/nix-config.git ~/nix-config
cd ~/nix-config'
    if ! gum confirm "Done?"; then
        gum log --level info "Exiting — resume when ready"
        return 0
    fi

    # Step 2
    gum style --border normal --width 50 \
        "Step 2: Enter nix-shell & copy template"
    gum format -t code 'nix-shell
hardto YOURHOST'
    gum log --level info "Replace YOURHOST with your chosen hostname"
    if ! gum confirm "Done?"; then
        return 0
    fi

    # Step 3
    gum style --border normal --width 50 \
        "Step 3: Check bootloader in hstjar/YOURHOST/boot.nix"
    gum log --level info "Compare with /etc/nixos/configuration.nix imports"
    if ! gum confirm "Done?"; then
        return 0
    fi

    # Step 4
    gum style --border normal --width 50 \
        "Step 4: Edit your configs"
    gum format -t code '# Edit system toggles:
vim hstjar/YOURHOST/system.nix

# Edit user toggles:
vim hstjar/YOURHOST/home.nix'
    if ! gum confirm "Done?"; then
        return 0
    fi

    # Step 5
    gum style --border normal --width 50 \
        "Step 5: Test & deploy"
    gum format -t code 'nht YOURHOST   # test first
nhs YOURHOST   # then deploy'
    if ! gum confirm "Deploy now?"; then
        gum log --level info "Run 'nhs YOURHOST' when ready"
        return 0
    fi

    gum log --level info "Run 'nhs YOURHOST' to deploy"
    gum style --border double --foreground 2 "Manual install steps complete!"
}

# ═══════════════════════════════════════
#  Option 4: View Docs
# ═══════════════════════════════════════
view_docs() {
    local doc
    doc=$(gum choose \
        "install-guide.md" \
        "directory-key.md" \
        "README.md" \
        "dev-key.md" \
        --header "Pick a document to view")

    if [ -z "$doc" ]; then
        return 0
    fi

    local doc_path="$DOCS_DIR/$doc"
    if [ "$doc" = "README.md" ]; then
        doc_path="$NIX_CONFIG_DIR/README.md"
    fi

    if [ -f "$doc_path" ]; then
        gum pager < "$doc_path"
    else
        gum log --level error "Document not found: $doc_path"
    fi
}

# ═══════════════════════════════════════
#  Option 0: Install from ISO
# ═══════════════════════════════════════
iso_install() {
    gum style --border double --align center --width 50 \
        --foreground 212 "NixOS Installer" "Guided installation from ISO"

    local target_disk=""
    local fs_type=""
    local use_subvolumes=false
    local separate_home=false
    local use_swap=false
    local swap_size=""
    local boot_mode=""
    local boot_part=""
    local root_part=""
    local home_part=""
    local swap_part=""

    # ──────────────────────────────────────
    # Step 1: Disk selection
    # ──────────────────────────────────────
    gum style --border normal --width 50 "Step 1: Select target disk"

    local disks
    disks=$(lsblk -ndo NAME,SIZE,TYPE 2>/dev/null | grep ' disk ' || true)
    if [ -z "$disks" ]; then
        gum log --level error "No disks found"
        return 1
    fi

    local disk_list=""
    while IFS= read -r line; do
        local name size
        name=$(echo "$line" | awk '{print $1}')
        size=$(echo "$line" | awk '{print $2}')
        disk_list+="/dev/$name | $size"$'\n'
    done <<< "$disks"

    local selected
    selected=$(echo "$disk_list" | fzf --header="Select the disk to install onto" --height=10)
    if [ -z "$selected" ]; then
        gum log --level error "No disk selected"
        return 1
    fi

    target_disk=$(echo "$selected" | awk -F'|' '{print $1}' | xargs)
    gum log --level info "Selected disk: $target_disk"

    if ! gum confirm "This will ERASE data on $target_disk. Continue?"; then
        gum log --level info "Cancelled"
        return 0
    fi

    # ──────────────────────────────────────
    # Step 2: Boot mode detection
    # ──────────────────────────────────────
    gum style --border normal --width 50 "Step 2: Boot mode"

    if [ -d /sys/firmware/efi ]; then
        boot_mode="UEFI"
    else
        boot_mode="BIOS"
    fi

    local boot_choice
    boot_choice=$(gum choose --header "Detected: $boot_mode. Override?" "UEFI" "BIOS" "Use detected ($boot_mode)")
    case "$boot_choice" in
        "UEFI") boot_mode="UEFI" ;;
        "BIOS") boot_mode="BIOS" ;;
    esac
    gum log --level info "Boot mode: $boot_mode"

    # ──────────────────────────────────────
    # Step 3: Partition scheme
    # ──────────────────────────────────────
    gum style --border normal --width 50 "Step 3: Choose partition scheme"

    fs_type=$(gum choose "ext4" "btrfs" "xfs" --header "Filesystem for root and home")
    if [ -z "$fs_type" ]; then
        gum log --level error "No filesystem selected"
        return 1
    fi
    gum log --level info "Filesystem: $fs_type"

    if gum confirm "Separate /home partition?"; then
        separate_home=true
    fi

    if gum confirm "Swap partition?"; then
        use_swap=true
        swap_size=$(gum input --placeholder "e.g. 16G" --prompt "Swap size: " --value "8G")
    fi

    if [ "$fs_type" = "btrfs" ] && gum confirm "Use btrfs subvolumes? (@ / @home / @nix)"; then
        use_subvolumes=true
    fi

    # ──────────────────────────────────────
    # Step 4: Partition guide
    # ──────────────────────────────────────
    gum style --border normal --width 50 "Step 4: Partition the disk"

    local guide=""
    if [ "$boot_mode" = "UEFI" ]; then
        guide+="512M  -> type 'EFI System'       -> /boot"$'\n'
    else
        guide+="1M    -> type 'BIOS boot'        -> (unformatted)"$'\n'
    fi
    if [ "$use_swap" = true ]; then
        guide+="${swap_size} -> type 'Linux swap'         -> swap"$'\n'
    fi
    if [ "$separate_home" = true ]; then
        guide+="50-100G -> type 'Linux filesystem' -> /"$'\n'
        guide+="rest   -> type 'Linux filesystem' -> /home"$'\n'
    else
        guide+="rest   -> type 'Linux filesystem' -> /"$'\n'
    fi

    gum format -t code "Open cfdisk to partition:
  sudo cfdisk $target_disk

Recommended layout for $boot_mode:

$guide"

    if ! gum confirm "Run cfdisk now?"; then
        gum log --level info "You can run: sudo cfdisk $target_disk"
        if ! gum confirm "Ready to continue after partitioning?"; then
            gum log --level info "Cancelled"
            return 0
        fi
    else
        sudo cfdisk "$target_disk"
    fi

    # ──────────────────────────────────────
    # Step 5: Identify partitions
    # ──────────────────────────────────────
    gum style --border normal --width 50 "Step 5: Identify partitions"

    echo ""
    echo "Here are the partitions on $target_disk:"
    lsblk "$target_disk" -o NAME,SIZE,FSTYPE,MOUNTPOINT
    echo ""

    if [ "$boot_mode" = "UEFI" ]; then
        boot_part=$(gum input --placeholder "/dev/${target_disk##*/}1" --prompt "EFI boot partition: ")
        root_part=$(gum input --placeholder "/dev/${target_disk##*/}2" --prompt "Root partition: ")
    else
        root_part=$(gum input --placeholder "/dev/${target_disk##*/}1" --prompt "Root partition (skip BIOS boot): ")
    fi

    if [ -z "$root_part" ]; then
        gum log --level error "Root partition is required"
        return 1
    fi

    if [ "$use_swap" = true ]; then
        swap_part=$(gum input --prompt "Swap partition (or leave empty): ")
    fi

    if [ "$separate_home" = true ]; then
        home_part=$(gum input --prompt "Home partition (or leave empty): ")
    fi

    for part in "$boot_part" "$root_part" "$home_part" "$swap_part"; do
        if [ -n "$part" ] && [ ! -b "$part" ]; then
            gum log --level error "Partition does not exist: $part"
            return 1
        fi
    done

    gum log --level info "Partitions identified OK"

    # ──────────────────────────────────────
    # Step 6: Format
    # ──────────────────────────────────────
    gum style --border normal --width 50 "Step 6: Format partitions"
    gum log --level warn "About to FORMAT:"

    if [ -n "$boot_part" ]; then
        gum log "  $boot_part  -> FAT32 (EFI)"
    fi
    if [ -n "$root_part" ]; then
        gum log "  $root_part  -> $fs_type"
    fi
    if [ -n "$home_part" ]; then
        gum log "  $home_part  -> $fs_type"
    fi
    if [ -n "$swap_part" ]; then
        gum log "  $swap_part  -> swap"
    fi

    if ! gum confirm "Format these partitions?"; then
        gum log --level info "Cancelled"
        return 0
    fi

    if [ -n "$boot_part" ]; then
        gum spin --spinner dot --title "Formatting EFI partition..." -- \
            sudo mkfs.fat -F 32 "$boot_part"
    fi

    if [ -n "$root_part" ]; then
        case "$fs_type" in
            ext4) gum spin --spinner dot --title "Formatting root..." -- sudo mkfs.ext4 -F "$root_part" ;;
            btrfs) gum spin --spinner dot --title "Formatting root..." -- sudo mkfs.btrfs -f "$root_part" ;;
            xfs) gum spin --spinner dot --title "Formatting root..." -- sudo mkfs.xfs -f "$root_part" ;;
        esac
    fi

    if [ -n "$home_part" ]; then
        case "$fs_type" in
            ext4) gum spin --spinner dot --title "Formatting home..." -- sudo mkfs.ext4 -F "$home_part" ;;
            btrfs) gum spin --spinner dot --title "Formatting home..." -- sudo mkfs.btrfs -f "$home_part" ;;
            xfs) gum spin --spinner dot --title "Formatting home..." -- sudo mkfs.xfs -f "$home_part" ;;
        esac
    fi

    if [ -n "$swap_part" ]; then
        gum spin --spinner dot --title "Setting up swap..." -- sudo mkswap "$swap_part"
    fi

    gum log --level info "Formatting complete"

    # ──────────────────────────────────────
    # Step 7: Mount
    # ──────────────────────────────────────
    gum style --border normal --width 50 "Step 7: Mount partitions"

    if mountpoint -q /mnt 2>/dev/null; then
        if gum confirm "/mnt is already mounted. Unmount and continue?"; then
            sudo umount -R /mnt 2>/dev/null || true
        else
            gum log --level error "Please unmount /mnt first"
            return 1
        fi
    fi

    if [ "$fs_type" = "btrfs" ] && [ "$use_subvolumes" = true ]; then
        sudo mount "$root_part" /mnt
        sudo btrfs subvolume create /mnt/@
        sudo btrfs subvolume create /mnt/@home
        sudo btrfs subvolume create /mnt/@nix
        sudo umount /mnt

        sudo mount -o subvol=@ "$root_part" /mnt
        sudo mount --mkdir -o subvol=@home "$root_part" /mnt/home
        sudo mount --mkdir -o subvol=@nix "$root_part" /mnt/nix
    else
        sudo mount "$root_part" /mnt
        if [ -n "$home_part" ]; then
            sudo mount --mkdir "$home_part" /mnt/home
        fi
    fi

    if [ -n "$boot_part" ]; then
        sudo mount --mkdir "$boot_part" /mnt/boot
    fi

    if [ -n "$swap_part" ]; then
        sudo swapon "$swap_part"
    fi

    gum log --level info "Mounts:"
    lsblk /mnt

    # ──────────────────────────────────────
    # Step 8: Network
    # ──────────────────────────────────────
    gum style --border normal --width 50 "Step 8: Network"

    if ! ping -c 1 1.1.1.1 &>/dev/null; then
        gum log --level warn "No network connectivity"
        if gum confirm "Open iwd for Wi-Fi setup?"; then
            if command -v iwctl &>/dev/null; then
                sudo iwctl
            else
                gum log --level warn "iwctl not available"
            fi
        fi
        if ! ping -c 1 1.1.1.1 &>/dev/null; then
            if ! gum confirm "Still offline. Continue anyway? (nixos-install needs network)"; then
                return 1
            fi
        fi
    else
        gum log --level info "Network OK"
    fi

    # ──────────────────────────────────────
    # Step 9: Clone repo
    # ──────────────────────────────────────
    gum style --border normal --width 50 "Step 9: Clone nix-config"

    local repo_url
    repo_url=$(gum input --prompt "Repo URL: " --value "https://github.com/y-jar/nix-config.git")

    local clone_dir="/mnt/etc/nixos"
    if [ -d "$clone_dir" ]; then
        if [ "$(ls -A "$clone_dir" 2>/dev/null)" ]; then
            gum log --level warn "$clone_dir is not empty"
            if ! gum confirm "Clone into it anyway?"; then
                gum log "Skipping clone. Make sure the flake is in place."
            fi
        else
            gum spin --spinner dot --title "Cloning..." -- \
                sudo git clone "$repo_url" "$clone_dir"
        fi
    else
        gum spin --spinner dot --title "Cloning..." -- \
            sudo git clone "$repo_url" "$clone_dir"
    fi

    if [ ! -f "$clone_dir/flake.nix" ]; then
        gum log --level error "flake.nix not found in $clone_dir"
        gum log "Try cloning manually: sudo git clone $repo_url $clone_dir"
        return 1
    fi

    # ──────────────────────────────────────
    # Step 10: Select host
    # ──────────────────────────────────────
    gum style --border normal --width 50 "Step 10: Select host"

    local hosts
    hosts=$(find "$clone_dir/hstjar" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | \
        xargs -n1 basename | grep -v '^0_TEMPLATE$' | sort || true)

    if [ -z "$hosts" ]; then
        gum log --level error "No hosts found in hstjar/"
        return 1
    fi

    local host
    host=$(echo "$hosts" | fzf --header="Select a host configuration")
    if [ -z "$host" ]; then
        gum log --level error "No host selected"
        return 1
    fi
    gum log --level info "Selected host: $host"

    gum spin --spinner dot --title "Generating hardware configuration..." -- \
        nixos-generate-config --root /mnt
    sudo cp /mnt/etc/nixos/hardware-configuration.nix "$clone_dir/hstjar/$host/"
    gum log --level info "Hardware config generated from target mounts"

    # ──────────────────────────────────────
    # Step 11: nixos-install
    # ──────────────────────────────────────
    gum style --border normal --width 50 "Step 11: Install NixOS"

    gum log --level info "Command: nixos-install --no-root-passwd --flake $clone_dir#$host"

    if ! gum confirm "Proceed with installation?"; then
        gum log --level info "Cancelled"
        return 0
    fi

    gum spin --spinner dot --title "Installing NixOS (this takes a while)..." -- \
        nixos-install --no-root-passwd --flake "$clone_dir#$host"

    local install_status=$?
    if [ $install_status -ne 0 ]; then
        gum log --level error "Installation failed (exit code $install_status)"
        return 1
    fi

    gum log --level info "NixOS installed successfully!"

    # ──────────────────────────────────────
    # Step 12: Set root password
    # ──────────────────────────────────────
    gum style --border normal --width 50 "Step 12: Set root password"

    if gum confirm "Set root password now?"; then
        sudo nixos-enter --root /mnt -c 'passwd'
    fi

    # ──────────────────────────────────────
    # Step 13: Done
    # ──────────────────────────────────────
    gum style --border double --align center --width 50 \
        --foreground 2 "Installation Complete!" \
        "Host: $host" \
        "Disk: $target_disk"

    if gum confirm "Unmount and reboot now?"; then
        gum spin --spinner dot --title "Unmounting..." -- \
            sudo umount -R /mnt
        sudo reboot
    else
        gum log "Reboot manually:"
        gum format -t code "sudo umount -R /mnt && sudo reboot"
    fi
}

# ═══════════════════════════════════════
#  Main Menu
# ═══════════════════════════════════════
main() {
    check_deps

    while true; do
        choice=$(gum choose \
            "Install from ISO" \
            "Fresh Install" \
            "Update Existing Host" \
            "Manual Install" \
            "View Documentation" \
            "Exit" \
            --header "NixOS in a Jar — Installer" \
            --height 12)

        case "$choice" in
            "Install from ISO")      iso_install ;;
            "Fresh Install")         check_dir && fresh_install ;;
            "Update Existing Host")  check_dir && update_existing ;;
            "Manual Install")        manual_install ;;
            "View Documentation")    check_dir && view_docs ;;
            "Exit")                  gum log --level info "Goodbye!"; exit 0 ;;
            *)                       gum log --level warn "Unknown option" ;;
        esac

        echo ""
    done
}

main "$@"
