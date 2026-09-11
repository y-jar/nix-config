# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Choose kernel: default, latest, or cachyos variants.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options = {
    sysset.kernel.variant = lib.mkOption {
      type = lib.types.enum [
        "default"
        "latest"
        "cachyos-latest"
        "cachyos-bore"
        "cachyos-lts"
        "cachyos-hardened"
      ];
      default = "default";
      description = "Kernel variant to use. Cachyos variants require the nix-cachyos-kernel input.";
    }; # end of sysset.kernel.variant
  }; # end of options

  config = {
    # Apply cachyos overlay only when a cachyos variant is selected
    nixpkgs.overlays = lib.optionals (
      builtins.match "cachyos-.*" config.sysset.kernel.variant != null
    ) [ inputs.nix-cachyos-kernel.overlays.pinned ];

    # Map variant string to kernel package
    boot.kernelPackages =
      let
        v = config.sysset.kernel.variant;
      in
      if v == "default" then
        pkgs.linuxPackages
      else if v == "latest" then
        pkgs.linuxPackages_latest
      else
        pkgs.cachyosKernels."linuxPackages-${v}";
  }; # end of config
}
