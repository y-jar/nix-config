# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Nix settings (flakes, unfree toggle, nh, nix-ld, optional store cleanup).
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  config,
  ...
}:
let
  cfg = config.sysset.nix.unfree;
  storeClean = config.sysset.nix.storeClean;
in
{
  imports = [
    ./overlays-nixYoinks.nix
    ./overlays-mcpe.nix
  ];
  options.sysset.nix.unfree.enable = lib.mkOption {
    type = lib.types.bool;
    default = true; # opt-out per host: set false on hosts that forbid unfree packages
    description = "Allow unfree nixpkgs packages (nixpkgs.config.allowUnfree). Default true so existing hosts keep working.";
  }; # end of sysset.nix.unfree.enable

  options.sysset.nix.nh.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Install nh (nix helper) and point NH_OS_FLAKE at ~/nix-config; nh's own weekly clean runs unless storeClean is enabled.";
  }; # end of sysset.nix.nh.enable

  options.sysset.nix.nixLd.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable nix-ld so unpatched binaries (editor plugins, downloaded tools) can run.";
  }; # end of sysset.nix.nixLd.enable

  options.sysset.nix.storeClean = {
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
  }; # end of sysset.nix.storeClean

  config = lib.mkMerge [
    {
      # Allow unfree packages (per-host toggle)
      nixpkgs.config.allowUnfree = cfg.enable;

      # Permit the currently-EOL electron that electron editors (vscodium/obsidian)
      # pull from the latest nixpkgs, only on hosts that actually install one.
      # Version-scoped: a future nixpkgs that resolves them to a non-EOL electron
      # ignores this entry entirely (no pinning, updates unaffected).
      nixpkgs.config.permittedInsecurePackages = lib.mkIf config.sysset.usesElectronEditor [
        "electron-41.10.7"
      ];

      # nix itself: flakes everywhere, sane store hygiene
      nix.settings = {
        download-buffer-size = 134217728; # around 128mb
        experimental-features = [
          "pipe-operators"
          "nix-command"
          "flakes"
        ]; # End of experimental-features

        # [binary caches] no third-party substituters: default cache.nixos.org only.

        # [perf & hygiene]
        auto-optimise-store = true; # dedupe identical store paths
        trusted-users = [
          "root"
          "@wheel"
        ]; # let wheel users run privileged nix ops
        use-xdg-base-directories = true; # keep nix's user config/cache in ~/.config & ~/.cache
      }; # end of nix settings
    }

    (lib.mkIf config.sysset.nix.nh.enable {
      programs.nh = {
        enable = true;
        flake = "$HOME/nix-config"; # sets NH_OS_FLAKE variable for you/me/all
        clean = {
          # nh's own weekly GC timer conflicts with nix.gc, so only one may be
          # active: storeClean.enable takes over, otherwise nh cleans.
          # (nhc/nh-clean the CLI command still works either way.)
          enable = !storeClean.enable;
          extraArgs = "--keep-since 5d --keep 5";
        }; # end of clean config
      }; # end of nh config
    })

    # Runs unpatched binaries (like in my neovim config). If it causes trouble, set false.
    (lib.mkIf config.sysset.nix.nixLd.enable {
      programs.nix-ld.enable = true;
    })

    # [automatic store cleanup] opt-in per host (sysset.nix.storeClean.enable).
    # Deletes old generations on a timer; the manual `nsc` alias is the hard wipe.
    (lib.mkIf storeClean.enable {
      nix.gc = {
        automatic = true;
        inherit (storeClean) dates options persistent;
      };
    })
  ]; # end of config
}
