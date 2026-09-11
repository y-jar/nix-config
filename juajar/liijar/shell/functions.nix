# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Shared zsh function block (single source of truth).
# -=-=-=-=-=-=-=-=-=-=-=
# Consumed by the zsh module (generated .zshrc text):
# Takes:
#   hostnm - host name for the *tm rebuild helpers (defaults to current host)
#   uf     - whether this host allows unfree packages (drives the `,` helper)
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  hostnm,
  uf,
}:
''
  # quick nix shell: , git curl   or   , git curl -- ls   (modern, flake-based)
  # Boots an interactive shell (no `-- <cmd>`) or runs a one-off command (`-- <cmd>`).
  # Unfree temp installs are allowed only on hosts where sysset.unfree.enable is true.
  ,() {
    local -a pref=() pkgs=() args=()
    local sep=0 p
    ${lib.optionalString uf "pref=(env NIXPKGS_ALLOW_UNFREE=1)"}
    for p in "$@"; do
      if [[ "$p" == "--" ]]; then sep=1; continue; fi
      if (( sep )); then args+=("$p"); else pkgs+=("nixpkgs#$p"); fi
    done
    if [[ ''${#args[@]} -gt 0 ]]; then
      "''$pref[@]" nix shell ${lib.optionalString uf "--impure"} "''${pkgs[@]}" -c "''${args[@]}"
    else
      "''$pref[@]" nix shell ${lib.optionalString uf "--impure"} "''${pkgs[@]}"
    fi
  }

  # host-target rebuild/test (default to current host: nhtm ziiemar)
  nhtm() {
    local target="''${1:-${hostnm}}"
    nh os test --accept-flake-config ~/nix-config#"$target"
  }
  nhsm() {
    local target="''${1:-${hostnm}}"
    nh os switch --accept-flake-config ~/nix-config#"$target"
  }
  nrtm() {
    local target="''${1:-${hostnm}}"
    nixos-rebuild test --sudo --flake ~/nix-config#"$target"
  }
  nrsm() {
    local target="''${1:-${hostnm}}"
    nixos-rebuild switch --sudo --flake ~/nix-config#"$target"
  }

  # update the lock, or only specific inputs (nfu shelljar ; nfu shelljar nvf)
  nfu() { nix flake update "$@"; }
''
