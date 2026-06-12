**links**
- [Back Home](../../README.md)
- [key-key](./key-key.md)

# Add New Config Guide
Adding a new config is pretty straightforward.

## Steps
1. Head over to the [host directory](../../hstjar) and copy the [0_TEMPLATE/](../../hstjar/0_TEMPLATE) within the same directory.
2. Rename the copied directory to the desired config name `[Preferred Name would be the hostname of the system]`.
3. enter the `[Preferred Name]` directory and edit the two main files `user.nix` and `system.nix`, treat it like a filled-out template(What do you want?).
4. After those two files, check the `boot.nix` file for the bootloader issues and make any necessary adjustments(you shouldnt need to but im not gonna say no).
5. same as the [install guide](./install-guide.md), run either `nixos-rebuild switch --sudo --flake ~/nix-config#HOSTNAME` or `nh os switch ~/nix-config#HOSTNAME`(if you are using nh)
  - > ```bash
    > nixos-rebuild test --sudo --flake ~/nix-config#HOSTNAME # test the config before switching
    > ```
6. your done!
