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
        echo -e "${RED}Error: flake.nix not found. Are you in the nix-config directory?${NC}"
        exit 1
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
#  Main Menu
# ═══════════════════════════════════════
main() {
    check_deps
    check_dir

    while true; do
        choice=$(gum choose \
            "Fresh Install" \
            "Update Existing Host" \
            "Manual Install" \
            "View Documentation" \
            "Exit" \
            --header "NixOS in a Jar — Installer" \
            --height 10)

        case "$choice" in
            "Fresh Install")     fresh_install ;;
            "Update Existing Host") update_existing ;;
            "Manual Install")    manual_install ;;
            "View Documentation") view_docs ;;
            "Exit")              gum log --level info "Goodbye!"; exit 0 ;;
            *)                   gum log --level warn "Unknown option" ;;
        esac

        echo ""
    done
}

main "$@"
