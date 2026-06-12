{ ... }:
{
  nix.settings = { 
    download-buffer-size = 134217728; # around 128mb
    experimental-features = [ "nix-command" "flakes" ];
  };
}
