# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: NixOS-ONLY zsh functions (nh / nixos-rebuild host helpers).
# -=-=-=-=-=-=-=-=-=-=-=
# Only appended to .zshrc when usrset.system.platform = "nixos". Portable ones are in
# ./functions.nix. Takes `hostnm` (the default target for the *tm helpers).
{ hostnm }:
''
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
''
