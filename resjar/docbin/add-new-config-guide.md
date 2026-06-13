**links**
- [Back Home](../../README.md)
- [key-key](./key-key.md)

# Add New Config Guide
Adding a new config is pretty straightforward.

## Steps
1. Head over to the [host directory](../../hstjar) and copy the [0_TEMPLATE/](../../hstjar/0_TEMPLATE) within the same directory.
2. Rename the copied directory to the desired config name `[Preferred Name would be the hostname of the system]`.
3. enter the `[Preferred Name]` directory and edit the two main files `user.nix` and `system.nix`, treat it like a filled-out template(What do you want your system to do?).
4. After those two files, check the `boot.nix` file for the bootloader issues and make any necessary adjustments(you shouldnt need to but im not gonna say no).
5. now that you have set up the host config, you now need to hop into the [flake.nix](../../flake.nix) and add the new config to the `nixosConfigurations` block:

```nix
nixosConfigurations = {
    # this block below is what you add :)  
    HOSTNAME = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # or your target system type
        specialArgs = { 
            inherit inputs; # sends over the inputs from the flake.nix
            hostnm = "HOSTNAME"; # sends over the hostname of the config the the system
        };
        modules = [ # more or less dont change this
            ./modjar/sysbin # this is where the base system options are defined. [you shouldnt need to change this or enter it. unless you got apps or things to add on top.]
            ./hstjar/HOSTNAME # change this [this makes sure the config you just made is ensured to work]
        ]; # end of modules
    }; # end of HOSTNAME config
}; # end of nixosConfigurations block
```

6. same as the [install guide](./install-guide.md), run: `git add .` in `~/nix-config` and then `nixos-rebuild switch --sudo --flake ~/nix-config#HOSTNAME` or `nh os switch ~/nix-config#HOSTNAME`(if you are using nh)
  - > ```bash
    > nixos-rebuild test --sudo --flake ~/nix-config#HOSTNAME # test the config before switching
    > ```
6. your done!
