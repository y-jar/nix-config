{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options = {
    sysSettings.kernel.variant = lib.mkOption {
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
    }; # end of sysSettings.kernel.variant
  }; # end of options

  config = {
    # Apply cachyos overlay only when a cachyos variant is selected
    nixpkgs.overlays = lib.optionals (
      builtins.match "cachyos-.*" config.sysSettings.kernel.variant != null
    ) [ inputs.nix-cachyos-kernel.overlays.pinned ];

    # Map variant string to kernel package
    boot.kernelPackages =
      let
        v = config.sysSettings.kernel.variant;
      in
      if v == "default" then
        pkgs.linuxPackages
      else if v == "latest" then
        pkgs.linuxPackages_latest
      else
        pkgs.cachyosKernels."linuxPackages-${v}";
  }; # end of config
}
