**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Directory Key

The repo is four layers. Know what belongs in each and the tree explains itself.

```bash
.
├── flake.nix     # inputs + hosts (mkJar) + recovery ISOs (mkIso)
├── shell.nix     # installer shell (hardto, nhs, nht, jc, ...)
│
├── hstjar/       # per-host configs, one dir per machine
├── juajar/       # shared modules (system + user)
├── resjar/       # resources: docs, templates, images, scripts
└── .rotjar/      # scratch, gitignored
```

## The four layers

- **flake.nix** defines inputs and the host list. Each host is one `mkJar`
  line; `mkJar` wires everything else for you.
- **[hstjar/](../../hstjar)**: one dir per machine. Each holds a system side
  (`system.nix`, `boot.nix`, `hardware-configuration.nix`, ...) and a user side
  (`user.nix`). These are the only files you edit per host.
- **[juajar/](../../juajar)**: the shared logic, so hosts stay thin:
  - `sysjar/`: system modules, options under `sysset.*`, auto-imported
  - `liijar/`: user apps, options under `usrset.*`, auto-imported
  - `WMs/`: window managers, one dir each
  - `hjemkey.nix`: the user backend (hjem) wiring
  - `bridge.nix`: the only place `sysset` and `usrset` meet
- **[resjar/](../../resjar)**: resources such as `docbin/` (this doc), `nixbin/`
  (installer scripts), `imagebin/`, `fontbin/`, `shotbin/`.

For the module rules and how to add things, see
[Adding Modules](./adding-modules.md). For the user/system split, see
[Desktops & Shells](./desktops-shells.md) and the code in `juajar/`.
