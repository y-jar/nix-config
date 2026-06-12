{...}:
{
  programs.nh = {
    enable = true;
    flake = "$HOME/nix-config"; # sets NH_OS_FLAKE variable for you
    clean = {
      enable = true;
      extraArgs = "--keep-since 5d --keep 5";
    };
  };
}
