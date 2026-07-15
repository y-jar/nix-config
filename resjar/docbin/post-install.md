**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Post Install

## What's Next to Do?
Some important things to do after installing:

### How do I switch to a newer version of the nixos config?
To switch to a newer version of the nixos config (after updating), you can run the following commands:
```bash
cd ~/nix-config && git add .
nrs # rebuild system with nixos-rebuild
nhs # rebuild system with nh (nix helper)
```

### How do I Update My System / Apps?
Depending on what, this can be done in two ways: `flatpak app updates`, or `system & system app updates`.

- **Apps On Flathub or Is A Flatpak**
  - Go in the appstore of your choice, navigate to updates, click update.
- **Apps in System And System**
  - > You would run this after a period of time, or making a change to the config.
  - Run `cd ~/nix-config` then run `git add .` so the command below can work `:)`
  - Run `nru` to update flake inputs and rebuild
  - Run `nhu` to rebuild using the nix helper
