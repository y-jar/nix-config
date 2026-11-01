<div align="center">

<pre>
╃
 .▀▀█▀▀ .
   :▓.:
 . ▀▀ : ╃
</pre>

# ❄️ NixOS in a Jar

**A modular, toggle-driven NixOS flake.** <br>
One directory per host. Everything else is shared.

<a href="https://nixos.org/"><img src="https://img.shields.io/badge/NixOS-Official%20Site-5277C3?style=for-the-badge&logo=nixos&logoColor=white" alt="NixOS Official Website"/></a>
<a href="https://github.com/y-jar/nix-config/releases/latest"><img src="https://img.shields.io/github/v/release/y-jar/nix-config?style=for-the-badge&label=release&logo=github&logoColor=white&color=d65d0e" alt="Latest Release"/></a>
<a href="./resjar/docbin/key-key.md"><img src="https://img.shields.io/badge/Docs-Documentation%20Key-928374?style=for-the-badge&logo=markdown&logoColor=white" alt="Documentation Key"/></a>
<a href="./resjar/docbin/install-guide.md"><img src="https://img.shields.io/badge/Docs-Installation%20Guide-fe8019?style=for-the-badge&logo=linux&logoColor=white" alt="Installation Guide"/></a>

</div>

---

This is my personal NixOS flake: a fully modular setup split into **system-level** declarations (`sysset`) and **user-space** profiles (`usrset`, via [hjem](https://github.com/feel-co/hjem)). Every machine is one thin folder; the shared logic lives in `juajar/` and is auto-imported.

### Quick start

```bash
updatejar    # the whole loop: pull, test, ask to deploy
nhs          # deploy system config
nht          # test before deploying
nhc          # clean up old generations
```

New machine? Start with the [Installation Guide](./resjar/docbin/install-guide.md).

### How it works

- **One dir per host.** Every machine is a thin folder in `hstjar/`; shared logic is auto-imported from `juajar/`.
- **Toggle-sheet hosts.** Features flip on/off with plain `true`/`false` in each host's `system.nix` and `user.nix`.
- **Guided installer.** A custom shell scaffolds a host, grabs the live hardware config, and deploys.
- **Not flake-parts, not catch-all.** Simplicity first, no unwanted bloat.

```bash
flake.nix   # inputs + hosts (mkJar) + recovery ISOs (mkIso)
hstjar/     # one dir per machine
juajar/     # shared modules (sysjar, liijar, WMs, bridge, hjemkey)
resjar/     # docs, templates, images, scripts
```

<div align="center">
  <img src="resjar/shotbin/basicTile.png" alt="Jar's NixOS desktop" width="85%">
  <br>
  <sub>My daily driver, tiled and themed.</sub>
</div>

### Docs

- [Installation Guide](./resjar/docbin/install-guide.md): set up a new machine
- [Documentation Key](./resjar/docbin/key-key.md): everything else
- [Directory Key](./resjar/docbin/directory-key.md): the four layers of the repo
- [Quick Reference](./resjar/docbin/quickref.md): app catalogue and shell aliases
- [Dev Key](./resjar/docbin/dev-key.md): lessons, module guide, docs guide

> [!NOTE]
> For outsiders: start with the [Installation Guide](./resjar/docbin/install-guide.md), then the [Documentation Key](./resjar/docbin/key-key.md).

> [!WARNING]
> This config is intended for NixOS users only and is focused on my personal setup. Some of it may not apply to yours.

<sub><b>Disclosure:</b> Parts of this config have been tinkered with using AI. All code is reviewed for understanding, and AI is used strictly for editing configs, mass-searching for spelling errors, and similar tasks. This is a human-first config &lt;3</sub>
