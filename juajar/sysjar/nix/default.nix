# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Nix settings (experimental features, substituters, garbage collection).
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  config,
  ...
}:
let
  cfg = config.sysset.unfree;
  storeClean = config.sysset.systemStoreClean;
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

  options.sysset.systemStoreClean = {
    enable = lib.mkEnableOption "automatic Nix store cleanup (nix.gc systemd timer)";
    dates = lib.mkOption {
      type = with lib.types; either singleLineStr (listOf str);
      default = "weekly";
      description = "systemd calendar spec for cleanup runs (nix.gc.dates).";
    }; # end of dates
    options = lib.mkOption {
      type = lib.types.singleLineStr;
      default = "--delete-older-than 14d";
      description = "Flags passed to nix-collect-garbage (nix.gc.options).";
    }; # end of options
    persistent = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Catch up a missed cleanup after downtime (nix.gc.persistent).";
    }; # end of persistent
  }; # end of sysset.systemStoreClean

  config = {
    # set up nh
    programs.nh = {
      enable = true;
      flake = "$HOME/nix-config"; # sets NH_OS_FLAKE variable for you/me/all
      clean = {
        # nh's own weekly GC timer conflicts with nix.gc, so only one may be
        # active: systemStoreClean.enable takes over, otherwise nh cleans.
        # (nhc/nh-clean the CLI command still works either way.)
        enable = !storeClean.enable;
        extraArgs = "--keep-since 5d --keep 5";
      }; # end of clean config
    }; # end of nh config

    # Allow unfree packages (per-host toggle)
    nixpkgs.config.allowUnfree = cfg.enable;

    # Permit the currently-EOL electron that electron editors (vscodium/obsidian)
    # pull from the latest nixpkgs, only on hosts that actually install one.
    # Version-scoped: a future nixpkgs that resolves them to a non-EOL electron
    # ignores this entry entirely (no pinning, updates unaffected).
    nixpkgs.config.permittedInsecurePackages = lib.mkIf config.sysset.usesElectronEditor [
      "electron-41.10.7"
    ];

    # Enables nix-ld to run unpatched binaries (like in my neovim config)
    # acts as a compatability thing, if this has an issue, or i dont like it, SHUT OFF HEHEHE
    programs.nix-ld.enable = true;

    # nix stuff

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

    # [automatic store cleanup] opt-in per host (sysset.systemStoreClean.enable).
    # Deletes old generations on a timer; the manual `nsc` alias is the hard wipe.
    nix.gc = lib.mkIf storeClean.enable {
      automatic = true;
      inherit (storeClean) dates options persistent;
    }; # end of nix.gc

  }; # end of config
}
