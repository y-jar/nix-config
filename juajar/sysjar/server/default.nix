{ ... }:

{
  imports = [
    ./jellyfin # sets up jellyfin
    ./sleepyjar.nix
    ./nixdraw.nix # sets up a self-hosted excalidraw Server
    ./komga.nix # komga firewall
    ./webjar # self-hosted link page
    ./outline.nix # sets up the outline wiki server
    ./authentik.nix # sets up the authentik SSO IdP
  ];
}
