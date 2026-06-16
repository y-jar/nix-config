{
  pkgs,
  ...
}:
{
  config = {
    # set up nh
    programs.nh = {
      enable = true;
      flake = "$HOME/nix-config"; # sets NH_OS_FLAKE variable for you
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
    environment.systemPackages = with pkgs; [
      nixd # Feature-rich Nix language server interoperating with C++ nix
      nixfmt # Nix formatter
      nil # Nix language server
    ]; # End of environment.systemPackages

    # options for nix
    nix.settings = {
      download-buffer-size = 134217728; # around 128mb
      experimental-features = [
        "nix-command"
        "flakes"
      ]; # End of experimental-features
    }; # end of nix settings
  }; # end of config
}
