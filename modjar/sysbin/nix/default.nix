{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./overlays-nixYoinks.nix
  ];
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

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

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

      # [binary caches / substituters]
      substituters = [
        "https://cache.nixos.org"
        "https://bazinga.cachix.org" # whisper's cache [preprocessor]
        "https://onelock.cachix.org"
      ]; # end of substituters
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "bazinga.cachix.org-1:WI9TV6l0gBVhcfY7OQM5zWqYmESIarKME0fjVN6yDYU="
        "onelock.cachix.org-1:Wyy9XrWqFKcPxkZXQg5yZXtsbKTbkaga44UWRJfgqEg="
      ]; # end of trusted-public-keys

      # [perf & hygiene]
      auto-optimise-store = true; # dedupe identical store paths
      trusted-users = [ "root" "@wheel" ]; # let wheel users run privileged nix ops
      use-xdg-base-directories = true; # keep nix's user config/cache in ~/.config & ~/.cache
    }; # end of nix settings



  }; # end of config
}
