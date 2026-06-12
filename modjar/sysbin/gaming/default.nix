{ ... }:

{
  imports = [
    ./steam.nix # Steam configuration
    ./heroic.nix # Heroic Games Launcher
    ./prism.nix # Prism Launcher
    ./drivers-bulk.nix # hardware drivers [might make it per system, but rn no]
  ];

}
