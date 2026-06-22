{ config, pkgs, ... }:

{
  imports = [
    ./jellyfin # sets up jellyfin
    ./sleepyjar.nix
  ];
}
