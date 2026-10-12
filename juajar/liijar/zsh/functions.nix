# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Shared zsh function block (single source of truth).
# -=-=-=-=-=-=-=-=-=-=-=
# Consumed by the zsh module (generated .zshrc text):
# Portable only (nix tooling, no NixOS rebuild); the *tm helpers live in functions-nixos.nix.
# Takes:
#   uf     - whether this host allows unfree packages (drives the `,` helper)
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  uf,
}:
''
  # quick nix shell: , git curl   or   , git curl -- ls   (modern, flake-based)
  # Boots an interactive shell (no `-- <cmd>`) or runs a one-off command (`-- <cmd>`).
  # Unfree temp installs are allowed only on hosts where sysset.nix.unfree.enable is true.
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

  # update the lock, or only specific inputs (nfu shelljar ; nfu shelljar nvf)
  nfu() { nix flake update "$@"; }
''
