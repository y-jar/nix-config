{
  inputs,
  hostnm,
  config,
  ...
}:

{
  imports = [
    ./system.nix # system configuration
    ./hardware-configuration.nix # hardware configuration
    ./boot.nix # boot settings
  ];
}
