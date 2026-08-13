{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    Settings.PH____ = {
      enable = {
        type = lib.types.bool;
        default = false;
      }; # end of enable
    }; # end of PH____
  }; # end of options

  config = lib.mkIf config.Settings.PH____.enable {
    # =-=-=-=-=-=-=What is this?
    # ref: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/oci-containers.nix
    #
    # > `oci-containers` is "Open Container Initiative", and its the standard for container images.
    # I'm defining a container called `excalidraw` inside it. The name can be anything, it just becomes the systemd service name [docker-excalidraw.service]
    #
    # > `image` This is the Docker Hub image to pull. The format is always owner/imagename:tag. `:latest` means always grab the newest version.
    # I think i could pin it to a specific version like `:sha-abc123` if stability is wanted over freshness.
    # And the `image` is pulling from the docker repository.
    #
    # > image stuff:
    # > `GitHub Container Registry` images stored alongside GitHub repos. These have the prefix ghcr.io/owner/image:tag
    # > `Self-hosted` can even run your own. Prefix domain like registry.example.com/image:tag
    virtualisation.oci-containers.containers.APPNAME = {
      image = "owner/image:tag"; # from Docker Hub
      ports = [ "HOSTPORT:APPPORT" ]; # check the app's docs for what port it uses internally
      environment = {
        # optional, for env vars the app needs
        SOME_VAR = "value";
      };
      volumes = [
        # optional, for persistent data
        "/host/path:/container/path"
      ];
    };
    virtualisation.docker.enable = true;
    networking.firewall.allowedTCPPorts = [ HOSTPORT ];
  };
}
