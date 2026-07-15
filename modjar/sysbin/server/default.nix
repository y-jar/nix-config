{ config, pkgs, ... }:

{
  imports = [
    ./jellyfin # sets up jellyfin
    ./sleepyjar.nix
    ./nixdraw.nix # sets up a self-hosted excalidraw Server
    ./webjar # self-hosted link page
  ];
}
