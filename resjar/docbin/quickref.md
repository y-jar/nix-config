**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Quick Reference

The catalogue and commands that used to live in the README.

## What's inside

Toggled per host, so a machine only ships what it needs.

- **Desktops & compositors:** GNOME · Cinnamon · COSMIC · Hyprland · Niri · Mango
- **Shells:** Noctalia · Wayle (Quickshell)
- **Terminals:** Foot · Kitty · Alacritty
- **Editors:** NVF (neovim) · vis · VSCodium · Zed · Helix · Obsidian
- **Browsers:** Firefox · LibreWolf · Browsh
- **Media & creative:** MPV · Gapless · Blender · Krita · GIMP · OBS · Kdenlive
- **Gaming:** Steam · Heroic · Prism · MangoHud
- **Self-hosting:** Jellyfin · Komga · Outline · Authentik · nixdraw · webjar
- **Other:** KeePassXC · LocalSend · Fastfetch · llama.cpp · Japanese input (fcitx5 + Mozc)

See [Desktops & Shells](./desktops-shells.md) and the
[App additions](./adding-modules.md) for how toggles work.

## Shell Aliases

The ones i actually use. Source of truth is [liijar/zsh](../../juajar/liijar/zsh/).

| Alias | Command | Purpose |
| :--- | :--- | :--- |
| `nhs` | `nh os switch` | deploy system config |
| `nht` | `nh os test` | test without touching the bootloader |
| `updatejar` | pull + test + (ask) deploy | one-command host update |
| `nhc` | `nh clean all --keep 7` | clean old generations, keep 7 |
| `nrs` / `nrt` | `nixos-rebuild switch/test` | hard rebuild fallback (sudo) |
| `jars` | `git pull --rebase origin main` | pull latest config |
| `nv` / `v` / `zd` / `code` | nvim / vis / zeditor / codium | editors |
| `chkhrd` | `lsblk && fdisk -l` | storage check |
| `,` | `nix shell` (function) | quick one-off shells, `, git curl` |

## Core Usage & Tips

```bash
updatejar    # the whole loop: pull, test, ask to deploy
nhs          # deploy system config
nht          # test before deploying
nhc          # clean up old generations
```

- Toggle features with `true`/`false` in `system.nix` and `user.nix`.
- New host? Run `hardto <host>` from the installer shell.
- Always `nht` before `nhs`.
- `nrs` / `nrt` are the `nixos-rebuild` fallback if `nh` misbehaves.
