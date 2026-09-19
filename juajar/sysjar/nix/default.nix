# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Nix settings (experimental features, substituters, garbage collection).
# -=-=-=-=-=-=-=-=-=-=-=
{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.sysset.unfree;
in
{
  imports = [
    ./overlays-nixYoinks.nix
    ./overlays-mcpe.nix
  ];
  options.sysset.unfree.enable = lib.mkOption {
    type = lib.types.bool;
    default = true; # opt-out per host: set false on hosts that forbid unfree packages
    description = "Allow unfree nixpkgs packages (nixpkgs.config.allowUnfree). Default true so existing hosts keep working.";
  }; # end of sysset.unfree.enable

  config = {
    # set up nh
    programs.nh = {
      enable = true;
      flake = "$HOME/nix-config"; # sets NH_OS_FLAKE variable for you/me/all
      clean = {
        enable = true;
        extraArgs = "--keep-since 5d --keep 5";
      }; # end of clean config
    }; # end of nh config

    # Allow unfree packages (per-host toggle)
    nixpkgs.config.allowUnfree = cfg.enable;

    # Enables nix-ld to run unpatched binaries (like in my neovim config)
    # acts as a compatability thing, if this has an issue, or i dont like it, SHUT OFF HEHEHE
    programs.nix-ld.enable = true;

    # nix stuff
    # environment.systemPackages = with pkgs; [

    # ]; # End of environment.systemPackages

    # options for nix
    nix.settings = {
      download-buffer-size = 134217728; # around 128mb
      experimental-features = [
        "pipe-operators"
        "nix-command"
        "flakes"
      ]; # End of experimental-features

      # [binary caches]
      # no third-party substituters: default cache.nixos.org only.

      # [perf & hygiene]
      auto-optimise-store = true; # dedupe identical store paths
      trusted-users = [
        "root"
        "@wheel"
      ]; # let wheel users run privileged nix ops
      use-xdg-base-directories = true; # keep nix's user config/cache in ~/.config & ~/.cache
    }; # end of nix settings

  }; # end of config
}
