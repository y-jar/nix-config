# What is this Jar?

This jar holds the hardware-configuration.nix`s` and the default.nix`s` that will import the rest of the system via this import path
```nix
imports = [
    ./hardware-configuration.nix # device specific hardware
    ../../modules-jar/sys-bin/default.nix # launches the system
];
```
Other things that will go within this might be device specific settings or fixes that doesnt need to be global across all of my config files and jars / bins.
