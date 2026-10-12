# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host vmjar: generated per-machine hardware config.
# -=-=-=-=-=-=-=-=-=-=-=
## THIS FILE MUST BE GENERATED ON A PER MACHINE BASIS
## RUN: nixos-generate-config --show-hardware-config > hardware-configuration.nix
## (nixinstall's "refresh hardware" does this for you on the target VM)
##
## Until then this is an eval-only placeholder so `nix flake check` and
## whole-flake evals pass: it defines a root fs by label. The generated file
## replaces it entirely.

{ ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
}
