**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

# Add New Config Guide

Adding a host is straightforward.

## Steps

1. Copy [0_TEMPLATE/](../../hstjar/0_TEMPLATE) inside [hstjar/](../../hstjar) and
   rename it to the host's name. *(Running `hardto <host>` does steps 1–2 for you
   and grabs the live hardware config.)*
2. In the new dir, fill in `user.nix` and `system.nix` like a template: what do
   you want this machine to do?
3. Check `boot.nix` for bootloader settings (usually fine as-is).
4. Add the host to `nixosConfigurations` in [flake.nix](../../flake.nix):

   ```nix
   nixosConfigurations = {
     HOSTNAME = mkJar "HOSTNAME"; # mkJar wires sysjar + WMs + hjemkey + your dir
   };
   ```

   > Don't hand-write `nixpkgs.lib.nixosSystem` here; a host added that way gets
   > no user config (no shell, no apps). `mkJar` handles it.

5. From the installer shell in `~/nix-config`, stage and deploy:

   ```bash
   ga              # git add .
   nht HOSTNAME    # test first
   nhs HOSTNAME    # switch
   ```

Done.
