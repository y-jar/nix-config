# Server Migration: whale (Proxmox VM → bare metal)

Runbook for reinstalling the `whale` host natively (no Proxmox/QEMU wrapper).
Strategy: **fresh install + re-provision** (no rootfs clone). Secrets/SSO logins
reset and are regenerated on first boot see [Secrets & Rotation](./secrets.md).

## Before you start

- Keep the Proxmox VM powered off but intact until the metal is verified (rollback).
- Back up anything you care about (media library, Jellyfin/Komga metadata) if you
  want it; service state is not copied by this runbook.
- Note the services whale runs and their ports: nginx/webjar `80`, nixdraw
  `3000`, outline `3001`, authentik `9000`, Jellyfin `8096`, komga `25600`,
  ssh `22`, avahi/mDNS `5353`, Cockpit `9090` (new).
- Confirm the metal's firmware: this runbook assumes **UEFI** (systemd-boot).
- Do not hand-edit `hstjar/whale/hardware-configuration.nix`; it is regenerated.

## Steps

1. **Install base NixOS** on the metal from the recovery ISO
   (`iso`/`iso-gnome`, build with `nix build .#iso`). Run `nixinstall`
   (gum TUI) partition → format → mount → base system → clone
   `y-jar/nix-config` into `~/nix-config`. btrfs `@` / `@home` / `@nix`
   subvolumes are supported by the installer.
2. **Adopt the generated hardware config** into the host dir:
   ```bash
   hardto whale   # copies /etc/nixos/hardware-configuration.nix over
                  # hstjar/whale/hardware-configuration.nix (host dir already exists)
   ```
   This replaces the old `qemu-guest` config with real UUIDs.
3. **Review the whale sheet** (already migrated in-repo):
   - `hstjar/whale/boot.nix` → systemd-boot, no `grubDevice`.
   - `hstjar/whale/system.nix` → `virt = { role = "host"; gui = false; }`,
     `cockpit = { enable = true; openFirewall = true; allowUnencrypted = true;
     machines = true; podman = true; }`.
   - Enable Jellyfin hardware acceleration here if the metal has a GPU
     (commented block after `sysset`).
4. **Deploy**:
   ```bash
   nht whale   # build/test without switching
   nhs whale   # switch
   ```
5. **Network identity** update `hstjar/whale/net.nix` if the LAN IP changed,
   re-scan the SSH host key (`fkey whale.local`), then rebuild the other hosts so
   the fleet pins stay correct.
6. **Re-provision services** (fresh state):
   - authentik: read the generated admin password via `grepauth`; the
     `outline-oidc-provision` unit wires OIDC on first start if it races, run
     `sudo systemctl start outline-oidc-provision`.
   - Jellyfin/Komga: re-add media libraries in their web UIs.
   - outline: browse via `https://whale.local:3001` (needs the multi-label name;
     self-signed cert is auto-minted).
7. **Verify**:
   ```bash
   systemctl --failed
   ss -ltnp | grep -E ':(80|3000|3001|8096|9000|25600|9090)\b'
   ```
   Then log into Cockpit at `http://whale.local:9090` (systemd/journal/storage,
   plus Machines via libvirt and Podman panels).

## Notes

- No `disko`/impermanence: storage is provisioned by `nixinstall`, config by the
  generated `hardware-configuration.nix`.
- Cockpit is plain HTTP on the LAN (`AllowUnencrypted`). If you later expose it
  off-LAN, put it behind a TLS reverse proxy and set `allowUnencrypted = false`,
  or set real certs for Cockpit.
