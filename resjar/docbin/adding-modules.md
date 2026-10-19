**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

# Adding Modules Guide

When configuring, you'll often be told to add a *nixos module*, usually found in
[nixpkgs](https://github.com/NixOS/nixpkgs) or elsewhere. This is what i've
learned about how that actually works and how this flake is shaped.

## Modules and the flake, the short version

A module is a function that returns config. The module system collects them,
merges their options, and evaluates the result. An option is declared once and
set anywhere; everyone reads it back from `config`.

A flake is just inputs + outputs. Inputs are fetched and locked in `flake.lock`
(nothing is "usable" yet, just downloaded). Outputs build on those inputs — here,
the outputs are NixOS configurations:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    hjem.url = "github:feel-co/hjem"; # user backend (dotfiles + user packages)
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      HOSTNAME = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # hand the inputs to every module
        modules = [ ./path/to/system/entry.nix ];
      };
    };
  };
}
```

`@inputs` captures the whole input set so later modules can reach it. In this
repo you don't write that by hand — `mkJar "HOSTNAME"` builds the system and
wires the shared modules in for you.

## The shape of this repo

Two scopes, one rule each:

- **`sysjar/`** — system modules, options under `sysset.*`, auto-imported.
- **`liijar/`** — user apps, options under `usrset.*`, auto-imported by the hjem
  backend. Every app is one dir with a `default.nix`.

User apps are evaluated *inside* the user submodule, so an app writes `packages`
and `files.".config/app/config".source` directly — no `home.*` / `programs.*`.

> [!TIP]
> [cowsay/](../../juajar/liijar/cowsay) is the commented reference example. Read
> it; it explains itself and the gotchas.

## Adding an app (liijar)

1. declare the toggle (`usrset.<app>.enable`) in
   [`liijar/options.nix`](../../juajar/liijar/options.nix) — and only there
2. copy `cowsay/` to `liijar/<app>/` and put your packages/config in `default.nix`
3. flip the toggle in the host's `hstjar/<host>/user.nix`

That's it — `liijar/default.nix` auto-imports every app dir. No registration.

## Adding a system module (sysjar)

Same idea on the system side. One dir, `default.nix` with the options and the
config together:

```nix
{ config, lib, ... }:
let cfg = config.sysset.<feature>;
in {
  options.sysset.<feature>.enable = lib.mkEnableOption "<feature>";
  config = lib.mkIf cfg.enable { /* ... */ };
}
```

Open the firewall in the module that owns the service, not in `networking`.
Hosts flip it in `hstjar/<host>/system.nix`.

## Adding a window manager

One dir under [WMs/](../../juajar/WMs) holding everything about it: a system
half (`system.nix`) and a user half (`user.nix`), alongside the raw config data
and `host-inputs/<host>.<ext>`. Copy the closest existing WM and declare
`usrset.<wm>.*` in `liijar/options.nix`. See [Desktops & Shells](./desktops-shells.md).

## Naming conventions

- **dir name = option name** (`chatApps/` → `usrset.chatApps`); camelCase for
  multi-word names.
- **every toggle is `<name>.enable`**, including sub-features
  (`media.mpv.enable`, `dev.python.enable`). Plain bools are only for modes and
  settings.
- **gate with `lib.mkIf cfg.enable`** on the whole config. Use `lib.mkMerge` to
  compose several gated pieces — `//` does *not* compose `mkIf`.
- **declare options once.** `usrset.*` in `liijar/options.nix`; `sysset.*` in the
  module that owns them.
- **data is not a module.** Shared data goes in `juajar/data/`; raw WM config
  next to its WM. Data dirs have no `default.nix` so importers skip them.
- **no home-manager leftovers.** Files are keyed home-relative
  (`.config/app/x`, no `~/` prefix).

For where system facts come from (`sysset` vs `usrset` / `bridge.nix`), read the
comments in [`juajar/bridge.nix`](../../juajar/bridge.nix) — it's the one place
they meet.
