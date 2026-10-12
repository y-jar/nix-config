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

  config =
    let
      v = config.sysset.kernel.variant;
      isCachy = builtins.match "cachyos-.*" v != null;
    in
    lib.mkMerge [
      # "default" sets nothing: NixOS (or a hardware module) picks the kernel
      (lib.mkIf (v == "latest") {
        boot.kernelPackages = pkgs.linuxPackages_latest;
      })

      # cachyos overlay + kernel only when a cachyos variant is selected
      (lib.mkIf isCachy {
        nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
        boot.kernelPackages = pkgs.cachyosKernels."linuxPackages-${v}";
      })
    ]; # end of config
}
