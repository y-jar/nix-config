<!-- ref:
Paste:
<p><a href="">Here</a></p>
<img src="">
-->
<!-- My title Jar <3 -->
<div align="center">
  <h1 style="color:#d3866d; border-bottom: none; font-size: 2.5em; margin-bottom: 0;">NixOS in a Jar ❄️</h1>
  <a href="https://github.com/y-jar/nix-config/releases/latest">
    <img src="https://img.shields.io/github/v/release/y-jar-nix-config?style=for-the-badge&label=release&logo=github&logoColor=white&color=d3866d" alt="Latest Release"/>
  </a>
  <p style="margin-top: 10px; color: #8a7a71;"><i>Written by me! [Park / Jar]</i></p>
</div>

<!-- My header Stats <3> -->
<div align="center">
  <p>
      <!-- link to nixos -->
    <a href="https://nixos.org/">
      <img src="https://img.shields.io/badge/NixOS-Official%20Site-5277C3?style=for-the-badge&logo=nixos&logoColor=white" alt="NixOS Official Website"/>
    </a>
    <!-- install guide -->
    <a href="./resjar/docbin/install-guide.md">
      <img src="https://img.shields.io/badge/Documentation-Installation%20Guide-d3866d?style=for-the-badge&logo=markdown&logoColor=white" alt="Installation Guide"/>
    </a>
    <!-- directory documentations -->
    <a href="./resjar/docbin/directory-key.md">
      <img src="https://img.shields.io/badge/Repository-Directory%20Key-8a7a71?style=for-the-badge&logo=git&logoColor=white" alt="Directory Key"/>
    </a>
    <!-- header bottom -->
    <hr style="width: 90%; border: 1px solid #4f4742; margin-top: 20px;" />
  </p>
</div>

<!-- my intro <3 -->
<div align="center">
  <p style="max-width: 750px; margin: 0 auto; line-height: 1.6; color: #bcac9b;">
    Hello! This is my NixOS config! The reason i started doing this was i wanted to learn more about it after finding out about some of it's core design principles. And after dipping my toes in it i found that i adore how it works, and similar to my neovim config, my goal is to make it my personal platform and hopefully not have to configure it often extensively afterward.
  </p>
</div>
<br>

<!-- Notes for Outsiders -->
> [!NOTE] for outsiders, the install guide is located in the [install-guide](resjar/docbin/install-guide.md) file.
> Start with the [Documentation Key](resjar/docbin/key-key.md) for everything else.

> **This config is intended for NixOS users only.** And is currently focused on configuring my personal NixOS setup. So please be aware that some of the config may not be applicable to your setup.

<!--===========SUMMARY=============-->

---

### What this is =-=-=-=-=-

A fully modular NixOS flake, split into **system-level** declarations (`sysset`)
and **user-space** profiles (`usrset`, managed by [hjem](https://github.com/feel-co/hjem)).

- **One dir per host.** Every machine is a thin folder in `hstjar/`; all shared
  logic lives in `juajar/` and is auto-imported.
- **Toggle-sheet hosts.** Features flip on/off with plain `true`/`false` in each
  host's `system.nix` and `user.nix`.
- **Guided installer.** A custom installer shell scaffolds a host, grabs the live
  hardware config, and deploys.

#### What it isn't:
- **Not flake-parts.** Simplicity is my best policy.
- **Not catch-all.** No unwanted bloat (wanted bloat on the other hand... `>:)`).

### What's inside =-=-=-=-=-

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

See [Desktops & Shells](resjar/docbin/desktops-shells.md) and the
[App additions](resjar/docbin/adding-modules.md) for how toggles work.

### System Layout =-=-=-=-=-

1. [flake.nix](flake.nix) inputs, hosts, ISOs.
2. [hstjar/](./hstjar) per-host configs.
3. [juajar/](./juajar) shared modules (sysjar, liijar, WMs, bridge, hjemkey).
4. [resjar/](./resjar) docs, templates, images, scripts.

> Full breakdown in the [Directory Key](resjar/docbin/directory-key.md).

## Shell Aliases

The ones i actually use. Source of truth is [liijar/zsh](juajar/liijar/zsh/).

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

## Dev Section

Learning notes, module guides, and how the docs work: [Dev Key](resjar/docbin/dev-key.md).

> **Disclosure:** Parts of this config have been tinkered with using AI. All code is reviewed for understanding, and AI is used strictly for editing AI configs, mass searching for spelling errors, and similar tasks. This is a human-first config <3.
