{ inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager # <-- move it here
    ./steam.nix # Steam configuration
    ./drivers-bulk.nix # hardware drivers [might make it per system, but rn no]
  ];
}
